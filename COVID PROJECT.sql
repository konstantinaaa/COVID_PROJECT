-- TOTAL CASES VS TOTAL DEATHS
-- Shows likelihood of dying if a person contracts COVID-19 in Greece


SELECT location, date, total_cases, total_deaths, (total_deaths * 100.0 / total_cases) AS DeathPercentage
FROM CovidDeaths
WHERE location = 'Greece' AND continent IS NOT NULL
ORDER BY TRY_CONVERT(date, date, 103) DESC;


-- TOTAL CASES VS POPULATION
-- Shows what percentage of population infected with Covid

SELECT location, date, total_cases, population, (total_cases * 100.0 /population) AS PercentPopulationInfected
FROM CovidDeaths
ORDER BY TRY_CONVERT(date, date, 103) DESC;

-- COUNTRIES WITH HIGHEST INFECTION RATE

SELECT location, population,
	   MAX(total_cases) AS HighestInfectionCount,
	   MAX((total_cases * 100.0 / population)) AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Death Count per population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY TotalDeathCount DESC;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS 

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
		SUM(new_deaths) * 100.0 / SUM(new_cases) AS Death_Percentage
FROM CovidDeaths
WHERE continent IS NOT NULL;

-- TOTAL POPULATION VS VACCINATION
-- Calculate cumulative vaccinations per country using a window function
-- RollingPeopleVaccinated = cumulative sum of new vaccinations over time per country
-- Shows percentage of population that has received at least one Covid Vaccine

WITH Population_vs_Vaccination (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(TRY_CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, TRY_CONVERT(date, dea.date)) AS RollingPeopleVaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccinations1 AS vac 
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)
SELECT * , (RollingPeopleVaccinated * 100.0 / Population) AS PercentPopulationVaccinated
FROM Population_vs_Vaccination;

