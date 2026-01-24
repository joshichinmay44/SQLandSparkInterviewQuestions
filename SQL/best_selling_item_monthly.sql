--generate a report showing the best selling item (by total sales amount) for each month

CREATE TABLE online_retail (
    invoicedate TIMESTAMP,
    description VARCHAR(255),
    unitprice DECIMAL(10,2),
    quantity INT
);

INSERT INTO online_retail (invoicedate, description, unitprice, quantity) VALUES
('2023-01-15 10:00:00', 'Item A', 10.00, 2),
('2023-01-15 11:00:00', 'Item B', 20.00, 1),
('2023-02-20 12:00:00', 'Item A', 10.00, 5),
('2023-02-25 13:00:00', 'Item C', 15.00, 3),
('2023-03-05 14:00:00', 'Item B', 20.00, 4),
('2023-03-10 15:00:00', 'Item C', 15.00, 2),
('2023-03-15 16:00:00', 'Item A', 10.00, 1),
('2023-04-01 17:00:00', 'Item D', 25.00, 2),
('2023-04-05 18:00:00', 'Item B', 20.00, 3),
('2023-04-10 19:00:00', 'Item C', 15.00, 4),
('2023-05-15 20:00:00', 'Item A', 10.00, 6);

with all_prices as(
select description,sum(unitprice*quantity) as total_paid, extract(month from invoicedate) as month
from online_retail
group by description,extract(month from invoicedate)
)
, ranked_monthly_sales as(
select month,description,total_paid, row_number() over(partition by month order by total_paid desc NULLS LAST) as rn
from all_prices
)
select month,description,total_paid from ranked_monthly_sales
where rn=1 order by month asc NULLS LAST;