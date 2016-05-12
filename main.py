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


def get_id_by_name(name, cur):
    cur.execute("SELECT id FROM twitter_users WHERE username = %s", (name,))
    return cur.fetchone()[0]


def is_user_in_db(user_name_or_id, cur):
    try:
        user_id = int(user_name_or_id)
    except ValueError:
        user_id = 0
    cur.execute("SELECT COUNT(*) FROM twitter_users WHERE username = %s OR id = %s", (str(user_name_or_id), user_id,))
    return cur.fetchone()[0]


def save_user_in_db(user, cur):
    if isinstance(user, (str, int)):
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


def save_a_follower(followed_id, follower_id, cur):
    cur.execute("SELECT COUNT(*) FROM twitter_follows WHERE followed = %s AND follower = %s",
                (followed_id, follower_id))
    if not cur.fetchone()[0]:
        cur.execute("""INSERT INTO twitter_follows (followed, follower)
            VALUES (%s, %s)""", (followed_id, follower_id))
    else:
        print("User " + str(follower_id) + " is already following " + str(followed_id))


def load_followers_for_users_from_file():
    huff_twitt_matches = open("matching_users.txt", "r")
    failed_users_file = open("failed_users3.txt", "a")

    cur = conn.cursor()

    start_time = time.time()

    line_no = 0
    LINES_TO_SKIP = 0
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
                    save_a_follower(twitter_user.id, follower.id, cur)
                try:
                    conn.commit()
                except:
                    print("### SOMETHING BAD HAS HAPPENED WHEN WORKING ON {}, BUT WE GO FORWARD".format(twitter_name))
                    conn.rollback()
                    failed_users_file.write(line + "\n")
                    failed_users_file.flush()

        except:
            print("### SOMETHING HAS BROKEN INCORRECTLY ", str(sys.exc_info()), traceback.print_exc())
            conn.rollback()
            failed_users_file.write(line)
            failed_users_file.flush()

    failed_users_file.close()


def load_following_for_users_from_file():
    huff_twitt_matches = open("matching_users.txt", "r")
    failed_users_file = open("failed_users4.txt", "a")

    cur = conn.cursor()

    start_time = time.time()

    existing_users = 0
    not_existing_users = 0

    line_no = 0
    LINES_TO_SKIP = 124
    for line in huff_twitt_matches:
        curr_time = time.time()
        print("Elapsed time: ", curr_time - start_time, "existed:", existing_users, "not existed:", not_existing_users)
        line_no += 1
        if line_no < LINES_TO_SKIP:
            continue

        try:
            huff_name, twitter_names = split_huff_and_twitter_line(line)

            for twitter_name in twitter_names:
                print("Working on ", twitter_name)
                if not is_user_in_db(twitter_name, cur):
                    twitter_user = get_api_and_move_to_end().get_user(twitter_name)  # 1 CALL
                    print("who wasn't in db")

                    save_user_in_db(twitter_user, cur)
                    link_huff_user_with_twitter(huff_name, twitter_user.id, cur)

                next_cursor = -1
                response = get_api_and_move_to_end().friends_ids(screen_name=twitter_name,
                                                                 cursor=next_cursor)  # 1 CALL

                followed_ids = response[0]
                print("Has ", len(followed_ids), " follows")
                if len(followed_ids) > 100:  # limit to 100
                    followed_ids = followed_ids[:100]

                for followed_id in followed_ids:

                    if not is_user_in_db(followed_id, cur):
                        save_user_in_db(followed_id, cur)
                        not_existing_users += 1
                    else:
                        existing_users += 1
                    save_a_follower(followed_id, get_id_by_name(twitter_name, cur), cur)
                try:
                    conn.commit()
                except:
                    print("### SOMETHING BAD HAS HAPPENED WHEN WORKING ON {}, BUT WE GO FORWARD".format(twitter_name))
                    conn.rollback()
                    failed_users_file.write(line + "\n")
                    failed_users_file.flush()

        except:
            print("### SOMETHING HAS BROKEN INCORRECTLY ", str(sys.exc_info()), traceback.print_exc())
            conn.rollback()
            failed_users_file.write(line)
            failed_users_file.flush()

    failed_users_file.close()


def split_huff_and_twitter_line(line):
    huff_name, _, twitter_names = line.partition(" [")
    twitter_names = eval("[" + twitter_names)
    return huff_name, twitter_names


def top_hashtags():
    top_tags = open("data/huff_top_tags.csv", "r")
    failed_tags_file = open("failed_tags.txt", "a")

    cur = conn.cursor()

    start_time = time.time()

    LINES_TO_SKIP = 3207
    line_no = 0

    for tag in top_tags:
        line_no += 1
        if line_no < LINES_TO_SKIP:
            continue

        tag = tag.strip()
        tag = tag.replace(" ", "")

        print("Search for tag ", tag)
        print("Time elapsed: ", (time.time() - start_time))
        try:
            search_results = get_api_and_move_to_end().search(q="#" + tag, lang="en", rpp=100)
            for result in search_results:

                if not is_user_in_db(result.author.id, cur):
                    save_user_in_db(result.author, cur)

                cur.execute("""INSERT INTO tweets (id, author_id, text, date)
                VALUES (%s, %s, %s, %s)""", (result.id, result.author.id, result.text, result.created_at))

                conn.commit()
        except:
            print("### SOMETHING HAS BROKEN INCORRECTLY ", str(sys.exc_info()), traceback.print_exc())
            conn.rollback()
            failed_tags_file.write(tag)
            failed_tags_file.flush()


top_hashtags()
