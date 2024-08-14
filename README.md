# COVID-19 Data Analysis

## Project Overview
This project analyzes COVID-19 data to extract meaningful insights about the pandemic's impact across different countries and continents. Using SQL, we explore various aspects of the data including case numbers, death rates, and vaccination progress.

## Data Source
The analysis uses two main datasets:
- `covid_deaths`: Contains information about COVID-19 cases and deaths.
- `covid_vaccinations`: Contains data about COVID-19 vaccinations.

## Key Analyses

1. **Total Cases vs Total Deaths**: Calculates the likelihood of dying if contracting COVID in a specific country.
2. **Total Cases vs Population**: Shows the percentage of population infected with COVID.
3. **Countries with Highest Infection Rate**: Identifies countries with the highest infection rates relative to their population.
4. **Countries with Highest Death Count**: Analyzes total death counts per country and continent.
5. **Global Numbers**: Aggregates new cases, deaths, and calculates death percentages globally over time.
6. **Total Population vs Vaccinations**: Explores the progress of vaccinations in relation to the population.

## SQL Techniques Used

- Joins
- CTEs (Common Table Expressions)
- Window Functions
- Aggregate Functions
- Creating Views

## How to Use

1. Clone this repository.
2. Ensure you have access to a SQL database (PostgreSQL recommended).
3. Import the provided datasets into your database.
4. Run the SQL queries in the `covid_analysis.sql` file.

## Sample Queries

```sql
-- Looking at Total Cases vs Total Deaths
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND(((total_deaths/total_cases)*100),2) AS Death_Percent
FROM raw.covid_deaths
WHERE location like '%Kingdom%'
AND continent is NOT NULL
ORDER BY 1,2;

-- More queries can be found in the covid_analysis.sql file
```

## Future Work

- Incorporate more recent data for ongoing analysis.
- Develop visualizations based on the SQL query results.
- Perform predictive analysis on future trends.

## Contact

For any questions or feedback, please reach out.
