-- Before implementing JDBC, I wrote down SQL queries for checking my data

--show current balance of customers who opened an account on 2019
select extract(year from open_date) "Year"
from account;
--
SELECT TO_CHAR(open_date, 'DAY') day FROM account;
--
select *
from customer;
--
select customer.customer_id, SUM(checking_balance + saving_balance) as balance
from customer inner join account using (account_number) inner join checking using (account_number) inner join saving using (account_number)
where extract(year from open_date) = '2019'
group by customer.customer_id;

--Show customers who opened account on Sunday and on February

select current_blance,customer_name, date_opened from ACCOUNT as a
join CUSTOMER as c
on (a.customer_id=c.customer_id)
where datename(dw,date_opened)= 'friday' and datename(MONTH,date_opened)= 'march'
--
SELECT TO_CHAR(open_date, 'Month') day FROM account;
--
select customer.customer_id, account.open_date
from customer inner join account using (account_number) inner join checking using (account_number) inner join saving using (account_number)
where extract(year from open_date) = '2019';

select customer.customer_id, account.open_date
from customer inner join account using (account_number) inner join checking using (account_number) inner join saving using (account_number)
where extract(day from open_date) = 'Friday';

-----Show average withdraw amount from each branch-----

select branch.branch_name , avg(withdraw.amount) as average_amount 
from branch inner join withdraw using (transaction_id)
group by branch.branch_name

-----Show customers and amount who withdrawed money from branch name Seoul-----

select customer.customer_name, withdraw.amount
from customer inner join account using (account_number) inner join withdraw using (account_number) inner join branch using (branch_name);
where branch.branch_name = 'Seoul';


----How many times each customer withdraw money ---

select customer.customer_name, count(withdraw.amount) as total_transaction 
from customer inner join account using (account_number) inner join withdraw using (account_number)
group by customer.customer_name;

---Show branch names which have most deposit amount ---

select branch.branch_name, sum(deposit.amount) as max_amount 
from branch inner join deposit using (transaction_id) 
group by branch.branch_name


-- Interface
-- Bank management: Calculation of total loans, total accounts, totals on a per-customer basis, transaction frequency and dollar volumn
-- Account Deposit/Withdrawal
-- Payment (Loan or Credit card)
-- Opening of a new account
-- Obtaining a new or replacement credit or debit card
-- Taking out a new loan
-- Purchases using a card
