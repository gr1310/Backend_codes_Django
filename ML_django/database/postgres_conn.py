import psycopg2

conn= psycopg2.connect(database="postgres",
                       host="localhost",
                       user="postgres",
                       password="123456",
                       port="5432")

cursor= conn.cursor()

cursor.execute("SELECT * FROM users_new")

print(cursor.fetchall())

cursor.close()