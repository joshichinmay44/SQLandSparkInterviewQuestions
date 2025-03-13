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

with group_table as 
(
select distinct p.group_id,m.match_id, case when first_score>second_score then m.first_player 
when first_score=second_score then case when first_player<second_player then first_player else second_player
end
else m.second_player end as winner
, case when first_score>second_score then first_score-second_score else second_score-first_score end margin 
from players p
join matches m on p.player_id=m.first_player or p.player_id=m.second_player
)
, winners as (
select distinct group_id,match_id,winner,margin,count(1) over(partition by group_id,winner) as no_of_wins, max(margin) over (partition by group_id) as max_margin
from group_table
)
select group_id,winner as player_id from winners where margin=max_margin
