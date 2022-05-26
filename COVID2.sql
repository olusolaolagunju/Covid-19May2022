
--Querries used for Covid-19 Project


SELECT *
FROM CovidProject..Sheet1$
order by location, date

SELECT *
FROM CovidProject..CovidVaccination24$
where new_vaccinations is not null
order by location, date


--COVID-19 Death Table Insights

--COUNTRY (Nigeria) INSIGHTS
--the ratio of Covid cases per death

SELECT location, date, total_cases, 
Convert (bigint, total_deaths) AS TotalDeath,
(Convert (bigint, total_deaths)/ total_cases)*100 AS DeathPercentage
FROM CovidProject..Sheet1$
WHERE location like '%Nigeria%'
order by 5 Desc

--population percenatge with covid
SELECT location, date, total_cases, population,
(total_cases/population)*100 AS PercentCasesPerPopulation
FROM CovidProject..Sheet1$
WHERE location like '%Nigeria%'
order by PercentCasesPerPopulation desc

--CONTINENT INSIGHTS
--TOTAL CASES ACROSS THE WORLD for Dashboard 1
SELECT  SUM(new_cases) as TotalCases, SUM(cast(new_deaths as bigint)) as TotalDeath,
(SUM(cast(new_deaths as bigint))/ SUM(new_cases))*100 as TotaldeathPercentage
FROM CovidProject..Sheet1$
WHERE continent IS NOT NULL
--Group by date
order by 1 DESC

--The countries total infection count for Dashboard 1
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
( MAX(total_cases)/population)*100 as PercentagePopulationInfected
FROM CovidProject..Sheet1$
WHERE Continent is not null
GROUP BY location, population
order by TotalCasesCount Desc

--The countries total infection count  for Dashboard 1
SELECT date, location, population, MAX(total_cases) AS HighestInfectionCount, 
( MAX(total_cases)/population)*100 as PercentagePopulationInfected
FROM CovidProject..Sheet1$
WHERE Continent is not null
and location like '%Kingdom'
GROUP BY date, location, population
order by date Desc

--CONTINNETS total death coount for Dashboard 1
SELECT continent, SUM(CONVERT(bigint, total_deaths)) AS TotaldeathsCount
FROM CovidProject..Sheet1$
WHERE Continent is not null
GROUP BY continent
order by TotaldeathsCount Desc

--countries total death coount
SELECT location, population, SUM(CONVERT(bigint, total_deaths)) AS TotaldeathsCount
FROM CovidProject..Sheet1$
WHERE Continent is not null
GROUP BY location, population
order by TotaldeathsCount Desc


--daily global covid-19 cases and death
SELECT date, 
SUM (total_cases)AS totalCases, SUM(CONVERT(bigint, total_deaths)) AS totaldeath,
(SUM(CONVERT(bigint, total_deaths))/SUM (total_cases))*100 AS PercentDeathPercentage
FROM CovidProject..Sheet1$
WHERE Continent is not null
Group by date
order by date Desc



--COVID-19 VACCINATION 
--COUNTRY PERCENTAGE OF PEOPLE THAT HAVE RECIEVED ATLEAST A SINGLE DOSE OF COVID-VACCINE

SELECT Death.location, Death.population,
MAX(cast(Vac.people_vaccinated as bigint)) as TotalPopVaccinated,
(MAX(cast(Vac.people_vaccinated as bigint))/ Death.population)*100 AS PercentagePopVacinated
FROM  CovidProject..Sheet1$ AS Death
JOIN CovidProject..CovidVaccination24$ AS Vac
ON Death.location =Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL 
GROUP BY Death.location, Death.population
ORDER BY Death.location



--COUNTRY PERCENTAGE OF PEOPLE THAT HAVE BEEN FULLY VACCINATED (2 COVID-19 DOSES)
SELECT Death.location, Death.population,
MAX(cast(people_fully_vaccinated as bigint)) as TotalPeopleFullyVaccinated,
(MAX(cast(Vac.people_vaccinated as bigint))/ Death.population)*100 AS PercentagePopFullyVacinated
FROM  CovidProject..Sheet1$ AS Death
JOIN CovidProject..CovidVaccination24$ AS Vac
ON Death.location =Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL 
GROUP BY Death.location, Death.population
ORDER BY Death.location


--USING CTE to show the percentage of population that have received a single covid-19 vaccine and percentage of peoplee fully vaccinated.
WITH VaccinationData (continent, location,  population, OneVaccineOrmore,PercentageOneVaccineOrmore,TotalPeopleFullyVaccinated,PercentagePopFullyVacinated ) AS 
(
SELECT Death.continent, Death.location, Death.population,
MAX(cast(Vac.people_vaccinated as bigint)) as OneVaccineOrmore,
(MAX(cast(Vac.people_vaccinated as bigint))/ Death.population)*100 AS PercentageOneVaccineOrmore,
MAX(cast(vac.people_fully_vaccinated as bigint)) as TotalPeopleFullyVaccinated,
(MAX(cast(Vac.people_fully_vaccinated as bigint))/ Death.population)*100 AS PercentagePopFullyVacinated
FROM  CovidProject..Sheet1$ AS Death
JOIN CovidProject..CovidVaccination24$ AS Vac
ON Death.location =Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL 
GROUP BY Death.location, Death.population,Death.continent
--ORDER BY Death.location
)
SELECT *
FROM VaccinationData 


--Create a TEMP Table for Dashboard 2

Drop Table if exists #VaccinationTable

Create Table #VaccinationTable
(
continent nvarchar(255),
location nvarchar(255),
population int,
OneVaccineOrmore bigint,
PercentageOneVaccineOrmore bigint,
TotalPeopleFullyVaccinated bigint,
PercentagePopFullyVacinated bigint
)
Insert into #VaccinationTable
SELECT Death.continent, Death.location, Death.population,
MAX(cast(Vac.people_vaccinated as bigint)) as OneVaccineOrmore,
(MAX(cast(Vac.people_vaccinated as bigint))/ Death.population)*100 AS PercentageOneVaccineOrmore,
MAX(cast(vac.people_fully_vaccinated as bigint)) as TotalPeopleFullyVaccinated,
(MAX(cast(Vac.people_fully_vaccinated as bigint))/ Death.population)*100 AS PercentagePopFullyVacinated
FROM  CovidProject..Sheet1$ AS Death
JOIN CovidProject..CovidVaccination24$ AS Vac
ON Death.location =Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL 
GROUP BY Death.location, Death.population,Death.continent
--ORDER BY Death.location




Create view VaccinationTable as
SELECT Death.continent, Death.location, Death.population,
MAX(cast(Vac.people_vaccinated as bigint)) as OneVaccineOrmore,
(MAX(cast(Vac.people_vaccinated as bigint))/ Death.population)*100 AS PercentageOneVaccineOrmore,
MAX(cast(vac.people_fully_vaccinated as bigint)) as TotalPeopleFullyVaccinated,
(MAX(cast(Vac.people_fully_vaccinated as bigint))/ Death.population)*100 AS PercentagePopFullyVacinated
FROM  CovidProject..Sheet1$ AS Death
JOIN CovidProject..CovidVaccination24$ AS Vac
ON Death.location =Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL 
GROUP BY Death.location, Death.population,Death.continent
--ORDER BY Death.location

select *
from  VaccinationTable 

