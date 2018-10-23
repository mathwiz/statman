import csv


def team_favorite(row, teams):
    id = row.get('team_favorite_id')
    if not id or not teams.get(id):
        return None
    elif row['team_home'] in teams[id]:
        return row['team_home']
    elif row['team_away'] in teams[id]:
        return row['team_away']
    return None


def team_underdog(row, teams):
    id = row.get('team_favorite_id')
    if not id or not teams.get(id):
        return None
    elif row['team_home'] in teams[id]:
        return row['team_away']
    elif row['team_away'] in teams[id]:
        return row['team_home']
    return None


def load_from_reader(reader, teams):
    for row in reader:
        id = row['team_id']
        if id in teams:
            teams[id].append(row['team_name'])
        else:
            teams[id] = [row['team_name']]
    return teams