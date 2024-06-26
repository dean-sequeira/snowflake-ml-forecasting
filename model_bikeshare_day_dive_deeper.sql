USE SCHEMA dev_analytics.dev_deansequeira;

----------- lets take a look at the data -------------------------------------------------------------------------------
SELECT *
FROM capital_bikeshare_day
ORDER BY dteday
LIMIT 10;

----------- dive deeper: Train using features --------------------------------------------------------------------------
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST model_bikeshare_day_v2(
  INPUT_DATA => TABLE(SELECT
                  TO_TIMESTAMP_NTZ(dteday) AS dteday,
                  season,
                  yr,
                  mnth,
                  holiday,
                  weekday,
                  workingday,
                  weathersit,
                  temp,
                  atemp,
                  hum,
                  windspeed,
                  cnt
                  FROM capital_bikeshare_day),
  TIMESTAMP_COLNAME => 'dteday',
  TARGET_COLNAME => 'cnt'
);

----------- review feature importance ----------------------------------------------------------------------------------
call model_bikeshare_day_v2!EXPLAIN_FEATURE_IMPORTANCE();

call model_bikeshare_day_v2!SHOW_EVALUATION_METRICS();


----------- retrain model with only top features -----------------------------------------------------------------------
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST model_bikeshare_day_v2(
  INPUT_DATA => TABLE(SELECT
                  TO_TIMESTAMP_NTZ(dteday) AS dteday,
                  temp,
                  hum,
                  windspeed,
                  cnt
                  FROM capital_bikeshare_day),
  TIMESTAMP_COLNAME => 'dteday',
  TARGET_COLNAME => 'cnt'
);



----------- create temp table to store forecast input data -------------------------------------------------------------
CREATE OR REPLACE TEMP TABLE temp_fcst_input_bikeshare_day AS
    (WITH prev_year_weathwe AS
        (SELECT to_char(dteday, 'mm-dd') AS mm_dd
              , temp
              , hum
              , windspeed
         FROM capital_bikeshare_day
         WHERE yr = 1)

        -- generate dates for 2013 our forecast period
        , forecast_period AS
            (SELECT DATEADD(DAY, SEQ4(), '2013-01-01') AS dteday
             FROM TABLE (GENERATOR(ROWCOUNT => 365))
             WHERE DATEADD(DAY, SEQ4(), '2013-01-01') < '2014-01-01')

     SELECT TO_TIMESTAMP_NTZ(dteday) AS dteday
          , temp
          , hum
          , windspeed
     FROM forecast_period f
              LEFT JOIN prev_year_weathwe p ON to_char(f.dteday, 'mm-dd') = p.mm_dd
     ORDER BY dteday);


----------- review the temp forecast input data ------------------------------------------------------------------------
SELECT *
FROM temp_fcst_input_bikeshare_day
LIMIT 100


----------- forecast using the model -----------------------------------------------------------------------------------
CALL model_bikeshare_day_v2!FORECAST(
    INPUT_DATA => TABLE (temp_fcst_input_bikeshare_day),
    TIMESTAMP_COLNAME =>'dteday');



----------- use RESULT_SCAN to view the predictions and write them to a table ------------------------------------------
CREATE OR REPLACE TABLE fcst_output_v2_bikeshare_day AS
    (WITH forecast_output AS
              (SELECT ts::DATE AS dteday
                    , forecast
                    , lower_bound
                    , upper_bound
               FROM TABLE (RESULT_SCAN(-1)))

     SELECT dteday
          , forecast
          , upper_bound
     FROM forecast_output
     GROUP BY ALL);

----------- review actual with forecast --------------------------------------------------------------------------------
WITH actual AS
    (SELECT dteday
          , cnt
          , NULL AS forecast
     FROM capital_bikeshare_day)

   , forecasted AS
    (SELECT dteday
          , NULL AS cnt
          , forecast
     FROM fcst_output_v2_bikeshare_day)

SELECT *
FROM actual
UNION ALL
SELECT *
FROM forecasted
ORDER BY dteday;
