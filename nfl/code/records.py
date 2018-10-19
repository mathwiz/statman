import sys
import csv
import datetime
import ifbdb as functions

records = {}

def row_key(row):
    return f'{row["schedule_season"]}-{row["schedule_week"]}-{row["team_away"]}-{row["team_home"]}'


def key_fields(row):
    return (row['schedule_season'], row['schedule_week'], row['team_home'], row['team_away'])


def make_key(team, season, week):
    return f'{team}-{season}-{week}'


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
        print("TIE!")
        return (None, None)
    elif home_winner(row):
        print(row['team_home'], row['score_home'], row['team_away'], row['score_away'])
        return (True, False)
    else:
        print(row['team_away'], row['score_away'], row['team_home'], row['score_home'])
        return (False, True)


def add_game(team, season, week, win, loss):
    key = f'{team}-{season}'
    if key not in records:
        records[key] = {'wins': 0, 'losses': 0, 'ties': 0, \
        'win_history': {0: 0, 1: 0, 2: 0, 3: 0}} #todo: make this span seasons
    records[key]['wins'] = records[key]['wins'] + (1 if win else 0)
    records[key]['losses'] = records[key]['losses'] + (1 if loss else 0)
    records[key]['ties'] = records[key]['ties'] + (0 if win or loss else 1)
    increment_history(team, season, week, win)


def increment_history(team, season, week, win):
    key = f'{team}-{season}'
    functions.update_past_weeks(records[key]['win_history'], win)


def output_row(season, week, home, away, row):
    print(season, week, home, away, \
    records[f'{home}-{season}']['wins'], \
    records[f'{away}-{season}']['wins'], \
    records[f'{home}-{season}']['win_history'][1], \
    records[f'{away}-{season}']['win_history'][1], \
    records[f'{home}-{season}']['win_history'][2], \
    records[f'{away}-{season}']['win_history'][2], \
    records[f'{home}-{season}']['win_history'][3], \
    records[f'{away}-{season}']['win_history'][3], \
    "End")


def process(file):
    line_num = 0
    with open(file) as f:
        reader = csv.DictReader(f)
        for row in reader:
            if functions.is_int(row['score_home']):
                season, week, home, away = key_fields(row)
                home_win, away_win = game_win(row)
                add_game(home, season, week, home_win==True, away_win==True)
                add_game(away, season, week, away_win==True, home_win==True)
                output_row(season, week, home, away, row)
                line_num += 1
    print("Processed", line_num, "lines")


if __name__ == '__main__':
    process(sys.argv[1])
