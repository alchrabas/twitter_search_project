from database import conn
import csv

cur = conn.cursor()

cur.execute("""SELECT follower.username AS follower, followed.username AS followed
    FROM twitter_follows tf
    INNER JOIN twitter_users AS follower ON tf.follower = follower.id
    INNER JOIN twitter_users AS followed ON tf.followed = followed.id""")

to_graphviz_file = open("data/to_graphviz.csv", "w")
csv_writer = csv.writer(to_graphviz_file, quoting=csv.QUOTE_ALL)

for follower, followed in cur.fetchall():
    csv_writer.writerow([follower.strip(), followed.strip()])
