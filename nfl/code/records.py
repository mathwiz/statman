import sys
import csv
import datetime
import ifbdb as functions

outfile = 'a.csv' if len(sys.argv) < 3 else sys.argv[2]
output = open(outfile, mode='w')
writer = csv.writer(output, lineterminator='\n', quoting=csv.QUOTE_NONNUMERIC)

# embarrassing result turnaround
records = {}
teams = {}

def make_header():
    row = [
            'date', 'season', 'week',
            'home_team', 'home_wins' 'away_team', 'away_wins' 
            'favorite', 'underdog', 'spread',
            'home_recent_wins', 'away_recent_wins',  
            'home_recent_scoring', 'away_recent_scoring',  
            'home_recent_allowed', 'away_recent_allowed',  
          ]
    return row


def output_header():
    writer.writerow(make_header())


def output_line(line):
    if line[0] == '2017':
        print(line)
    writer.writerow(line)


def create_row(season, week, home, away, row):
    weeks_back = 5 if int(week) > 5 else int(week) - 1
    hist_len = weeks_back + 1
    row = [
    row['schedule_date'], season, week, \
    home, records[f'{home}-{season}']['wins'], \
    away, records[f'{away}-{season}']['wins'], \
    row['team_favorite_id'], row['team_favorite_id'], functions.spread(row), \
    functions.past_total(records[f'{home}-{season}']['win_history'],hist_len), \
    functions.past_total(records[f'{away}-{season}']['win_history'],hist_len), \
    functions.past_mean(records[f'{home}-{season}']['points_history'],hist_len), \
    functions.past_mean(records[f'{away}-{season}']['points_history'],hist_len), \
    functions.past_mean(records[f'{home}-{season}']['allowed_history'],hist_len), \
    functions.past_mean(records[f'{away}-{season}']['allowed_history'],hist_len), \
    ]
    return row


def process(file):
    line_num = 0
    output_header()
    with open(file) as f:
        reader = csv.DictReader(f)
        for row in reader:
            if functions.is_int(row['score_home']) and functions.is_int(row['schedule_week']):
                season, week, home, away = functions.key_fields(row)
                home_win, away_win = functions.game_win(row)
                functions.add_game(records, home, season, week, home_win==True, away_win==True, int(row['score_home']), int(row['score_away']))
                functions.add_game(records, away, season, week, away_win==True, home_win==True, int(row['score_away']), int(row['score_home']))
                output_line(create_row(season, week, home, away, row))
                line_num += 1
    print("Processed", line_num, "lines")


if __name__ == '__main__':
    process(sys.argv[1])
