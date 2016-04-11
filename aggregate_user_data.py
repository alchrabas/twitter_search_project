
all_matches = {}
for i in range(6):
    all_matches[i] = 0

users_file = open("matching_users.txt", "r")
for line in users_file:
    matches_list = eval(line[line.find("["):])
    all_matches[len(matches_list)] += 1


print(all_matches)
