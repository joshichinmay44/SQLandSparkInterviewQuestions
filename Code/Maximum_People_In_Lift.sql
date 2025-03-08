create table lifts(LIFT_ID INT,CAPICITY_KG INT);

INSERT INTO lifts VALUES(1,300);
INSERT INTO lifts VALUES(2,350);

create table lift_passangers (PASSANGER_NAME VARCHAR (100),WEIGHT_KG INT ,LIFT_ID INT);

insert into lift_passangers VALUES ('ASHISH',85,1);
insert into lift_passangers VALUES ('YATIN',73,1);
insert into lift_passangers VALUES ('AMAN',95,1);
insert into lift_passangers VALUES ('VIJAY',80,1);
insert into lift_passangers VALUES ('AAKASH',83,2);
insert into lift_passangers VALUES ('ANKIT',77,2);
insert into lift_passangers VALUES ('MAYANK',73,2);
insert into lift_passangers VALUES ('KRISH',85,2);

select * from lifts;

select * lift_passangers;

--You are given a table of list of lifts, their maximum capacity and people along with their weight who wants to enter into it. 
--You need to make sure maximum people enter into the lift without lift getting overloaded.
--For each lift find the comma separated list of people who can be accommodated. The comma separated list should have people in the order of their weight in increasing order, display the output in increasing order of id.

For each lift find the comma separated list of people who can be accommodated. The comma separated list should have people in the order of their weight in increasing order, display the output in increasing order of id.

with joined_data as 
(
  select PASSANGER_NAME,WEIGHT_KG,lp.LIFT_ID,CAPICITY_KG ,sum(WEIGHT_KG) over(partition by lp.LIFT_ID order by WEIGHT_KG asc) as weight from 
  lift_passangers lp
  join lifts l on l.LIFT_ID=lp.LIFT_ID
)
select LIFT_ID,STRING_AGG(PASSANGER_NAME,',') within group(order by weight asc) from joined_data
where weight<CAPICITY_KG
group by LIFT_ID;
