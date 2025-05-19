-- Step 1: CTE to calculate transaction counts and transaction period for each customer
WITH customer_transactions AS (
    SELECT 
        sa.owner_id,  -- Customer ID
        COUNT(*) AS total_transactions,  -- Total number of transactions
        TIMESTAMPDIFF(
            MONTH, 
            MIN(sa.created_on), 
            MAX(sa.created_on)
        ) + 1 AS active_months  -- Active months, add 1 to avoid division by zero
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),

-- Step 2: CTE to calculate average transactions per month and assign frequency category
categorized_customers AS (
    SELECT 
        ct.owner_id,
        ct.total_transactions,
        ct.active_months,
        ROUND(ct.total_transactions / ct.active_months, 2) AS avg_txn_per_month,
        
        -- Categorize customers by average transactions per month
        CASE 
            WHEN (ct.total_transactions / ct.active_months) >= 10 THEN 'High Frequency'
            WHEN (ct.total_transactions / ct.active_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_transactions ct
)

-- Step 3: Final query to count customers per category and average transactions
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
