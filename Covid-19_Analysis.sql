Select *
From PortfolioProject.dbo.['owid-covid-data$']
Where continent is not null
Order by 3,4


Select *
From PortfolioProject.dbo.[vaccination$]
Order by 3,4


-- Select the data that you're going to use

Select location, date, total_cases, new_cases, new_deaths_smoothed, population_density
From PortfolioProject.dbo.['owid-covid-data$']
Where continent is not null
Order by 1,2


--Looking at new_deaths_smoothed vs total_cases 
Select location, date, total_cases, new_deaths_smoothed, (new_deaths_smoothed/total_cases)*100 as Death_Percentage
From PortfolioProject.dbo.['owid-covid-data$']
Where location like '%India%' and continent is not null
Order by 1,2

-- Looking at new cases vs total cases
Select location, date, total_cases, new_cases, (new_cases/total_cases)*100 as New_Death_Percentage
From PortfolioProject.dbo.['owid-covid-data$']
Where location like '%India%' and continent is not null
Order by 1,2


-- Contries with highest number of cases compared to population_density

Select location, population_density, MAX(total_cases) as HighestInfectedCountry, Max(total_cases/population_density)*100 as Heighest_Death_Percentage
From PortfolioProject.dbo.['owid-covid-data$']
-- Where location like '%India%'
Where continent is not null
Group by location, population_density
Order by Heighest_Death_Percentage desc


--Showing the countries with highest deaths count per population

Select location, MAX(cast(new_deaths_smoothed as int)) as highest_death_count
From PortfolioProject.dbo.['owid-covid-data$']
Where continent is not null
Group by location
Order by highest_death_count desc


-- Let's break things down by continent

Select continent, MAX(cast(new_deaths_smoothed as int)) as highest_death_count
From PortfolioProject.dbo.['owid-covid-data$']
Where continent is not null
Group by continent
Order by highest_death_count desc



-- Global Numbers


Select sum(new_cases), sum(cast (total_deaths_per_million as int)) as total_deaths , sum(cast(new_cases/total_deaths_per_million as int))*100 as death_pct
From PortfolioProject.dbo.['owid-covid-data$']
Where continent is not null
--Group by date 
Order by 1,2 desc


--Joining two tables

Select *
From PortfolioProject.dbo.['owid-covid-data$'] dea
Join PortfolioProject.dbo.vaccination$ vac
 on dea.location =  vac.location
and dea.continent = vac.continent



-- lOOKING AT TOTAL POPULATION VS VACCINATION
-- CTE

With PopvsVac (continent, location, date, population_density, weekly_hosp_admissions_per_million, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.date, dea.location, dea.population_density, vac.weekly_hosp_admissions_per_million
, SUM(Convert(int, vac.weekly_hosp_admissions_per_million)) OVER (Partition by dea.location Order by dea.location, dea.date) as
   RollingPeopleVaccinated
   --, (RollingPeopleVaccinated/population_density)
From PortfolioProject.dbo.['owid-covid-data$'] dea
Join PortfolioProject.dbo.vaccination$ vac
 on dea.location =  vac.location
and dea.continent = vac.continent
where dea.continent is not null
)
Select * 
From PopvsVac




-- Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population_density numeric,
weekly_hosp_admissions_per_million numeric,
RollingPeopleVaccinated numeric
) 

Insert into
Select dea.continent, dea.date, dea.location, dea.population_density, vac.weekly_hosp_admissions_per_million
, SUM(Convert(int, vac.weekly_hosp_admissions_per_million)) OVER (Partition by dea.location Order by dea.location, dea.date) as
   RollingPeopleVaccinated
   --, (RollingPeopleVaccinated/population_density)
From PortfolioProject.dbo.['owid-covid-data$'] dea
Join PortfolioProject.dbo.vaccination$ vac
 on dea.location =  vac.location
and dea.continent = vac.continent
where dea.continent is not null
)
Select * , (RollingPeopleVaccinated/population_density)
From #PercentPopulationVaccinated


-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject.dbo.['owid-covid-data$']
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths_smoothed as int)) as TotalDeathCount
From PortfolioProject.dbo.['owid-covid-data$']
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, population_density, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population_density))*100 as PercentPopulationInfected
From PortfolioProject.dbo.['owid-covid-data$']
--Where location like '%states%'
Group by Location, population_density
order by PercentPopulationInfected desc



-- 4.


Select Location, population_density,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population_density))*100 as PercentPopulationInfected
From PortfolioProject.dbo.['owid-covid-data$']
--Where location like '%states%'
Group by Location, population_density, date
order by PercentPopulationInfected desc

