from database import conn
import csv

cur = conn.cursor()

cur.execute("""SELECT text, author_id, date, id FROM tweets""")

to_csv_file = open("data/tweets.csv", "w")
csv_writer = csv.writer(to_csv_file)

csv_writer.writerow(["id", "text", "author_id", "date"])
for text, author_id, date, tweet_id in cur.fetchall():
    csv_writer.writerow([tweet_id, text.strip().replace("\n", " "), author_id, date])
