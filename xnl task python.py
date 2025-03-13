import mysql.connector
from faker import Faker
import random
from tqdm import tqdm

# Initialize Faker
fake = Faker()

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="mypassword",
    database="fintech_platform"
)
cursor = db.cursor()

# ------------------- Insert Users -------------------
def insert_users(n):
    query = """INSERT INTO Users (user_name, email, phone_number, user_type) 
               VALUES (%s, %s, %s, %s)"""
    
    users = []
    unique_emails = set()
    unique_phones = set()
    
    for _ in tqdm(range(n), desc="Inserting Users"):
        while True:
            email = fake.email()
            phone = fake.phone_number()[:15]
            if email not in unique_emails and phone not in unique_phones:
                unique_emails.add(email)
                unique_phones.add(phone)
                break
        
        users.append((
            fake.name(),
            email,
            phone,
            random.choice(['customer', 'admin'])
        ))

    try:
        cursor.executemany(query, users)
        db.commit()
        print(f"✅ Inserted {n} users.")
    except mysql.connector.errors.IntegrityError as e:
        print(f"❌ IntegrityError: {e} - Skipping duplicates.")
        db.rollback()

# ------------------- Insert Vendors -------------------
def insert_vendors(n):
    query = """INSERT INTO Vendors (vendor_name, category, contact_email, contact_phone, status) 
               VALUES (%s, %s, %s, %s, %s)"""

    vendors = []
    unique_emails = set()
    unique_phones = set()

    for _ in tqdm(range(n), desc="Inserting Vendors"):
        while True:
            email = fake.email()
            phone = fake.phone_number()[:15]
            if email not in unique_emails and phone not in unique_phones:
                unique_emails.add(email)
                unique_phones.add(phone)
                break
        
        vendors.append((
            fake.company(),
            random.choice(['Bank', 'Crypto Exchange', 'Stock Broker']),
            email,
            phone,
            random.choice(['active', 'inactive'])
        ))

    try:
        cursor.executemany(query, vendors)
        db.commit()
        print(f"✅ Inserted {n} vendors.")
    except mysql.connector.errors.IntegrityError as e:
        print(f"❌ IntegrityError: {e} - Skipping duplicates.")
        db.rollback()

# ------------------- Insert Accounts -------------------
def insert_accounts(n):
    cursor.execute("SELECT user_id FROM Users")
    user_ids = [row[0] for row in cursor.fetchall()]
    cursor.execute("SELECT vendor_id FROM Vendors")
    vendor_ids = [row[0] for row in cursor.fetchall()] + [None]

    query = """INSERT INTO Accounts (user_id, vendor_id, account_type, balance, currency) 
               VALUES (%s, %s, %s, %s, %s)"""

    accounts = [
        (
            random.choice(user_ids),
            random.choice(vendor_ids),
            random.choice(['wallet', 'bank_account', 'credit_card']),
            round(random.uniform(0, 100000), 2),
            random.choice(['USD', 'EUR', 'INR'])
        )
        for _ in tqdm(range(n), desc="Inserting Accounts")
    ]

    cursor.executemany(query, accounts)
    db.commit()
    print(f"✅ Inserted {n} accounts.")

# ------------------- Insert Transactions -------------------
def insert_transactions(n):
    cursor.execute("SELECT user_id FROM Users")
    user_ids = [row[0] for row in cursor.fetchall()]
    cursor.execute("SELECT vendor_id FROM Vendors")
    vendor_ids = [row[0] for row in cursor.fetchall()] + [None]
    cursor.execute("SELECT account_id FROM Accounts")
    account_ids = [row[0] for row in cursor.fetchall()]

    query = """INSERT INTO Transactions (user_id, vendor_id, account_id, transaction_type, amount, currency, status) 
               VALUES (%s, %s, %s, %s, %s, %s, %s)"""

    transactions = [
        (
            random.choice(user_ids),
            random.choice(vendor_ids),
            random.choice(account_ids),
            random.choice(['deposit', 'withdrawal', 'purchase', 'transfer']),
            round(random.uniform(10, 10000), 2),
            random.choice(['USD', 'EUR', 'INR']),
            random.choice(['pending', 'completed', 'failed'])
        )
        for _ in tqdm(range(n), desc="Inserting Transactions")
    ]

    cursor.executemany(query, transactions)
    db.commit()
    print(f"✅ Inserted {n} transactions.")

# ------------------- Insert Market Data -------------------
def insert_market_data(n):
    query = """INSERT INTO Market_Data (asset_name, symbol, price) 
               VALUES (%s, %s, %s)"""

    assets = []
    unique_symbols = set()

    for _ in tqdm(range(n), desc="Inserting Market Data"):
        while True:
            symbol = fake.unique.lexify(text='???')
            if symbol not in unique_symbols:
                unique_symbols.add(symbol)
                break
        
        assets.append((
            fake.word().capitalize() + " Corp",
            symbol,
            round(random.uniform(10, 5000), 2)
        ))

    try:
        cursor.executemany(query, assets)
        db.commit()
        print(f"✅ Inserted {n} market data records.")
    except mysql.connector.errors.IntegrityError as e:
        print(f"❌ IntegrityError: {e} - Skipping duplicates.")
        db.rollback()

# ------------------- Insert Audit Logs -------------------
def insert_audits(n):
    cursor.execute("SELECT user_id FROM Users")
    user_ids = [row[0] for row in cursor.fetchall()]
    cursor.execute("SELECT transaction_id FROM Transactions")
    transaction_ids = [row[0] for row in cursor.fetchall()] + [None]

    query = """INSERT INTO Audits (user_id, transaction_id, action_type, ip_address) 
               VALUES (%s, %s, %s, %s)"""

    audits = [
        (
            random.choice(user_ids),
            random.choice(transaction_ids),
            random.choice(['login', 'update_account', 'withdrawal_attempt', 'purchase_attempt']),
            fake.ipv4()
        )
        for _ in tqdm(range(n), desc="Inserting Audits")
    ]

    cursor.executemany(query, audits)
    db.commit()
    print(f"✅ Inserted {n} audit logs.")

# ------------------- Run Data Generation -------------------
NUM_USERS = 100000
NUM_VENDORS = 10000
NUM_ACCOUNTS = 200000
NUM_TRANSACTIONS = 500000
NUM_MARKET_DATA = 5000
NUM_AUDITS = 200000

print("\n🚀 Inserting data, please wait...\n")

insert_users(NUM_USERS)
insert_vendors(NUM_VENDORS)
insert_accounts(NUM_ACCOUNTS)
insert_transactions(NUM_TRANSACTIONS)
insert_market_data(NUM_MARKET_DATA)
insert_audits(NUM_AUDITS)

# Close database connection
cursor.close()
db.close()
print("\n✅ Data generation complete!")
