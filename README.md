# Introduction
The project consists of two main parts:

 - collecting users
 - collecting hashtags

The functions that query Twitter are in `twitter_crawler` while various util functions are in other scripts.

## Setting up
The project uses python3 and requires psycopg2 and tweepy libraries.
The data is stored in the Postgres database. To make it work, it's necessary to set correct connection parameters in file database.py.

To make Tweepy work it's necessary to generate application key, create a module twitter_auth and add one or more application keys to `auths` list.

Setting the application keys should be done like that:


```python
auths = []

# app1
CONSUMER_KEY = 'XXX'
CONSUMER_SECRET = 'XXX'
ACCESS_TOKEN = 'XXX'
ACCESS_TOKEN_SECRET = 'XXX'

auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.secure = True

auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
auths.append(auth)
```

The database schema is in file `schema.sql` but it doesn't make sense to use it if you don't have data from Huffington database.
 
## Collecting users
There are the following functions that can be run to retrieve the data located in `twitter_crawler` module:
 - check_most_active_users - retrieves the most active Huffington users (which are stored in `matching_users`) and tries to find matching Twitter users for them
 - check_hashtags - test whether Twitter Search API works for old dates (it doesn't)
 - load_followers_for_users_from_file - retrieves Huffington users (stored in `matching_users`) and loads random 20 followers for every Twitter user
 - load_following_for_users_from_file - retrieves Huffington users (stored in `matching_users`) and loads random 100 following for every Twitter user
 - load_follower_followed_data - load number of followers and followed users for every Twitter user from db
 
## Collecting hashtags
 - top_hashtags - search on Twitter for hashtags being top 10000 Huffington tags

It can be run multiple times. 
 
The other functions are used internally.
