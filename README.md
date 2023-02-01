# cyclistic-bikeshare
Cyclistic (Divvy) Bikeshare Case Study - Capstone Project for Google Data Analytics Professional Certificate

Objective

To analyze how members and casual riders utilize bikes differently in order to determine the best marketing strategy for increasing annual membership subscriptions.

Prepare Data

Datasets used are primary data directly downloaded from the bikeshare company website https://www.divvybikes.com/system-data
12 months of 2022 Datasets were compiled and merged into one single cvs file for data processing.
Data cleaning included eliminating duplicate row and white spaces, data points with ride duration <=0, rows with null values in bike start or return location. 4 outliers were removed in the long ride length's range after the outlier test. A number of outliers were kept in the data until they could be inspected and invalidated by the company. Data were separated into two datasets (ride duration < 3 hours and ride duration > 3 hours) for more in depth analysis. 


Process Phase


SQLite was used to process the dataset. SQL codes written for data processing and analysis is documented in 

Analyse Phase
To analyze bike usage, ride duration is an important factor. A new column 'ride duration' was calculated from ride start time and end time and added to dataset. Top bike stations and top routes were ranked using SQL for analysis. Ride dates are classified into weekend / weekday and added as an additional column for usage comparison.   Finalized datasets were imported into Tableau and visualized with various plots. Trends, patterns and relationships were identified and documented in the powerpoint presentation - https://docs.google.com/presentation/d/1eEnF-cGVGcZ82xgQ-yo-QwpkRvO9sdm6fwXs-wqbA-o/edit?usp=sharing

Share Phase

Tableau visualizations were shared and published at https://public.tableau.com/app/profile/rita.lam
Full analysis is summarized and shared in this powerpoint presentation - https://docs.google.com/presentation/d/1eEnF-cGVGcZ82xgQ-yo-QwpkRvO9sdm6fwXs-wqbA-o/edit?usp=sharing

Act Phase

Recommendations and action plans are summarized in the final slides of the powerpoint presentation - https://docs.google.com/presentation/d/1eEnF-cGVGcZ82xgQ-yo-QwpkRvO9sdm6fwXs-wqbA-o/edit?usp=sharing
