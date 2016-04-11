import psycopg2

pg_connection = psycopg2.connect(database="huffingtondb", user="postgres", password="root", host="localhost")

cur = pg_connection.cursor()
cur.execute("SELECT name, COUNT(*) FROM authors a "
            "INNER JOIN comments c ON c.author_id = a.id "
            "GROUP BY a.name ORDER BY COUNT(*) DESC LIMIT 2000;")

for line in cur.fetchall():
    print((line[0], line[1] / 2))
