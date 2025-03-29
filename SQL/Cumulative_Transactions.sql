CREATE TABLE transaction44 (
 transaction_id INT PRIMARY KEY,
 type VARCHAR(20) NOT NULL,
 amount DECIMAL(10,2) NOT NULL,
 transaction_date DATETIME NOT NULL
);

INSERT INTO transaction44 (transaction_id, type, amount, transaction_date) 
VALUES 
(19153, 'deposit', 65.90, '2022-07-10 10:00:00'), 
(53151, 'deposit', 178.55, '2022-07-08 10:00:00'), 
(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00'), 
(16461, 'withdrawal', 45.99, '2022-07-08 13:00:00'), 
(77134, 'deposit', 32.60, '2022-07-10 10:00:00');

select * from transaction44;

/*Write a query to print the cumulative balance of the
merchant account at the end of each day, with the total balance reset back to zero at the end of the month.
*/

with closing_balance_daily as(
select cast(transaction_date as date) as transaction_date,
sum(case when type='deposit' then amount else -1*(amount) end) as balance
from transaction44
group by cast(transaction_date as date)
)
select transaction_date,
sum(balance) over(partition by year(transaction_date),month(transaction_date) order by transaction_date) as balance
from closing_balance_daily;
