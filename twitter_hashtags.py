from database import conn
import re


def extract_hashtags_from_tweets():
    cur = conn.cursor()

    cur.execute("SELECT t.id, t.text FROM tweets t")

    for row in cur.fetchall():
        tweet_id = row[0]
        hashtags = re.findall("#([a-zA-Z]+)", row[1])
        print(hashtags)
        for hashtag in set(hashtags):
            hashtag = hashtag.lower()
            cur.execute("SELECT tweet_id FROM twitter_hashtags WHERE tweet_id = %s AND hashtag = %s",
                        (tweet_id, hashtag))
            if not cur.fetchone():
                cur.execute("INSERT INTO twitter_hashtags (tweet_id, hashtag) VALUES (%s, %s)", (tweet_id, hashtag))

    conn.commit()


# extract_hashtags_from_tweets()

def transform_huff_tags():
    cur = conn.cursor()

    cur.execute("SELECT id, name FROM tags")

    i = 0

    for tag_id, name in cur.fetchall():
        i += 1

        if i % 1000 == 0:
            print(i)
            conn.commit()

        new_name = name.replace(" ", "").lower()
        cur.execute("INSERT INTO cleaned_tags (tag_id, name) VALUES (%s, %s)", (tag_id, new_name))

    conn.commit()

transform_huff_tags()
