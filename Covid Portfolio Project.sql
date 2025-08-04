Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4



--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4



Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

 

Select Location, date, total_cases, total_deaths, (cast(Total_deaths as decimal)/total_cases )*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2



Select Location, date, population, total_cases, (cast(total_cases as decimal)/population)*100 as PercentPopulationInfected
From PortfolioProject.. CovidDeaths
Where location like '%states%'
order by 1,2



Select Location, population, MAX(total_cases) as HighestInfectionCount, Max(cast(total_cases as float)/population )*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc



Select continent, MAX(cast(Total_deaths as int)) TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc



Select SUM(cast(new_cases as int)) as total_cases,SUM(cast(new_deaths as int))as total_deaths, SUM(cast(New_deaths as float))/SUM(cast(New_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null                 
--Group by date
order by 1,2




with popvsVac(continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   On dea.location=vac.location
   and dea.date=vac.date
   where dea.continent is not null
   --order by 2,3
   )
    select *, (cast(RollingPeopleVaccinated as float)/population)*100
   from popvsVac





   DROP table if exists #percentpopulationvaccinated
   create table #percentpopulationvaccinated
   (
   continent nvarchar(255),
   location nvarchar(255),
   date datetime,
   population numeric,
   new_vaccinations numeric,
   Rollingpeoplevaccinated numeric,
   )

   insert into #percentpopulationvaccinated
   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RolligPeopleVaccinated
--, (RolligPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   On dea.location=vac.location
   and dea.date=vac.date
   --where dea.continent is not null
   --order by 2,3

     select *, (RollingPeopleVaccinated/population)*100
   from #percentpopulationvaccinated


  
   Create View percentpopulationvaccinated as
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RolligPeopleVaccinated
--, (RolligPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   On dea.location=vac.location
   and dea.date=vac.date
   where dea.continent is not null
   --order by 2,3


   select * 
   from  percentpopulationvaccinated
