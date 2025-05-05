create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);


select * from players;

select * from matches;

--Write a SQL Query to find the winner in each group.
--The winner in each group is the player who scored the maximum total points within the group. In the case of tie, the lowest player_id wins. 

with group_wise_matches as
(
  select p.player_id,p.group_id,m.match_id,m.first_player as player,m.first_score as score
  from matches m 
  join players p 
  on p.player_id=m.first_player
  union all
  select p.player_id,p.group_id,m.match_id,m.second_player as player,m.second_score as score
  from matches m 
  join players p 
  on p.player_id=m.second_player
),
player_wise_points as(
select sum(score) as score,player,group_id
from group_wise_matches
group by player,group_id),
winner_score as(
select player,group_id,score,max(score) over(partition by group_id) as winner_score
from player_wise_points
)
,ranked_results as (
select group_id,player,score,row_number() over(partition by group_id order by player asc) as rn
from winner_score  where  score=winner_score
)
select group_id,player,score from ranked_results where rn=1;
