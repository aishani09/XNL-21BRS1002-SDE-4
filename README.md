# Fintech Platform Database

##  Introduction
The **Fintech Platform Database** is designed to support a scalable and optimized financial transaction system. It includes structured data models for users, vendors, accounts, transactions, market data, and audit logs.

##  Database Schema
The platform is built using MySQL with **InnoDB** for transaction integrity and performance. The schema consists of:

- **Users**: Stores user information.
- **Vendors**: Maintains vendor details.
- **Accounts**: Tracks different financial accounts.
- **Transactions**: Logs all financial transactions.
- **Market_Data**: Stores asset pricing information.
- **Audits**: Keeps track of important system actions.

 **ER Diagram**: See `/diagrams/er_diagram.png`

##  SQL Scripts
All database scripts can be found in the `/sql-script` directory:
- `xnl sql - Part 1.sql`: Creates all tables with constraints.
- `xnl sql - Part 2.sql`: Contains optimized queries for analytics.
- `xnl sql - Part 3.sql`: Indexing and performance tuning scripts.

##  Query Optimization & Performance Analysis
- **Indexes & Partitioning**: Indexed high-usage columns and optimized table partitions.
- **Query Optimization**: Used `EXPLAIN` to analyze slow queries and refactored subqueries.
- **Performance Benchmarks**: Before & after improvements documented 

##  Setup & Installation
1. Install **MySQL Workbench** and **MySQL Server**.
2. Run `xnl sql - Part 1.sql` to initialize the database.
3. Use `xnl sql - Part 2.sql` to fetch insights.
4. Apply optimizations using `xnl sql - Part 3.sql`.




