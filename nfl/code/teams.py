import csv


def team_favorite(row):
    return row['team_favorite_id']


def team_underdog(row):
    return row['team_favorite_id']


def load_from_reader(reader, teams):
    for row in reader:
        id = row['team_id']
        if id in teams:
            teams[id].append(row['team_name'])
        else:
            teams[id] = [row['team_name']]
    return teams