

SELECT *
FROM CovidProject..Sheet1$
order by location, date

SELECT *
FROM CovidProject..CovidVaccination24$
where new_vaccinations is not null
order by location, date

SELECT location, SUM(convert(bigint, new_vaccinations)
)FROM CovidProject..CovidVaccination24$

GROUP BY location
order by location

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
--The countries total infection count
SELECT location, population, SUM(total_cases) AS TotalCasesCount
FROM CovidProject..Sheet1$
WHERE Continent is not null
GROUP BY location, population
order by TotalCasesCount Desc

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

--total global covid19 cases and death 
SELECT  
SUM (total_cases)AS totalCases, SUM(CONVERT(bigint, total_deaths)) AS totaldeath,
(SUM(CONVERT(bigint, total_deaths))/SUM (total_cases))*100 AS PercentDeathPercentage
FROM CovidProject..Sheet1$
WHERE Continent is not null



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


--Create a TEMP Table

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

