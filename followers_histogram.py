import matplotlib.pyplot as plt
import pylab as P

from database import conn

cur = conn.cursor()
cur.execute("SELECT followers, followed FROM twitter_users"
            " WHERE followers IS NOT NULL AND followed IS NOT NULL"
            " AND EXISTS (SELECT * FROM huff_twitter_users_junction htu WHERE htu.twitter_user_id = id)")

followers_list = []
followed_list = []
for followers, followed in cur.fetchall():
    followers_list += [followers]
    followed_list += [followed]

# n, bins, patches = P.hist(followers_list, 50, normed=1, histtype='stepfilled')

P.figure()

# the histogram of the data with histtype='step'
n, bins, patches = P.hist(followers_list, 50,  histtype='stepfilled')

P.title("Followers histogram")
P.xlabel("Followers count")
P.ylabel("Number")


P.show()
