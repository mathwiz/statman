import unittest
import datetime
import functools
import statistics
import csv

PLACES = 1

def recency_span():
    return 5

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


def past_median(history, weeks_past):
    if len(history[1:weeks_past]) == 0:
        return 0.0
    return round(statistics.median(history[1:weeks_past]), PLACES)


def key_fields(row):
    return (row['schedule_season'], row['schedule_week'], row['team_home'], row['team_away'])


def home_winner(row):
    home = int(row['score_home'])
    away = int(row['score_away'])
    result = home > away
    #print(home, away, result)
    return result


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
    if is_float(row[key]):
        return float(row[key])
    else:
        return None


def over_under(row):
    key = 'over_under_line'
    if is_float(row[key]):
        return float(row[key])
    else:
        return None


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

