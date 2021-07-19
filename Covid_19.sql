
-- This is my first portfolio project 

select * 
from Portfolio_Project.dbo.CovidDeaths
order by 3,4

select * 
from Portfolio_Project.dbo.CovidVaccinations
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from Portfolio_Project.dbo.CovidDeaths
order by 1,2

--Looking at Total Cases VS Total Deathes 
--Show likelihood of dying if you contract covid in your country

select location,cast(date AS date) AS date ,total_cases,total_deaths,(total_deaths /total_cases) *100 AS DeathPercentage
from Portfolio_Project.dbo.CovidDeaths
where location like '%saud%'
order by 1,2 desc


--Looking at Total Cases VS population
--Show what percentage of popualtion got covid 

select location,cast(date AS date) AS date ,population,total_cases,(total_cases /population) *100 AS DeathPercentage
from Portfolio_Project.dbo.CovidDeaths
--where location like '%states%'
order by 1,2 desc


-- Looking at countries with Highest infection rate compared to population 

select location,population,max(total_cases) as HighestInfectionCount,max((total_cases /population)) *100 AS PercentagePopulationInfected
from Portfolio_Project.dbo.CovidDeaths
--where location like '%states%'
group by location,population
order by PercentagePopulationInfected desc