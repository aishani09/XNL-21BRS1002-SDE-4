import mysql.connector
import time
import matplotlib.pyplot as plt

# Database connection
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="mypassword",
    database="fintech_platform"
)

# Queries to test performance
queries = {
    "Top 10 Vendors by Revenue": """
        SELECT v.vendor_name, COUNT(t.transaction_id) AS total_transactions, 
               SUM(t.amount) AS total_revenue 
        FROM Vendors v
        JOIN Transactions t ON v.vendor_id = t.vendor_id
        WHERE t.status = 'completed'
        GROUP BY v.vendor_id
        ORDER BY total_revenue DESC
        LIMIT 10;
    """,
    "Top 10 Users by Transactions": """
        SELECT u.user_name, COUNT(t.transaction_id) AS total_transactions, 
               SUM(t.amount) AS total_spent
        FROM Users u
        JOIN Transactions t ON u.user_id = t.user_id
        WHERE t.status = 'completed'
        GROUP BY u.user_id
        ORDER BY total_spent DESC
        LIMIT 10;
    """,
    "Transaction Volume Over Time": """
        SELECT DATE(created_at) AS transaction_date, COUNT(*) AS transaction_count
        FROM Transactions
        WHERE status = 'completed'
        GROUP BY transaction_date
        ORDER BY transaction_date;
    """
}

# Store execution times
results = []

# Execute queries and measure performance
for name, query in queries.items():
    with conn.cursor(buffered=True) as cursor:  # Using buffered cursor to prevent unread result errors
        start_time = time.time()
        cursor.execute(query)
        cursor.fetchall()  # Fetch all results to clear pending results
        execution_time = time.time() - start_time
        results.append({"Query": name, "Execution Time (s)": execution_time})
        print(f" {name} executed in {execution_time:.4f} seconds")

# Close the database connection
conn.close()

# Plot performance results
query_names = [result["Query"] for result in results]
execution_times = [result["Execution Time (s)"] for result in results]

plt.figure(figsize=(10, 5))
plt.barh(query_names, execution_times, color='skyblue')
plt.xlabel("Execution Time (s)")
plt.ylabel("Query")
plt.title("Query Performance Benchmark")
plt.gca().invert_yaxis()  # Invert y-axis for better readability
plt.show()
