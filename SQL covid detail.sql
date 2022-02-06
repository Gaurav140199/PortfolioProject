select *
From [dbo].['covid deaths$']
order by 1
-- Death percentage

select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from [dbo].['covid deaths$']
where location = 'india'
order by 1,2 


--show what percentage of population get infected
select location,date, total_cases,population,(total_cases/population)*100 as infected_percentage
from [dbo].['covid deaths$']

order by 1,2

-- show highest infection rate
select  location,population , MAX (total_cases) as highest_infected, MAX(total_cases/ population) *100 as infection_rate
from [dbo].['covid deaths$']
group by 
location, population
order by infection_rate desc

--showing highest death per population
select  location, MAX(cast(total_deaths as int)) as deaths
from [dbo].['covid deaths$']
where continent is not null
group by 
 location
order by deaths desc

-- lets break things in continent
select  location, MAX(cast(total_deaths as int)) as deaths
from [dbo].['covid deaths$']
where continent is null
group by 
 location
order by deaths desc

--continent with highest death count
select  continent, MAX(cast(total_deaths as int)) as deaths
from [dbo].['covid deaths$']

group by 
 continent
order by deaths desc


-- Looking Total Population vs  Vacinated population 
Select dea.continent ,  dea.location,dea.date,dea.population , convert(int,vac.new_vaccinations) as new
, SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location,dea.date) as total_vaccination
From ProtfolioProject..['covid deaths$'] dea
Join ProtfolioProject..covidvaccination$ vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3


--use cte
with popvsvac(continent,location, date, population,new,total_vaccination)
as
(
Select dea.continent ,  dea.location,dea.date,dea.population , convert(int,vac.new_vaccinations) as new
, SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location,dea.date) as total_vaccination
From ProtfolioProject..['covid deaths$'] dea
Join ProtfolioProject..covidvaccination$ vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null

)
select *, (total_vaccination/population)*100 as ev
from popvsvac



-- Temp Table
DROP table if exists #vaccinated
create table #vaccinated
(
continent  nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new numeric,
total_vaccination numeric
)

Insert into #vaccinated
Select dea.continent ,  dea.location,dea.date,dea.population , convert(int,vac.new_vaccinations) as new
, SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location,dea.date) as total_vaccination
From ProtfolioProject..['covid deaths$'] dea
Join ProtfolioProject..covidvaccination$ vac
on dea.location= vac.location
and dea.date= vac.date

select*
from #vaccinated
  

create view vaccinated as
  Select dea.continent ,  dea.location,dea.date,dea.population , convert(int,vac.new_vaccinations) as new
, SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location,dea.date) as total_vaccination
From ProtfolioProject..['covid deaths$'] dea
Join ProtfolioProject..covidvaccination$ vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null

Select * 
from vaccinated