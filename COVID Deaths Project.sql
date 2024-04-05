SELECT *
FROM raw.covid_deaths



SELECT *
FROM raw.covid_vaccinations


SELECT 
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM raw.covid_deaths
WHERE continent is NOT NULL
ORDER BY 1,2;

--LOOKING AT TOAL CASES VS TOTAL DEATHS.
---Shows the liklihood of dying if you contract covid in your country
SELECT 
	location,
	date,
	total_cases,
	total_deaths,
	ROUND(((total_deaths/total_cases)*100),2) AS Death_Percent
FROM raw.covid_deaths
WHERE location like '%Kingdom%'
and continent is NOT NULL
ORDER BY 1,2;


--Looking at the total cases Vs population
----shows what % of population got covid
SELECT 
	location,
	date,
	total_cases,
	population,
	ROUND(((total_cases/population)*100),2) AS case_Percent
FROM raw.covid_deaths
WHERE location like '%Kingdom%'
and continent is NOT NULL
ORDER BY 1,2;

--Looking at countries with highest infection rate compared population
SELECT 
	location,
	MAX(total_cases) Highest_Cases,
	population,
	ROUND((Max(total_cases)/population)*100,2) AS Percent_population_infected
FROM raw.covid_deaths
WHERE continent is NOT NULL
Group BY location,population
ORDER BY Percent_population_infected DESC;

----showing the countries with higheat death count per populationn
SELECT 
	location,
	MAX(total_deaths) Total_death_count,
	population,
	ROUND((Max(total_deaths)/population)*100,2) AS Percent_population_deaths
FROM raw.covid_deaths
WHERE continent is NOT NULL
Group BY location,population
ORDER BY Percent_population_deaths DESC;

SELECT 
	location,
	MAX(total_deaths) Total_death_count
FROM raw.covid_deaths
WHERE continent is NOT NULL
Group BY location
ORDER BY Total_death_count DESC;

--Lets break things by continent


SELECT 
	location,
	MAX(total_deaths) Total_death_count
FROM raw.covid_deaths
WHERE continent is NULL
Group BY location
ORDER BY Total_death_count DESC;

---showing the continent with highest death count per population
SELECT 
	continent,
	MAX(total_deaths) Total_death_count
FROM raw.covid_deaths
WHERE continent is NOT NULL
Group BY continent
ORDER BY Total_death_count DESC;

--Global Numbers

SELECT 
	date,
	SUM(new_cases) Total_new_cases,
	SUM(new_deaths)Total_new_deaths,
	ROUND((SUM(new_deaths)/(SUM(new_cases)))*100,2) AS Death_Percent
FROM raw.covid_deaths
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2;

---Looking at total population vs total vaccinations
SELECT 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.date,cd.location) Rolling_Vaccinations
FROM raw.covid_deaths cd
JOIN raw.covid_vaccinations cv
	ON cd.location = cv.location
	and cd.date = cv.date
WHERE cd.continent is NOT NULL
ORDER BY 2,3

--How many people in a country vaccinated (Rolling_Vaccinations/Population)

---USE OF CTE
WITH popvsvac AS(
	SELECT 
		cd.continent,
		cd.location,
		cd.date,
		cd.population,
		cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.date,cd.location) Rolling_Vaccinations
	FROM raw.covid_deaths cd
	JOIN raw.covid_vaccinations cv
		ON cd.location = cv.location
		and cd.date = cv.date
	WHERE cd.continent is NOT NULL
	ORDER BY 2,3
)
SELECT *, ROUND((Rolling_Vaccinations/population)*100,3) Percent_POP_vacc
FROM popvsvac
ORDER BY location, date;

---Creating a View

CREATE VIEW RAW.PercentPopulationVaccinated AS
SELECT 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.date,cd.location) Rolling_Vaccinations
FROM raw.covid_deaths cd
JOIN raw.covid_vaccinations cv
	ON cd.location = cv.location
	and cd.date = cv.date
WHERE cd.continent is NOT NULL
ORDER BY 2,3

SELECT * 
FROM RAW.PercentPopulationVaccinated
