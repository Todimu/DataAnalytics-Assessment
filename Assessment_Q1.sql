-- Assessment_Q1.sql
-- Customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits

WITH savings AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),
investments AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),
deposits AS (
    SELECT p.owner_id, SUM(s.confirmed_amount) / 100 AS total_deposits
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    GROUP BY p.owner_id
)

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    s.savings_count,
    i.investment_count,
    d.total_deposits
FROM users_customuser u
JOIN savings s ON u.id = s.owner_id
JOIN investments i ON u.id = i.owner_id
JOIN deposits d ON u.id = d.owner_id
ORDER BY d.total_deposits DESC;
