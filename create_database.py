from database import conn

cur = conn.cursor()

cur.execute("""CREATE TABLE IF NOT EXISTS twitter_users
    (
      id bigint NOT NULL,
      username character(45),
      real_name character(64),
      avatar_url character(128),
      description character(256),
      location character(128),
      CONSTRAINT id PRIMARY KEY (id)
    )
    WITH (
      OIDS=FALSE
    );
    """)

cur.execute("""CREATE TABLE IF NOT EXISTS twitter_follows
    (
      followed bigint NOT NULL,
      follower bigint NOT NULL,
      CONSTRAINT twitter_follows_pkey PRIMARY KEY (followed, follower),
      CONSTRAINT twitter_follows_followed_fkey FOREIGN KEY (followed)
          REFERENCES twitter_users (id) MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT twitter_follows_follower_fkey FOREIGN KEY (follower)
          REFERENCES twitter_users (id) MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION
    )
    WITH (
      OIDS=FALSE
    );
    """)

cur.execute("""CREATE TABLE IF NOT EXISTS huff_twitter_users_junction
    (
      huff_author_id integer NOT NULL,
      twitter_user_id bigint NOT NULL,
      CONSTRAINT huff_twitter_users_junction_pkey PRIMARY KEY (huff_author_id, twitter_user_id)
    )
    WITH (
      OIDS=FALSE
    );
    """)

cur.execute("""CREATE TABLE IF NOT EXISTS retweets
    (
      tweet_id bigint NOT NULL,
      user_id bigint NOT NULL,
      CONSTRAINT retweets_pkey PRIMARY KEY (tweet_id, user_id)
    )
    WITH (
      OIDS=FALSE
  );""")

cur.execute("""CREATE TABLE IF NOT EXISTS tweet_hashtags
    (
      tweet_id bigint NOT NULL,
      hashtag character(1) NOT NULL,
      CONSTRAINT tweet_hashtags_pkey PRIMARY KEY (tweet_id, hashtag)
    )
    WITH (
      OIDS=FALSE
  );""")

conn.commit()