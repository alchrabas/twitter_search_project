import psycopg2


conn = psycopg2.connect(database="huffingtondb", user="postgres", password="root", host="localhost")
