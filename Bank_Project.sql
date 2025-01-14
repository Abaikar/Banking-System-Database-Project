create database bank;
use bank;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    Address VARCHAR(255),
    DateOfBirth DATE,
    JoinedDate DATE
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    AccountType ENUM('Savings', 'Checking', 'Credit'),
    Balance DECIMAL(15, 2),
    DateOpened DATE,
    Status ENUM('Active', 'Closed', 'Frozen'),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer'),
    Amount DECIMAL(15, 2),
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Description VARCHAR(255),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    LoanType ENUM('Personal', 'Home', 'Auto', 'Education'),
    LoanAmount DECIMAL(15, 2),
    InterestRate DECIMAL(5, 2),
    StartDate DATE,
    EndDate DATE,
    Status ENUM('Approved', 'Pending', 'Rejected'),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT,
    PaymentDate DATE,
    AmountPaid DECIMAL(15, 2),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Address, DateOfBirth, JoinedDate) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St, City', '1985-02-10', '2023-01-15'),
('Alice', 'Smith', 'alice.smith@example.com', '9876543210', '456 Oak St, Town', '1990-06-25', '2023-03-10');

INSERT INTO Accounts (CustomerID, AccountType, Balance, DateOpened, Status) VALUES
(1, 'Savings', 5000.00, '2023-01-15', 'Active'),
(1, 'Checking', 1500.00, '2023-01-16', 'Active'),
(2, 'Savings', 3000.00, '2023-03-11', 'Active');

INSERT INTO Transactions (AccountID, TransactionType, Amount, Description) VALUES
(1, 'Deposit', 1000.00, 'Initial deposit'),
(1, 'Withdrawal', 500.00, 'ATM withdrawal'),
(2, 'Deposit', 2000.00, 'Payroll deposit');

INSERT INTO Loans (CustomerID, LoanType, LoanAmount, InterestRate, StartDate, EndDate, Status) VALUES
(1, 'Personal', 10000.00, 5.5, '2023-01-20', '2024-01-20', 'Approved'),
(2, 'Home', 50000.00, 4.2, '2023-03-15', '2033-03-15', 'Approved');

INSERT INTO Payments (LoanID, PaymentDate, AmountPaid) VALUES
(1, '2023-02-15', 500.00),
(1, '2023-03-15', 500.00),
(2, '2023-04-01', 1000.00);

-- 1.Get all transactions for a specific account:
select * from Transactions
where AccountID = 1;

-- 2. List all active loans
select * from Loans
where status = 'Approved';

-- 3.Find customers who opened accounts in 2023
 select * from Customers
 where JoinedDate > 2023;
 
 -- 4. Get all accounts with a balance above $2000:
select * from Accounts
where Balance > 2000;

-- 5.Total deposits in an account
select sum(Amount) as TotalDeposit
from Transactions
where TransactionType = 'Deposit';

-- 6.Total loan amount for each customer 

-- 7.List all accounts with customer details:

select c.FirstName , c.LastName, a.Balance
From Customers c
Join
Accounts a On c.CustomerID = a.CustomerID;

-- 8.List loan payment history with customer names:
select c.FirstName , c.LastName, p.PaymentDate , p.AmountPaid , l.LoanAmount ,  l.LoanAmount -p.AmountPaid as Pending_Amount
From Payments p
Join Loans l On p.loanID = l.loanID
Join Customers c On l.CustomerID = c.CustomerID;

-- 9. Calculate the interest due for a loan

select LoanID, LoanAmount, InterestRate , (LoanAmount * InterestRate /100) As InterestAmt
From Loans;

-- 10.Total payment made on each loan

Select LoanID , sum(AmountPaid) as TotalPayment
From Payments
group by LoanID;
