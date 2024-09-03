
select * from Portfolioproject.dbo.CovidDeaths$
select Location,date,total_cases,total_deaths,population from Portfolioproject.dbo.CovidDeaths$ order by 1,2

select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_rate
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
order by 1,2

select Location,date,total_cases,population,(total_cases/population)*100 as Susceptible_rate
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
order by 5 desc

select Location,Max(total_cases)as HighestinfectionCount,population,Max(total_cases/population)*100 as Maximum_Susceptible_rate
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
Group by location,population
order by 4 desc

select Location,Max(total_deaths)as HighestdeathCount,population,Max(total_deaths/population)*100 as Maximum_death_rate
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
Group by location,population
order by 2 desc



select Location,Max(cast(total_deaths as int))as HighestdeathCount
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
where continent is not null
Group by location
order by 2 desc



select continent,Max(cast(total_deaths as int))as HighestdeathCount
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
where continent is not null
Group by continent
order by 2 desc




select date,sum(new_cases)as Totalnewcases,SUM(cast(new_deaths as int)) as Total_new_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as new_death_percentage
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
where continent is not null
Group by date
order by 1,2




select sum(new_cases)as Totalnewcases,SUM(cast(new_deaths as int)) as Total_new_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as new_death_percentage
from Portfolioproject.dbo.CovidDeaths$ 
--where location like '%Sri Lanka%'
where continent is not null
--Group by date
order by 1,2





select * from Portfolioproject.dbo.CovidDeaths$ dea
join Portfolioproject.dbo.CovidVaccinations$ vac 
on dea.location= vac.location and dea.date=vac.date




select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations from Portfolioproject.dbo.CovidDeaths$ dea
join Portfolioproject.dbo.CovidVaccinations$ vac 
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 1,2,3



select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location) as TotalVaccination
from Portfolioproject.dbo.CovidDeaths$ dea
join Portfolioproject.dbo.CovidVaccinations$ vac 
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null 
order by 2,3

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as TotalVaccination
from Portfolioproject.dbo.CovidDeaths$ dea
join Portfolioproject.dbo.CovidVaccinations$ vac 
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3


--CTE
with popvsvac (continent,location,date,population,vaccinations,TotalnewVaccination) as (
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as TotalnewVaccination
--SUM(Cast(vac.new_vaccinations as int))/dea.population*100 as  percentageofTotal_new_Vaccination
from Portfolioproject.dbo.CovidDeaths$ dea
join Portfolioproject.dbo.CovidVaccinations$ vac 
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null )
--order by 2,3
select *,TotalnewVaccination/population*100 as TotalnewVaccination_percentage from popvsvac


--Temp Table

create table Vaccination_view 
(continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
vaccinations numeric,
TotalnewVaccination numeric)

insert into Vaccination_view 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as TotalnewVaccination
--SUM(Cast(vac.new_vaccinations as int))/dea.population*100 as  percentageofTotal_new_Vaccination
from Portfolioproject.dbo.CovidDeaths$ dea
join Portfolioproject.dbo.CovidVaccinations$ vac 
on dea.location= vac.location and dea.date=vac.date

select *, TotalnewVaccination/population*100 as TotalnewVaccination_percentage from Vaccination_view 



--view
create view Vaccination_v as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(Cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as TotalnewVaccination
--SUM(Cast(vac.new_vaccinations as int))/dea.population*100 as  percentageofTotal_new_Vaccination
from Portfolioproject.dbo.CovidDeaths$ dea
join Portfolioproject.dbo.CovidVaccinations$ vac 
on dea.location= vac.location and dea.date=vac.date