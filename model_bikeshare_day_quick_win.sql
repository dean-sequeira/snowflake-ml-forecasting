USE SCHEMA dev_analytics.dev_deansequeira;

----------- lets take a look at the data -------------------------------------------------------------------------------
SELECT *
FROM capital_bikeshare_day
ORDER BY dteday
LIMIT 10;

----------- quick win: let's see what the simplest forecast produces ---------------------------------------------------
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST model_bikeshare_day_v1(
  INPUT_DATA => TABLE(SELECT TO_TIMESTAMP_NTZ(dteday) AS dteday, cnt FROM capital_bikeshare_day),
  TIMESTAMP_COLNAME => 'dteday',
  TARGET_COLNAME => 'cnt'
);

----------- review feature importance ----------------------------------------------------------------------------------
call model_bikeshare_day_v1!EXPLAIN_FEATURE_IMPORTANCE();
call model_bikeshare_day_v1!SHOW_EVALUATION_METRICS();


----------- call the model to forecast the next 365 days ---------------------------------------------------------------
CALL model_bikeshare_day_v1!FORECAST(FORECASTING_PERIODS => 365);

----------- use RESULT_SCAN to view the predictions and write them to a table ------------------------------------------
CREATE OR REPLACE TABLE fcst_output_v1_bikeshare_day AS
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
     FROM fcst_output_v1_bikeshare_day)

SELECT *
FROM actual
UNION ALL
SELECT *
FROM forecasted
ORDER BY dteday;