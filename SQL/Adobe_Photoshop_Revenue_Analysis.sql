
-- create
CREATE TABLE adobe_transactions (
  customer_id int,
  product varchar(100),
  revenue int
);

-- insert
INSERT INTO adobe_transactions VALUES (123, 'Photoshop', 50);
INSERT INTO adobe_transactions VALUES (123, 'Premier Pro', 100);
INSERT INTO adobe_transactions VALUES (123, 'After Effects',50);
INSERT INTO adobe_transactions VALUES (234, 'Illustrator', 200);
INSERT INTO adobe_transactions VALUES (234, 'Premier Pro', 100);


-- fetch 
SELECT * FROM adobe_transactions;

--List of customers who bought photoshop products and total amount of money they spent on other products

SELECT customer_id,sum(revenue)
FROM adobe_transactions where customer_id in
(
SELECT customer_id
from adobe_transactions where product='Photoshop'
) and product !='Photoshop' 
group by customer_id
