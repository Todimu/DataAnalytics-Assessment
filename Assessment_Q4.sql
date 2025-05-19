-- Assessment_Q4.sql
-- Purpose: Estimate Customer Lifetime Value (CLV) based on transaction volume and account tenure.
-- This simplified CLV model assumes profit is 0.1% of transaction value per deposit.

SELECT 
    u.id AS customer_id,                                  -- Customer unique ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,      -- Full customer name (concatenate first and last names)
    
    -- Calculate account tenure in months from signup date to current date
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    
    -- Count total number of deposit transactions (inflows) made by the customer
    COUNT(sa.id) AS total_transactions,
    
    -- Estimated CLV formula:
    -- (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
    -- avg_profit_per_transaction = average of 0.1% of deposit amounts
    CASE 
        WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) > 0 THEN
            (COUNT(sa.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE)) * 12 * AVG(sa.confirmed_amount * 0.001)
        ELSE 0
    END AS estimated_clv

FROM users_customuser u                                  -- Customers table
LEFT JOIN savings_savingsaccount sa                       -- Deposit transactions table
    ON sa.owner_id = u.id                                 -- Join on customer ID matching owner_id in transactions
GROUP BY u.id, u.first_name, u.last_name, u.date_joined  -- Group by customer fields for aggregation
ORDER BY estimated_clv DESC                               -- Order by estimated CLV from highest to lowest
LIMIT 100;                                               -- Optional limit to top 100 customers
