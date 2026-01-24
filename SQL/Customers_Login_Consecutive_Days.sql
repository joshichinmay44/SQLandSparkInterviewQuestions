-- Find all the users who were active for 3 consecutive days or more.

CREATE TABLE sf_events (
    user_id INT,
    record_date DATE
);

INSERT INTO sf_events VALUES 
(1, '2024-01-01'),
(1, '2024-01-02'),
(1, '2024-01-03'),
(2, '2024-01-01'),
(2, '2024-01-03'),
(3, '2024-01-02'),
(3, '2024-01-03'),
(3, '2024-01-04'),
(4, '2024-01-05'),
(4, '2024-01-06'),
(4, '2024-01-07'),
(4, '2024-01-08');

WITH ranked_user AS (
    SELECT
        user_id,
        record_date,
        DENSE_RANK() OVER (PARTITION BY user_id ORDER BY record_date ASC) AS user_rn,
        ROW_NUMBER() OVER (ORDER BY record_date ASC) AS general_rn
    FROM sf_events
    ORDER BY user_id
),

user_consecutive_days AS (
    SELECT
        user_id,
        general_rn - user_rn AS rn,
        COUNT(*) AS cnt
    FROM ranked_user
    GROUP BY user_id, general_rn - user_rn
    HAVING COUNT(*) = 3
)

SELECT user_id FROM user_consecutive_days;