from flask import Flask, jsonify
import pyodbc

app = Flask(__name__)

server = 'devops-sql-server-123.database.windows.net'
database = 'devops-db'
username = 'azureadmin'
password = 'StrongPassword123!'

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    f'SERVER={server};DATABASE={database};UID={username};PWD={password}'
)

@app.route("/")
def home():
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    rows = cursor.fetchall()

    result = []
    for row in rows:
        result.append({"id": row[0], "name": row[1], "email": row[2]})

    return jsonify(result)

app.run(host="0.0.0.0", port=5000)