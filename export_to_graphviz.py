from database import conn

cur = conn.cursor()

cur.execute("""SELECT follower.username AS follower, followed.username AS followed
    FROM twitter_follows tf
    INNER JOIN twitter_users AS follower ON tf.follower = follower.id
    INNER JOIN twitter_users AS followed ON tf.followed = followed.id""")

to_graphviz_file = open("data/to_graphviz.gv", "w")

header_text = """digraph {
	graph [bgcolor=white fontcolor=black fontsize=16 layout=sfdp overlap=false]
	node [color=black fontname=Helvetica]
	edge [arrowhead=open color=black fontcolor=gray fontname=Courier fontsize=12]
"""

footer_text = "}"

to_graphviz_file.write(header_text)
for follower, followed in cur.fetchall():
    to_graphviz_file.write('			"' + follower.strip() + '" -> "' + followed.strip() + "\"\n")

to_graphviz_file.write(footer_text)
