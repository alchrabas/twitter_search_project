# -*- coding: utf-8 -*-
import tweepy

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

print(API.search_users("Alexander Chrabąszcz", 5, 1))
