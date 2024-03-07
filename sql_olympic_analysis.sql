USE excercise;

-- 1. How many olympics games have been held?
SELECT COUNT(DISTINCT Games) 
FROM olympic_history;

-- 2. List down all Olympics games held so far.
SELECT distinct year, season, city
from olympic_history
order by year;

-- 3. Mention the total no of nations who participated in each olympics game?
select games, count(distinct NOC) as number_of_countries
from olympic_history 
group by games
order by games; 

-- 4. Which year saw the highest and lowest no of countries participating in olympics?
with cte as 
	(
	select distinct games, count(distinct noc) as totall_no_co
    from olympic_history
    group by games)
    select  distinct  concat(first_value(games) over(order by totall_no_co), ' - ', first_value(totall_no_co) over(order by totall_no_co)) as lowest, 
	concat(first_value(games) over(order by totall_no_co desc ), ' - ', first_value(totall_no_co) over(order by totall_no_co desc)) as highest
    from cte;
    
-- 5. Which nation has participated in all of the olympic games?
with olympic_per_co as(
	select region, count(distinct games) as no_oly
    from olympic_history oh
    join noc_regions nr on nr.noc = oh.noc 
	group by region
    order by 2 desc
)
select region as country
from olympic_per_co
where no_oly = 50;


-- 6. Identify the sport which was played in all summer olympics.

select count(distinct games)
from olympic_history 
where season = 'summer'; -- 29

with cte as (
select sport, count(distinct games) as no_of_oly
from olympic_history
where season = 'summer'
group by sport
)
select sport 
from cte
where no_of_oly = 29;

-- 7. Which Sports were just played only once in the olympics?

  with t1 as
          	(select distinct games, sport
          	from olympic_history),
          t2 as
          	(select sport, count(1) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport;


-- 8. Fetch the total no of sports played in each olympic games.
select games, count(distinct sport) as no
from olympic_history 
group by games
order by no desc;

  
-- 9. Fetch details of the oldest athletes to win a gold medal.
with cte as (
select *
from olympic_history 
where medal = 'Gold' )
select * from cte
where age = (select max(age) from cte);


-- 10. Find the Ratio of male and female athletes participated in all olympic games.

with male as(
	SELECT count(*) as m
    from olympic_history
    where sex = 'M'
    group by sex), 
    female as (
    SELECT count(*) as f
    from olympic_history
    where sex = 'F'
    group by sex)
select f/m as stosunek 
from male, female;


-- 11. Fetch the top 5 athletes who have won the most gold medals.

select distinct name, team, count(medal) as no_medal
from olympic_history
where medal = 'gold' 
group by name, team 
order by no_medal desc
limit 5;

    
-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
select distinct name, team, count(medal) as no_medal
from olympic_history
where medal <> 'na'
group by name, team 
order by no_medal desc
limit 5;

-- 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

select distinct region as country, count(medal) as no_medal
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal <> 'na'
group by region
order by no_medal desc
limit 5;

-- 14. List down total gold, silver and broze medals won by each country.
with t1 as(
select region, count(medal) as g
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='gold'
group by region),
t2 as(
select region, count(medal) as s
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='silver'
group by region),
t3 as(
select region, count(medal) as b
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='bronze'
group by region)
select t1.region, g, s, b
from t1
join t2 on t1.region=t2.region
join t3 on t2.region=t3.region
order by g,s,b desc;

-- 15. List down total gold, silver and broze medals won by each country corresponding to each olympic games.
with t1 as(
select  region, games, count(medal) as g
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='gold'
group by region, games),
t2 as(
select  region, games, count(medal) as s
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='silver'
group by region, games),
t3 as(
select  region, games, count(medal) as b
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='bronze'
group by region, games)
select t1.region, t1.games, g, s, b
from t1
join t2 on t1.region=t2.region and t1.games=t2.games
join t3 on t2.region=t3.region and t2.games=t3.games
order by games;


-- 16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
with t1 as(
select  region, games, count(medal) as g
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='gold'
group by region, games),
t2 as(
select  region, games, count(medal) as s
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='silver'
group by region, games),
t3 as(
select  region, games, count(medal) as b
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal='bronze'
group by region, games),
t4 as(
select t1.games, max(g) as max_gold, max(s) as max_s, max(b) as max_b
from t1
join t2 on t1.region=t2.region and t1.games=t2.games
join t3 on t2.region=t3.region and t2.games=t3.games
group by t1.games)
select distinct t1.games, concat(first_value(t1.region) over(order by g), ' - ', first_value(g) over(order by g)), 
concat(first_value(t1.region) over(order by s), ' - ', first_value(s) over(order by s)), concat(first_value(t1.region) over(order by b), ' - ', first_value(b) over(order by b))
from t1
join t2 on t1.region=t2.region and t1.games=t2.games
join t3 on t2.region=t3.region and t2.games=t3.games
order by t1.games;

-- 17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.



-- 18. Which countries have never won gold medal but have won silver/bronze medals?

select distinct region 
from olympic_history oh 
join noc_regions n on n.noc=oh.noc
where medal in ('Silver', 'Bronze');

-- 19. In which Sport/event, India has won highest medals.
select sport, count(medal) as num
from olympic_history oh
join noc_regions n on n.noc=oh.noc
where medal <> 'na' and region = 'India'
group by sport, region
order by num desc
limit 1;


-- 20. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
select team, sport, games, count(medal) as total_medals
from olympic_history 
where team = 'India' and sport = 'Hockey' and medal <> 'na'
group by team, sport, games
order by total_medals;
