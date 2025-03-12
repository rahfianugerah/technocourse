import os
import mysql.connector

from flask import Flask, jsonify
from mysql.connector import Error
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

DB_HOST = os.getenv('DB_HOST')
DB_DATABASE = os.getenv('DB_DATABASE')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')

def get_db_connection():
    connection = mysql.connector.connect(
        host=DB_HOST,
        database=DB_DATABASE,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return connection

@app.route('/api/dashboard', methods=['GET'])
def dashboard_data():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT c.title, COUNT(e.enrollmentid) AS enrollment_count
            FROM courses c
            LEFT JOIN enrollments e ON c.courseid = e.courseid
            GROUP BY c.courseid;
        """)
        results = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(results)
    except Error as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
