create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

with teams as (select team_1 as team from icc_world_cup
union
select Team_2  from icc_world_cup
),
matches_played as
(
  select count(1) as no_of_matches_played, team from 
  (select team_1 as team from icc_world_cup
union all
select Team_2  from icc_world_cup) t group by team
)
, winners as (
select winner,count(1) as no_of_wins from icc_world_cup group by winner
),
losers as (
select case when team_1 <> winner then team_1 else team_2 end as losers,
count(1) as no_of_losses from icc_world_cup group by case when team_1 <> winner then team_1 else team_2 end
)
select t.team, no_of_matches_played,  case when no_of_wins is null then 0 else no_of_wins end, 
case when no_of_losses is null then 0 else no_of_losses end
from
teams t
join matches_played m on t.team=m.team
left join winners w on t.team = w.winner
left  join losers l on t.team=l.losers 
order by team