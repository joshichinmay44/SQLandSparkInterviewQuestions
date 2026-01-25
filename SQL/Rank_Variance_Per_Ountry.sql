-- Compare the total number of comments made by users in each country during December 2019 and January 2020.

-- For each month, rank countries by their total number of comments in descending order. Countries with the same total should share the same rank, and the next rank should increase by one (without skipping numbers).

-- Return the names of the countries whose rank improved from December to January (that is, their rank number became smaller).
CREATE TABLE fb_comments_count (
    user_id INT,
    created_at TIMESTAMP,
    number_of_comments INT
);

-- DDL for fb_active_users table
CREATE TABLE fb_active_users (
    user_id INT PRIMARY KEY,
    country VARCHAR(100)
);

-- Sample insert statements
INSERT INTO fb_comments_count (user_id, created_at, number_of_comments) VALUES
(1, '2023-12-05 10:30:00', 5),
(2, '2023-12-15 14:20:00', 8),
(1, '2024-01-10 09:15:00', 3),
(2, '2023-12-15 14:20:00', 8),
(3, '2023-12-20 16:45:00', 12),
(2, '2024-01-05 11:00:00', 6);

INSERT INTO fb_active_users (user_id, country) VALUES
(1, 'USA'),
(2, 'UK'),
(3, 'Canada');


with grouped_comments as(
select extract(month from fc.created_at) as month, extract(year from fc.created_at) as year, sum(fc.number_of_comments) as total_comments,fb.country
from fb_comments_count fc
join fb_active_users fb on fc.user_id=fb.user_id
where extract(month from fc.created_at)=12 or extract(month from fc.created_at)=1
group by extract(month from fc.created_at),extract(year from fc.created_at),fb.country
)
,ranked_comments as (
select dense_rank() over(partition by month,year order by total_comments desc) as rn,
month,
year,
total_comments,
country
from grouped_comments
)
, next_ranks as (
select rn,lead(rn) over(partition by country order by year,month asc) as nxt_rn,country from ranked_comments
)
select country from next_ranks where nxt_rn<rn and nxt_rn is not null;