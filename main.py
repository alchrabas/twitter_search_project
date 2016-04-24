import traceback
import sys, time

import tweepy
from database import conn

from twitter_auth import auths

apis = [tweepy.API(auth, wait_on_rate_limit=True) for auth in auths]


def get_api_and_move_to_end():
    first_element = apis.pop(0)
    apis.append(first_element)
    return first_element


def check_most_active_users():
    huff_users_file = open("top_huff_users.txt", "r")
    # out_file = open("matching_users.txt", "a")

    for i in range(956):
        huff_users_file.readline()

    for line in huff_users_file:
        user_tuple = eval(line)
        user_name = user_tuple[0]
        print("try ", user_name)

        matching_users = [found_user.screen_name for found_user in
                          get_api_and_move_to_end().search_users(user_name, 5, 1)]

        print(matching_users)
        # out_file.write(user_name + " " + str(matching_users) + "\n")
        # out_file.flush()
        # out_file.close()


def check_hashtags():
    for line in [a for a in get_api_and_move_to_end().search("#potatoes since:2016-01-02", rpp=10)]:
        # Search api returns the results for the last 6-9 days.
        print(line)

        # check_hashtags()


def save_user_in_db(user, cur):
    if isinstance(user, str):
        user = get_api_and_move_to_end().get_user(user)

    cur.execute("SELECT COUNT(*) FROM twitter_users WHERE id = %s", (user.id,))

    if not cur.fetchone()[0]:
        cur.execute("""INSERT INTO twitter_users (id, username, real_name, avatar_url, description, location)
        VALUES (%s, %s, %s, %s, %s, %s)""", (user.id, user.screen_name, user.name,
                                             user.profile_image_url, user.description, user.location))
    else:
        print(user.screen_name + " already exists")


def link_huff_user_with_twitter(huff_name, twitter_user_id, cur):
    cur.execute("SELECT id FROM authors WHERE name = %s", (huff_name,))
    huff_id = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM huff_twitter_users_junction WHERE huff_author_id = %s AND twitter_user_id = %s",
                (huff_id, twitter_user_id))

    if not cur.fetchone()[0]:
        cur.execute("""INSERT INTO huff_twitter_users_junction (huff_author_id, twitter_user_id)
          VALUES (%s, %s)""", (huff_id, twitter_user_id))
    else:
        print("Junction between " + huff_name + " and " + str(twitter_user_id) + " already exists")


def save_a_follower(followed, follower, cur):
    cur.execute("SELECT COUNT(*) FROM twitter_follows WHERE followed = %s AND follower = %s",
                (followed.id, follower.id))
    if not cur.fetchone()[0]:
        cur.execute("""INSERT INTO twitter_follows (followed, follower)
            VALUES (%s, %s)""", (followed.id, follower.id))
    else:
        print("User " + follower.screen_name + " is already following " + followed.screen_name)


def load_followers_for_users_from_file():
    huff_twitt_matches = open("matching_users.txt", "r")

    cur = conn.cursor()

    start_time = time.time()

    line_no = 0
    LINES_TO_SKIP = 99
    for line in huff_twitt_matches:

        curr_time = time.time()
        print("Elapsed time: ", curr_time - start_time)
        line_no += 1
        if line_no < LINES_TO_SKIP:
            continue

        try:
            huff_name, twitter_names = split_huff_and_twitter_line(line)

            for twitter_name in twitter_names:

                twitter_user = get_api_and_move_to_end().get_user(twitter_name)  # 1 CALL
                print("Working on ", twitter_name, " having ", twitter_user.followers_count, "followers")

                save_user_in_db(twitter_user, cur)
                link_huff_user_with_twitter(huff_name, twitter_user.id, cur)

                next_cursor = -1
                followers = get_api_and_move_to_end().followers(twitter_user.id, next_cursor)  # 1 CALL

                for follower in followers:
                    save_user_in_db(follower, cur)
                    save_a_follower(twitter_user, follower, cur)
                try:
                    conn.commit()
                except:
                    print("### SOMETHING BAD HAS HAPPENED WHEN WORKING ON {}, BUT WE GO FORWARD".format(twitter_name))
                    conn.rollback()
        except:
            print("### SOMETHING HAS BROKEN INCORRECTLY ", str(sys.exc_info()), traceback.print_exc())


def split_huff_and_twitter_line(line):
    huff_name, _, twitter_names = line.partition(" [")
    twitter_names = eval("[" + twitter_names)
    return huff_name, twitter_names


load_followers_for_users_from_file()
