import tweepy
import time

CONSUMER_KEY = 'u7mL2spLw8wSOhE7iq1DC4KPX'
CONSUMER_SECRET = 'WZzq8RcKtybhxzi6L5f4J9UY5aRSzFRp2kZnKgUVFGnogFzEnQ'

# The access tokens can be found on your applications's Details
# page located at https://dev.twitter.com/apps (located
# under "Your access token")
ACCESS_TOKEN = '500255045-7nsZZMFq4BhQaVwh6zDhZvu19zrYaTD8tMA9mHW8'
ACCESS_TOKEN_SECRET = 'RGclAIedkRHtls2d31dgnBk3pqey1UQFnw1P7moTBg8I8'

auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.secure = True
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

API = tweepy.API(auth)

API_REQUESTS_BEFORE_COOLDOWN = 100
API_COOLDOWN_MINUTES = 16  # keep safe above 15 minute window


def check_most_active_users():
    i = 0

    huff_users_file = open("top_huff_users.txt", "r")
    out_file = open("matching_users.txt", "w")
    for line in huff_users_file:
        user_tuple = eval(line)
        user_name = user_tuple[0]
        i += 1
        if i >= API_REQUESTS_BEFORE_COOLDOWN:
            i = 0
            time.sleep(API_COOLDOWN_MINUTES * 60)
        else:
            time.sleep(1)

        matching_users = [found_user.screen_name for found_user in API.search_users(user_name, 5, 1)]

        out_file.write(user_name + " " + str(matching_users) + "\n")
    out_file.close()


def check_hashtags():
    for line in [a for a in API.search("#potatoes since:2016-01-02", rpp=10)]:
        # Search api returns the results for the last 6-9 days.
        print(line)

        # check_hashtags()


check_most_active_users()
