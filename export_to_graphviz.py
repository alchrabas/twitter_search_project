from database import conn
import csv

cur = conn.cursor()

cur.execute("""SELECT follower.id AS follower, followed.id AS followed
    FROM twitter_follows tf
    INNER JOIN twitter_users AS follower ON tf.follower = follower.id
    INNER JOIN twitter_users AS followed ON tf.followed = followed.id""")

to_graphviz_file = open("data/user_edges.csv", "w")
csv_writer = csv.writer(to_graphviz_file)

csv_writer.writerow(["Source", "Target"])
for follower, followed in cur.fetchall():
    csv_writer.writerow([follower, followed])

cur.execute("""SELECT id, username,
        EXISTS (SELECT * FROM huff_twitter_users_junction WHERE twitter_user_id = id) AS in_huff_db
    FROM twitter_users WHERE TRUE""")

to_graphviz_file = open("data/user_nodes.csv", "w")
csv_writer = csv.writer(to_graphviz_file)

csv_writer.writerow(["id", "username", "is_in_huff"])
for user_id, user_name, is_in_huff in cur.fetchall():
    csv_writer.writerow([user_id, user_name.strip(), is_in_huff])
