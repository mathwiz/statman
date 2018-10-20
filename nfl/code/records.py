import sys
import csv
import datetime
import ifbdb as functions


# embarrassing result turnaround
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
        print(row['team_home'], row['score_home'], row['team_away'], row['score_away'], "TIE!")
        return (None, None)
    elif home_winner(row):
        print(row['team_home'], row['score_home'], row['team_away'], row['score_away'])
        return (True, False)
    else:
        print(row['team_away'], row['score_away'], row['team_home'], row['score_home'])
        return (False, True)


def output_row(season, week, home, away, row):
    weeks_back = 5 if int(week) > 5 else int(week) - 1
    hist_len = weeks_back + 1
    #todo: try trimmed mean
    print(season, week, home, away, \
    records[f'{home}-{season}']['wins'], \
    records[f'{away}-{season}']['wins'], \
    functions.past_total(records[f'{home}-{season}']['win_history'],hist_len), \
    functions.past_total(records[f'{away}-{season}']['win_history'],hist_len), \
    functions.past_mean(records[f'{home}-{season}']['points_history'],hist_len), \
    functions.past_mean(records[f'{away}-{season}']['points_history'],hist_len), \
    functions.past_median(records[f'{home}-{season}']['points_history'],hist_len), \
    functions.past_median(records[f'{away}-{season}']['points_history'],hist_len), \
    )


def process(file):
    line_num = 0
    with open(file) as f:
        reader = csv.DictReader(f)
        for row in reader:
            if functions.is_int(row['score_home']) and functions.is_int(row['schedule_week']):
                season, week, home, away = key_fields(row)
                home_win, away_win = game_win(row)
                functions.add_game(records, home, season, week, home_win==True, away_win==True, int(row['score_home']), int(row['score_away']))
                functions.add_game(records, away, season, week, away_win==True, home_win==True, int(row['score_away']), int(row['score_home']))
                output_row(season, week, home, away, row)
                line_num += 1
    print("Processed", line_num, "lines")


if __name__ == '__main__':
    process(sys.argv[1])
