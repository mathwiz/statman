import unittest
import datetime
import functools
import statistics
import csv

PLACES = 3

def recency_span():
    return 5


def to_bool(aString):
    return aString == "TRUE"


def is_int(aString):
    try:
        int(aString)
        return True
    except ValueError:
        return False


def is_float(aString):
    try:
        float(aString)
        return True
    except ValueError:
        return False


def record_key(home, season):
    return f'{home}-{season}'


def extract_date(aString):
    try:
        return datetime.datetime.strptime(aString, '%m/%d/%Y')
    except:
        return None


def update_past_weeks(history, val):
    length = len(history)
    h = history.copy()
    h.insert(0, val)
    return h[:length]


def past_total(history, weeks_past):
    return functools.reduce(lambda a, x: a + x, history[1:weeks_past], 0)


def past_mean(history, weeks_past):
    if len(history[1:weeks_past]) == 0:
        return 0.0
    return round(statistics.mean(history[1:weeks_past]), PLACES)


def past_stdev(history, weeks_past):
    if len(history[1:weeks_past]) < 2:
        return None
    return round(statistics.stdev(history[1:weeks_past]), PLACES)


def past_median(history, weeks_past):
    if len(history[1:weeks_past]) == 0:
        return 0.0
    return round(statistics.median(history[1:weeks_past]), PLACES)


def previous_season_wins(team, season, records):
    key = record_key(team, int(season)-1)
    prev_season = records.get(key)
    return prev_season['wins'] if prev_season else  None


def key_fields(row):
    return (row['schedule_season'], row['schedule_week'], row['team_home'], row['team_away'])


def home_winner(row):
    home = int(row['score_home'])
    away = int(row['score_away'])
    result = home > away
    return result


def favorite_winner(row, favorite):
    home = int(row['score_home'])
    away = int(row['score_away'])
    if home > away:
        return favorite == row['team_home']
    elif away > home:
        return favorite == row['team_away']
    return False


def tie(row):
    return int(row['score_home']) == int(row['score_away'])


def game_win(row):
    if tie(row):
        #print(row['team_home'], row['score_home'], row['team_away'], row['score_away'], "TIE!")
        return (None, None)
    elif home_winner(row):
        #print(row['team_home'], row['score_home'], row['team_away'], row['score_away'])
        return (True, False)
    else:
        #print(row['team_away'], row['score_away'], row['team_home'], row['score_home'])
        return (False, True)


def spread(row):
    key = 'spread_favorite'
    spread = row[key]
    if spread == 'PICK':
        return 0.0
    elif is_float(row[key]):
        return float(spread)
    else:
        return None


def over_under(row):
    key = 'over_under_line'
    if is_float(row[key]):
        return float(row[key])
    else:
        return None


def to_score(aString):
    if is_int(aString):
        return int(aString)
    else:
        return None


def favorite_margin(row, home_fav):
    score_home = row['score_home']
    score_away = row['score_away']
    if score_away and score_home:
        if home_fav:
            return float(score_home) - float(score_away)
        else:
            return float(score_away) - float(score_home)
    else:
        return None 


def spread_diff(row, home_fav):
    line = spread(row)
    score_home = row['score_home']
    score_away = row['score_away']
    if line and score_away and score_home:
        if home_fav:
            return float(score_home) + float(line) - float(score_away)
        else:
            return float(score_away) + float(line) - float(score_home)
    else:
        return None 


def cover(row, home_fav):
    diff = spread_diff(row, home_fav) 
    return diff > 0.0 if diff != None else None


def over_under_diff(row):
    line = row['over_under_line']
    score_home = row['score_home']
    score_away = row['score_away']
    if line and score_away and score_home:
        return float(score_away) + float(score_home) - float(line)
    else:
        return None 


def over_under_result(row):
    diff = over_under_diff(row)
    if diff != None:
        if diff == 0.0:
            return 'Push'
        elif diff > 0.0:
            return 'Over'  
        else: 
            return 'Under'
    else:
        return 'NA' 


def add_game(records, team, season, week, win, loss, points, opp):
    key = f'{team}-{season}'
    if key not in records:
        records[key] = {'wins': 0, 'losses': 0, 'ties': 0, \
        'win_history': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], \
        'allowed_history': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], \
        'points_history': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] \
        } #todo: make this span seasons
    records[key]['wins'] = records[key]['wins'] + (1 if win else 0)
    records[key]['losses'] = records[key]['losses'] + (1 if loss else 0)
    records[key]['ties'] = records[key]['ties'] + (0 if win or loss else 1)
    records[key]['win_history'] = update_past_weeks(records[key]['win_history'], 1 if win else 0)
    records[key]['points_history'] = update_past_weeks(records[key]['points_history'], points)
    records[key]['allowed_history'] = update_past_weeks(records[key]['allowed_history'], opp)

