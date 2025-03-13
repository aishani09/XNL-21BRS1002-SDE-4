-- Part 2: Querying & Analytics

-- Get total transactions and revenue per vendor (Top 10 vendors)
SELECT v.vendor_id, v.vendor_name, COUNT(t.transaction_id) AS total_transactions, 
       SUM(t.amount) AS total_revenue
FROM Vendors v
JOIN Transactions t ON v.vendor_id = t.vendor_id
WHERE t.status = 'completed'
GROUP BY v.vendor_id, v.vendor_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Get sales trends for the last 7 days (hourly breakdown)
SELECT DATE(created_at) AS transaction_date, 
       HOUR(created_at) AS transaction_hour, 
       SUM(amount) AS total_sales
FROM Transactions
WHERE created_at >= NOW() - INTERVAL 7 DAY
  AND status = 'completed'
GROUP BY transaction_date, transaction_hour
ORDER BY transaction_date DESC, transaction_hour DESC;

-- Detect transaction anomalies (Very high or very low transactions)
SELECT transaction_id, user_id, vendor_id, amount, 
       AVG(amount) OVER () AS avg_transaction_amount,
       CASE 
           WHEN amount > AVG(amount) OVER () * 2 THEN 'HIGH_ANOMALY'
           WHEN amount < AVG(amount) OVER () / 2 THEN 'LOW_ANOMALY'
           ELSE 'NORMAL'
       END AS anomaly_status
FROM Transactions;

-- Get total balance and account types per user
SELECT u.user_id, u.user_name, 
       SUM(a.balance) AS total_balance, 
       GROUP_CONCAT(a.account_type) AS account_types
FROM Users u
JOIN Accounts a ON u.user_id = a.user_id
GROUP BY u.user_id, u.user_name
ORDER BY total_balance DESC;

-- Find the most active account types based on transaction count
SELECT account_type, COUNT(transaction_id) AS transaction_count
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
WHERE t.status = 'completed'
GROUP BY account_type
ORDER BY transaction_count DESC;

-- Get the top 5 assets with the highest price change in the last 30 days
SELECT asset_name, symbol, MAX(price) - MIN(price) AS price_change
FROM Market_Data
WHERE timestamp >= NOW() - INTERVAL 30 DAY
GROUP BY asset_name, symbol
ORDER BY price_change DESC
LIMIT 5;
