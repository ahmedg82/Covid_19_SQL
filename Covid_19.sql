
-- Data Exploration OF covid 19 DataSet in SQL Server.

select * 
from Portfolio_Project.dbo.CovidDeaths
where continent is not null 
order by 3,4

select * 
from Portfolio_Project.dbo.CovidVaccinations
where continent is not null 
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from Portfolio_Project.dbo.CovidDeaths
where continent is not null 
order by 1,2

--Looking at Total Cases VS Total Deathes 
--Show likelihood of dying if you contract covid in your country

select location,cast(date AS date) AS date ,total_cases,total_deaths,(total_deaths /total_cases) *100 AS DeathPercentage
from Portfolio_Project.dbo.CovidDeaths
where location like '%saud%' and  continent is not null 
order by 1,2 desc


--Looking at Total Cases VS population
--Show what percentage of popualtion got covid 

select location,cast(date AS date) AS date ,population,total_cases,(total_cases /population) *100 AS DeathPercentage
from Portfolio_Project.dbo.CovidDeaths
where location like '%states%' and
 continent is not null 
order by 1,2 desc


-- Looking at countries with Highest infection rate compared to population 

select location,population,max(total_cases) as HighestInfectionCount,max((total_cases /population)) *100 AS PercentagePopulationInfected
from Portfolio_Project.dbo.CovidDeaths
--where location like '%states%'
where continent is not null 
group by location,population
order by PercentagePopulationInfected desc

-- Looking at countries with Highest Death count per population 

select location,population,max(cast(total_deaths as int)) as HighestDeathCount
from Portfolio_Project.dbo.CovidDeaths
--where location like '%states%'
where continent is not null 
group by location,population
order by HighestDeathCount desc

-- Let's break things down by continent
-- Showing contintents with the highest death count per population 

select continent,max(cast(total_deaths as int)) as HighestDeathCount
from Portfolio_Project.dbo.CovidDeaths
--where location like '%states%'
where continent is not null 
group by continent
order by HighestDeathCount desc

--Global Numbers

select date,sum(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeath,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Portfolio_Project.dbo.CovidDeaths
where location like '%states%' and
 continent is not null 
group by date
order by 1,2 
 

 -- Looking at Total population vs Vaccination 

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
order by 2,3

--Use CTE

with popvsVac ( Continent,location,date,population,new_vaccinations,RollingpeopleVaccinated )
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)
select* ,(RollingpeopleVaccinated /population)*100
from popvsVac

---Temp Table 
DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations )) OVER (partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
--order by 2,3

select* ,(RollingpeopleVaccinated /population)*100
from #PercentPopulationVaccinated

-----

--Creating View to store data for later visualization 

Create View PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations )) OVER (partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
--order by 2,3

select *
from PercentPopulationVaccinated