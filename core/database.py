# database.py
import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",         # Update with your credentials
        database="technocourse"
    )

def create_users_table():
    """Ensure the 'users' table exists for login/register."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            user_id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            email VARCHAR(100)
        )
    """)
    conn.commit()
    cursor.close()
    conn.close()
