--CREATION OF TABLES 
--we present a relatively complete SQL data definition for bank database

CREATE TABLE customer (
customer_id varchar(20) NOT NULL,
customer_name varchar(20) NOT NULL,
customer_city varchar(30) NOT NULL, 
loan_number varchar(30) NOT NULL,
transaction_id varchar(30) NOT NULL,
card_number varchar(30) NOT NULL,
account_number varchar(30) NOT NULL,
primary key (customer_id)
);

CREATE TABLE branch (
branch_name varchar(20) NOT NULL,
branch_city varchar(30) NOT NULL,
branch_type varchar(10) NOT NULL,
assets numeric (12,2) NOT NULL,
loan_number varchar(20) NOT NULL,
transaction_id varchar(20) NOT NULL,
primary key (branch_name), check (assets >= 0)
);

CREATE TABLE loan (
loan_number varchar(20) NOT NULL,
loan_type varchar(10) NOT NULL,
interest_rate  numeric (10,10) NOT NULL,
monthly_payment numeric (12,2) NOT NULL,
branch_name  varchar(20) NOT NULL,
primary key (loan_number),
foreign key (loan_number) references customer on delete cascade,
foreign key (loan_number) references branch on delete cascade
);

CREATE TABLE loan_payment (
payment_number varchar(10) NOT NULL,
amount numeric (12,2) NOT NULL, 
payment_date date NOT NULL,
loan_number  varchar(20) NOT NULL,
primary key (loan_number, payment_number),
foreign key (loan_number) references loan on delete cascade
);

CREATE TABLE transaction (
transaction_id varchar(20) NOT NULL,
branch_name varchar(30) NOT NULL,
transaction_date date NOT NULL,
customer_id varchar(20) NOT NULL,
primary key (transaction_id),
foreign key (branch_name) references branch on delete cascade,
foreign key (customer_id) references customer on delete cascade
);

CREATE TABLE account (
account_number varchar(20) NOT NULL,
open_date date NOT NULL,
close_date date,
customer_id varchar(20) NOT NULL,
transaction_id varchar(20) NOT NULL,
primary key (account_number),
foreign key (customer_id) references customer on delete cascade
);

CREATE TABLE checking (
account_number varchar(20) NOT NULL,
card_number varchar(20) NOT NULL,
checking_interest_rate  numeric (10,2) NOT NULL,
checking_balance numeric (12,2) NOT NULL,
primary key (account_number), check (checking_balance >= 1500), -- Minimum balance
foreign key (account_number) references account on delete cascade
);

CREATE TABLE saving (
account_number varchar(20) NOT NULL,
saving_interest_rate  numeric (10,2) NOT NULL,
saving_balance numeric (12,2) NOT NULL,
primary key (account_number), check (saving_balance > 0), -- Not permitted to be overdrawn
foreign key (account_number) references account on delete set null
);

CREATE TABLE credit (
account_number varchar(20) NOT NULL,
card_number varchar(20) NOT NULL,
credit_interest_rate numeric (10,2) NOT NULL,
credit_limit numeric (12,2) NOT NULL,
credit_running_balance numeric (12,2) NOT NULL,
credit_balance_due date NOT NULL,
primary key (account_number),
foreign key (account_number) references account on delete set null
);

CREATE TABLE card (
card_number varchar(20) NOT NULL,
card_type varchar(20) NOT NULL,
primary key (card_number),
foreign key (card_number) references customer on delete set null
);

CREATE TABLE debit_card (
card_number varchar(20) NOT NULL,
debt_amount numeric (10,2) NOT NULL,
primary key (card_number), 
foreign key (card_number) references checking on delete set null,
foreign key (card_number) references card on delete set null
);

CREATE TABLE credit_card (
card_number varchar(20) NOT NULL,
credit_amount numeric (10,2) NOT NULL,
primary key (card_number),
foreign key (card_number) references credit on delete set null,
foreign key (card_number) references card on delete set null
);

CREATE TABLE payment (
transaction_id varchar(20) NOT NULL,
payment_number varchar(10) NOT NULL,
loan_number  varchar(20) NOT NULL,
account_number varchar(20) NOT NULL,
amount numeric (12,2) NOT NULL, 
card_number varchar(20) NOT NULL,
primary key (transaction_id),
foreign key (loan_number, payment_number) references loan_payment on delete cascade,
foreign key (card_number) references credit_card on delete cascade,
foreign key (account_number) references account on delete cascade
);

CREATE TABLE deposit (
transaction_id varchar(20) NOT NULL,
account_number varchar(20) NOT NULL,
amount numeric (12,2) NOT NULL,
card_number varchar(20) NOT NULL,
branch_name varchar(20) NOT NULL,
primary key (transaction_id),
foreign key (transaction_id) references transaction on delete cascade,
foreign key (account_number) references account on delete cascade,
foreign key (card_number) references debit_card on delete cascade,
foreign key (branch_name) references branch on delete cascade
);

CREATE TABLE withdraw (
transaction_id varchar(20) NOT NULL,
account_number varchar(20) NOT NULL,
amount numeric (12,2) NOT NULL,
card_number varchar(20) NOT NULL,
branch_name varchar(20) NOT NULL,
primary key (transaction_id),
foreign key (transaction_id) references transaction on delete cascade,
foreign key (account_number) references account on delete cascade,
foreign key (card_number) references debit_card on delete cascade,
foreign key (branch_name) references branch on delete cascade
);

CREATE TABLE transfer (
transaction_id varchar(20) NOT NULL,
account_number varchar(20) NOT NULL,
amount numeric (12,2) NOT NULL,
primary key (transaction_id),
foreign key (transaction_id) references transaction on delete cascade,
foreign key (account_number) references checking on delete cascade,
foreign key (account_number) references saving on delete cascade
);

CREATE TABLE purchase (
transaction_id varchar(20) NOT NULL,
account_number varchar(20) NOT NULL,
amount numeric (12,2) NOT NULL,
card_number varchar(20) NOT NULL,
primary key (transaction_id),
foreign key (transaction_id) references transaction on delete cascade,
foreign key (account_number) references account on delete cascade,
foreign key (card_number) references debit_card on delete cascade,
foreign key (card_number) references credit_card on delete cascade
);

--CREATE TABLE atm (
--transaction_id varchar(20) NOT NULL,
--branch_name varchar(20) NOT NULL,
--withdraw_amount numeric (12,2) NOT NULL,
--primary key (transaction_id, branch_name),
--foreign key (branch_name) references branch on delete cascade
--); 
--
--CREATE TABLE bank_teller (
--transaction_id varchar(20) NOT NULL, 
--branch_name varchar(20) NOT NULL,
--deposit_amount numeric (12,2) NOT NULL,
--withdraw_amount numeric (12,2) NOT NULL,
--primary key (transaction_id, branch_name),
--foreign key (branch_name) references branch on delete cascade
--); 

--drop table r 
--alter table r add A D 
--alter table r drop A 
