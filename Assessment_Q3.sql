-- Assessment_Q3.sql
-- Purpose: Identify active savings or investment plans with no deposit transactions in the last 365 days.
-- This helps the operations team flag inactive accounts for follow-up.

-- Step 1: Find the most recent deposit transaction date for each plan
WITH last_txn_per_plan AS (
    SELECT 
        sa.plan_id,                        -- The ID of the savings plan linked to the transaction
        MAX(DATE(sa.created_on)) AS last_transaction_date  -- Latest transaction date (date only, no time)
    FROM savings_savingsaccount sa         -- From the deposits transactions table
    GROUP BY sa.plan_id                    -- Group by plan to get the max date per plan
),

-- Step 2: Identify active plans and join with their last transaction dates
active_plans AS (
    SELECT
        p.id AS plan_id,                   -- Unique identifier of the plan
        p.owner_id,                       -- Customer (owner) ID of the plan
        -- Determine plan type using flags (fund or savings)
        CASE 
            WHEN p.is_a_fund = 1 THEN 'Investment'   -- Mark as Investment if flagged
            WHEN p.is_regular_savings = 1 THEN 'Savings' -- Mark as Savings if flagged
            ELSE 'Other'                   -- Otherwise, classify as Other
        END AS type,
        -- Use last transaction date if exists, otherwise fallback to plan creation date
        COALESCE(l.last_transaction_date, DATE(p.created_on)) AS last_transaction_date,
        -- Calculate number of days since last transaction or plan creation
        DATEDIFF(CURRENT_DATE, COALESCE(l.last_transaction_date, DATE(p.created_on))) AS inactivity_days
    FROM plans_plan p                     -- Plans table
    LEFT JOIN last_txn_per_plan l        -- Left join to include plans even without transactions
        ON p.id = l.plan_id               -- Join condition on plan IDs
    WHERE 
        p.is_archived = 0                 -- Only include plans that are not archived (active)
        AND p.is_deleted = 0              -- Exclude deleted plans
)

-- Step 3: Select plans inactive for more than 365 days (1 year)
SELECT
    plan_id,                             -- Plan identifier
    owner_id,                            -- Owner (customer) identifier
    type,                               -- Type of plan: Savings or Investment
    last_transaction_date,              -- Date of last deposit transaction (or plan creation date)
    inactivity_days                     -- Number of days since last transaction or creation
FROM active_plans
WHERE inactivity_days > 365             -- Filter for inactivity over one year
ORDER BY inactivity_days DESC;          -- Order by longest inactivity first
