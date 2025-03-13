-- Part 3: Query Optimization & Indexing

-- Add indexes to improve query performance
ALTER TABLE Transactions ADD INDEX idx_vendor_status (vendor_id, status);
ALTER TABLE Users ADD INDEX idx_email_phone (email, phone_number);
ALTER TABLE Accounts ADD INDEX idx_user_balance (user_id, balance);
ALTER TABLE Market_Data ADD INDEX idx_symbol_price (symbol, price);

-- Optimize the transaction revenue query using subquery optimization
SELECT v.vendor_id, v.vendor_name, t.total_transactions, t.total_revenue
FROM Vendors v
JOIN (
    SELECT vendor_id, 
           COUNT(transaction_id) AS total_transactions, 
           SUM(amount) AS total_revenue
    FROM Transactions 
    WHERE status = 'completed'
    GROUP BY vendor_id
    ORDER BY total_revenue DESC
    LIMIT 10
) t ON v.vendor_id = t.vendor_id;

-- Partitioning transactions table by date for scalability
ALTER TABLE Transactions 
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202401 VALUES LESS THAN (UNIX_TIMESTAMP('2024-02-01')),
    PARTITION p202402 VALUES LESS THAN (UNIX_TIMESTAMP('2024-03-01')),
    PARTITION p202403 VALUES LESS THAN (UNIX_TIMESTAMP('2024-04-01')),
    PARTITION pMax VALUES LESS THAN MAXVALUE
);

-- Additional indexes for faster queries
CREATE INDEX idx_transactions_status_created ON Transactions (status, created_at);
CREATE INDEX idx_transactions_vendor ON Transactions (vendor_id, created_at);
CREATE INDEX idx_transactions_user ON Transactions (user_id, created_at);

-- Enable table compression for performance improvement
ALTER TABLE Transactions ROW_FORMAT=COMPRESSED;

-- Creating a view for analyzing all transactions across partitions
CREATE VIEW All_Transactions AS 
SELECT * FROM Transactions_202401
UNION ALL
SELECT * FROM Transactions_202402
UNION ALL
SELECT * FROM Transactions_202403;

-- Performance Analysis using EXPLAIN ANALYZE
EXPLAIN ANALYZE 
SELECT vendor_id, COUNT(transaction_id) AS total_transactions, SUM(amount) AS total_revenue
FROM Transactions
WHERE status = 'completed'
GROUP BY vendor_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Check the most time-consuming queries
SELECT * FROM performance_schema.events_statements_summary_by_digest
ORDER BY AVG_TIMER_WAIT DESC LIMIT 5;

-- Monitor system performance
SHOW PROCESSLIST;
SHOW STATUS LIKE 'Innodb_buffer_pool%';
