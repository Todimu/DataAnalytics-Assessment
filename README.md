# DataAnalytics-Assessment
Cowrywise Data Analytics Assessment Answers



# Assessment_Q1.sql — High-Value Customers with Multiple Products
Approach:

Identified customers who have at least one funded savings plan (is_regular_savings = 1) and one funded investment plan (is_a_fund = 1).

Joined users_customuser with plans_plan to count savings and investment plans per customer.

Summed the total deposits from savings_savingsaccount linked to each customer.

Used CONCAT(first_name, ' ', last_name) to display full customer name.

Filtered customers having both types of plans and sorted by total deposits descending.

Challenges:

Original data stored names in separate first and last name columns, requiring concatenation for clarity.

Needed to correctly interpret flags is_regular_savings and is_a_fund to differentiate plan types.

Ensured deposit amounts were summed in a way that reflects real funding (excluding withdrawals).



# Assessment_Q2.sql — Transaction Frequency Analysis
Approach:

Calculated total number of deposit transactions (savings_savingsaccount) per customer.

Determined the number of months the customer has been active by comparing signup date to current date.

Computed average transactions per month as total transactions divided by tenure months.

Categorized customers into "High", "Medium", and "Low" frequency buckets based on average monthly transactions.

Aggregated results by frequency category to count number of customers and average transactions per month.

Challenges:

Handling customers with zero months tenure (e.g., signed up recently) to avoid division by zero errors.

Defining clear boundaries for frequency categories per business requirements.

Aggregating customers correctly to produce summary statistics for each category.



# Assessment_Q3.sql — Account Inactivity Alert
Approach:

Combined plans and savings accounts to identify active accounts.

Retrieved the date of the most recent transaction (confirmed_amount inflow or amount_withdrawn) for each plan or savings account.

Calculated days of inactivity by comparing the last transaction date with the current date.

Filtered accounts with no transactions in the last 365 days.

Displayed relevant account details: plan ID, owner ID, account type, last transaction date, and inactivity days.

Challenges:

Ensuring last transaction date considered both deposits and withdrawals.

Managing data types to extract only the date part, ignoring time.

Joining multiple tables efficiently to gather all required data points.



# Assessment_Q4.sql — Customer Lifetime Value (CLV) Estimation
Approach:

Calculated tenure in months by subtracting signup date from the current date.

Counted total deposit transactions per customer.

Estimated average profit per transaction as 0.1% of the transaction value (confirmed_amount * 0.001).

Computed estimated CLV using the formula:
(total_transactions / tenure_months) * 12 * avg_profit_per_transaction — annualizing monthly transactions.

Ordered customers by estimated CLV descending to identify the highest value customers.

Challenges:

Avoided division by zero for customers with zero tenure months.

Handling NULL or missing transaction data gracefully with LEFT JOIN.

Ensuring accuracy in profit calculations considering amounts stored in kobo (smallest currency unit).
