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

--Write a SQL query to find the winner in each group.
--The winner is each group is the player who scored the maximum total points within the group. In the case of tie, the lowest player_id wins.

with player_scores as (
select first_player as player_id, sum(first_score) as total_score from matches group by first_player
union all
select second_player as player_id, sum(second_score) as total_score from matches group by second_player)
,ranked_players as (
select p.player_id,p.group_id,total_score, row_number() over(partition by group_id order by total_score desc,p.player_id asc)
as rn from player_scores ps join players p
on ps.player_id=p.player_id
)
select player_id,group_id,total_score from ranked_players where rn=1

