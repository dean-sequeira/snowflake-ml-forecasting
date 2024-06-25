# snowflake-ml-forecasting
Applying the Snowflake ML forecasting function to daily bike-share counts from the Capital Bikeshare 2011 to 2012 dataset

The dataset contains the daily count of rental bikes between years 2011 and 2012 in Capital bikeshare system with the corresponding weather and seasonal information. Bike-sharing rental process is highly correlated to the environmental and seasonal settings. For instance, weather conditions, precipitation, day of week, season, hour of the day, etc. can affect the rental behaviors.

The file containt bike sharing counts aggregated on daily basis (day.csv - 731 rows, 16 columns)

### Data Dictionary

| Column Position | Attribute Name | Definition | Data Type   | Example                             | % Null Ratios |
|-----------------|----------------|------------|-------------|-------------------------------------|---------------|
| 1               | instant        | Record Index | Quantitative | 190, 7, 17180                       | 0             |
| 2               | dteday         | Date (Format: YYYY-MM-DD) | Quantitative | 2012-12-23, 2012-01-01, 2012-06-24 | 0             |
| 3               | season         | Season (1: spring, 2: summer, 3: fall, 4: winter) | Quantitative | 1, 2, 4                           | 0             |
| 4               | yr             | Year (0: 2011, 1: 2012) | Quantitative | 0, 1                               | 0             |
| 5               | mnth           | Month (1 to 12) | Quantitative | 1, 6, 12                            | 0             |
| 6               | holiday        | Weather day is holiday or not | Quantitative | 0, 1                               | 0             |
| 7               | weekday        | Day of the week | Quantitative | 0, 6, 3                             | 0             |
| 8               | workingday     | Working Day: If day is neither weekend nor holiday is 1, otherwise is 0 | Quantitative | 0, 1                             | 0             |
| 9               | weathersit     | Weather Situation (1: Clear, Few clouds, Partly cloudy, Partly cloudy; 2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist; 3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds; 4: Heavy Rain + Ice Pellets + Thunderstorm + Mist, Snow + Fog) | Quantitative | 1, 2, 3                       | 0             |
| 10              | temp           | Normalized temperature in Celsius. The values are derived via (t-t_min)/(t_max-t_min), t_min=-8, t_max=+39 (only in hourly scale) | Quantitative | 0.08, 0.22, 0.34                 | 0             |
| 11              | atemp          | Normalized feeling temperature in Celsius. The values are derived via (t-t_min)/(t_max-t_min), t_min=-16, t_max=+50 (only in hourly scale) | Quantitative | 0.0909, 0.2727, 0.303           | 0             |
| 12              | hum            | Normalized humidity. The values are divided to 100 (max) | Quantitative | 0.53, 0.8, 0.31                   | 0             |
| 13              | windspeed      | Normalized wind speed. The values are divided to 67 (max) | Quantitative | 0.194, 0, 0.2985                  | 0             |
| 14              | casual         | Count of casual users | Quantitative | 0, 2, 57                           | 0             |
| 15              | registered     | Count of registered users | Quantitative | 1, 0, 118                          | 0             |
| 16              | cnt            | Count of total rental bikes including both casual and registered | Quantitative | 1, 2, 175                         | 0             |


## Acknowledgement

This data set has been sourced [datasciencedojo](https://code.datasciencedojo.com/datasciencedojo/datasets/tree/master/Bike%20Sharing)
