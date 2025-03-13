-- Part 1: Database Schema & Table Creation

-- Create the fintech database and use it
CREATE DATABASE fintech_platform;
USE fintech_platform;

-- Users Table: Stores user details
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    user_type ENUM('customer', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Vendors Table: Stores vendor/business details
CREATE TABLE Vendors (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    contact_email VARCHAR(50) UNIQUE NOT NULL,
    contact_phone VARCHAR(20) UNIQUE NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Accounts Table: Stores financial account details
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    vendor_id INT NULL,
    account_type ENUM('wallet', 'bank_account', 'credit_card') NOT NULL,
    balance DECIMAL(18,2) CHECK (balance >= 0),
    currency VARCHAR(5) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id) ON DELETE SET NULL
);

-- Transactions Table: Logs all financial transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    vendor_id INT NULL,
    account_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'purchase', 'transfer') NOT NULL,
    amount DECIMAL(18,2) CHECK (amount > 0),
    currency VARCHAR(5) NOT NULL,
    status ENUM('pending', 'completed', 'failed') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id) ON DELETE SET NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id) ON DELETE CASCADE
);

-- Market Data Table: Stores asset price information
CREATE TABLE Market_Data (
    market_id INT PRIMARY KEY AUTO_INCREMENT,
    asset_name VARCHAR(50) NOT NULL,
    symbol VARCHAR(15) UNIQUE NOT NULL,
    price DECIMAL(18,4) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Logs Table: Logs security actions and transactions
CREATE TABLE Audits (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NULL,
    transaction_id INT NULL,
    action_type VARCHAR(50) NOT NULL,
    ip_address VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id) ON DELETE CASCADE
);






















