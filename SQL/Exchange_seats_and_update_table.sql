CREATE TABLE seats (
    id INT,
    student VARCHAR(10)
);

INSERT INTO seats VALUES 
(1, 'Amit'),
(2, 'Deepa'),
(3, 'Rohit'),
(4, 'Anjali'),
(5, 'Neha'),
(6, 'Sanjay'),
(7, 'Priya');

select * from seats;

with new_seats as(
select id,case when id%2<>0 and lead(student) over(order by id) is not null then lead(student) over(order by id) 
when lead(student) over(order by id) is null then student else lag(student)
over(order by id) end as student, max(id) over() as mx from seats)
update s 
set s.student=n.student 
from seats s join new_seats n 
on s.id=n.id;

select * from seats;
