SELECT cd.continent, cd.date, cd.population, cd.location, cd.new_cases, cv.new_vaccinations
  FROM CovidDeaths as cd
  Join CovidVacinations as cv
  on cd.location= cv.location
  and cd.date=cv.date
  where cd.continent is not NULL
  order by 2,3

-- new vaccinations per day

 SELECT cd.continent, cd.date, cd.population, cd.location, cv.new_vaccinations,
 SUM(cast (cv.new_vaccinations as bigint)) OVER (Partition by cd.location order by cd.location, cd.date) as rollingpelevaccnated
  FROM CovidDeaths as cd
  Join CovidVacinations as cv
  on cd.location= cv.location
  and cd.date=cv.date
  where cd.continent is not NULL
  and cv.new_vaccinations is not NULL
  and cd.location  like '%india%'
  order by 4 

-- CTE
With popvcvac (continent, location, date, population, new_vaccinations, rollingpelevaccnated )
as (
SELECT cd.continent, cd.date, cd.population, cd.location, cv.new_vaccinations,
 SUM(cast (cv.new_vaccinations as bigint)) OVER (Partition by cd.location order by cd.location, cd.date) as rollingpelevaccnated
  FROM CovidDeaths as cd
  Join CovidVacinations as cv
  on cd.location= cv.location
  and cd.date=cv.date
  where cd.continent is not NULL
  and cv.new_vaccinations is not NULL
  and cd.location  like '%india%'
 )
 Select *
 from popvcvac


-- temp table
DROP table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
rollingpelevaccnated numeric
)
insert into #percentpopulationvaccinated
SELECT cd.continent, cd.date, cd.population, cd.location, cv.new_vaccinations,
 SUM(cast (cv.new_vaccinations as numeric)) OVER (Partition by cd.location order by cd.location, cd.date) as rollingpelevaccnated
  FROM CovidDeaths as cd
  Join CovidVacinations as cv
  on cd.location= cv.location
  and cd.date=cv.date
  where cd.continent is not NULL
  and cv.new_vaccinations is not NULL

SELECT *
from #percentpopulationvaccinated


-- create view

Create view PeopleVaccinated as
SELECT cd.continent, cd.date, cd.population, cd.location, cv.new_vaccinations,
 SUM(cast (cv.new_vaccinations as bigint)) OVER (Partition by cd.location order by cd.location, cd.date) as rollingpelevaccnated
  FROM CovidDeaths as cd
  Join CovidVacinations as cv
  on cd.location= cv.location
  and cd.date=cv.date
  where cd.continent is not NULL
  and cv.new_vaccinations is not NULL
  and cd.location  like '%india%'


select * from PeopleVaccinated



