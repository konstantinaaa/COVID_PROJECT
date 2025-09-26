-- Queries used for Tableau Project

-- 1

SELECT SUM(new_cases) AS total_cases, 
		SUM(new_deaths) AS total_deaths,
		SUM(new_deaths) * 100 / SUM(new_cases) AS DeathPercerntage
FROM CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY total_cases, total_deaths;


-- 2
-- We take these out as they are not included in the above queries and want to stay consistend

SELECT location, SUM(new_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NULL AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- 3

SELECT location, population, 
		MAX(total_cases) AS HighestInfectionCount,
		MAX(total_cases * 100.0 / population) AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- 4

SELECT location,
		population,
	    date,
		MAX(total_cases) AS HighestInfectionCount, 
		MAX(total_cases * 100.0 / population) AS PercentPopulationInfected
FROM CovidDeaths 
GROUP BY location, population, date 
ORDER BY PercentPopulationInfected DESC;
