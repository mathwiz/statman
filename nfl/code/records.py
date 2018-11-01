import sys
import csv
import datetime
import ifbdb as functions
import teams as t

outfile = 'a.csv' if len(sys.argv) < 4 else sys.argv[3]
output = open(outfile, mode='w')
writer = csv.writer(output, lineterminator='\n', quoting=csv.QUOTE_MINIMAL)

# embarrassing result turnaround
records = {}
teams = {}

def output_header():
    writer.writerow(make_header())


def output_line(line):
    if line[12]:
        writer.writerow(line)


def make_header():
    row = [
            'date', 
            'season', 'week',
            'stadium',
            'home_team', 'away_team',
            'home_last_season_wins', 'away_last_season_wins',
            'favorite', 'underdog', 
            'spread',
            'home_fav',
            'over_under_line',
            'home_recent_wins', 'away_recent_wins',  
            'home_recent_scoring', 'away_recent_scoring',  
            'home_scoring_dev', 'away_scoring_dev',  
            'home_recent_allowed', 'away_recent_allowed',  
            'home_allowed_dev', 'away_allowed_dev',  
            'neutral',
            'playoff',
            'score_home', 'score_away',
            'home_win', 
            'fav_win',
            'cover',
            'favorite_margin',
            'spread_diff',
            'over_under_result', 
            'over_under_total',
            'over_under_diff'
          ]
    return row


def create_row(season, week, home, away, row):
    span = functions.recency_span()
    weeks_back = span if int(week) > span else int(week) - 1
    all_weeks_back = int(week) - 1
    hist_len = weeks_back + 1
    home_key = functions.record_key(home, season)
    away_key = functions.record_key(away, season)
    score_home = functions.to_score(row['score_home'])
    score_away = functions.to_score(row['score_away'])
    spread = functions.spread(row)
    over_under = functions.over_under(row)
    home_winner = functions.home_winner(row)
    favorite = t.team_favorite(row, teams)
    underdog = t.team_underdog(row, teams)
    home_fav = favorite == home
    row = [
        functions.extract_date(row['schedule_date']).date(), 
        int(season), int(week), 
        row['stadium'],
        home, 
        # functions.past_total(records[home_key]['win_history'], all_weeks_back), 
        away, 
        # functions.past_total(records[away_key]['win_history'], all_weeks_back), 
        functions.previous_season_wins(home, season, records), 
        functions.previous_season_wins(away, season, records), 
        favorite, 
        underdog, 
        spread, 
        "Home" if home_fav else "Away",
        over_under, 
        functions.past_total(records[home_key]['win_history'],hist_len), 
        functions.past_total(records[away_key]['win_history'],hist_len), 
        functions.past_mean(records[home_key]['points_history'],hist_len), 
        functions.past_mean(records[away_key]['points_history'],hist_len), 
        functions.past_stdev(records[home_key]['points_history'],all_weeks_back), 
        functions.past_stdev(records[away_key]['points_history'],all_weeks_back), 
        functions.past_mean(records[home_key]['allowed_history'],hist_len), 
        functions.past_mean(records[away_key]['allowed_history'],hist_len), 
        functions.past_stdev(records[home_key]['allowed_history'],all_weeks_back), 
        functions.past_stdev(records[away_key]['allowed_history'],all_weeks_back), 
        "Neutral" if functions.to_bool(row['stadium_neutral']) else "Home", 
        "Playoff" if functions.to_bool(row['schedule_playoff']) else "Regular", 
        score_home, 
        score_away, 
        "Home" if home_winner else "Away", 
        "Favorite" if functions.favorite_winner(row, favorite) else "Underdog",
        "Cover" if functions.cover(row, home_fav) else "Not Cover", 
        functions.favorite_margin(row, home_fav),
        functions.spread_diff(row, home_fav),
        functions.over_under_result(row),
        score_away + score_home,
        functions.over_under_diff(row),
    ]
    return row


def load_teams(file, dict):
    with open(file) as f:
        reader = csv.DictReader(f)
        t.load_from_reader(reader, dict)


def process(file, teamsfile):
    line_num = 0
    load_teams(teamsfile, teams)
    print(teams)
    output_header()
    with open(file) as f:
        reader = csv.DictReader(f)
        for row in reader:
            season, week, home, away = functions.key_fields(row)
            if functions.is_int(row['score_home']) \
                and int(season) > 1977 \
                and functions.is_int(row['schedule_week']):
                home_win, away_win = functions.game_win(row)
                functions.add_game(records, home, season, week, home_win==True, away_win==True, int(row['score_home']), int(row['score_away']))
                functions.add_game(records, away, season, week, away_win==True, home_win==True, int(row['score_away']), int(row['score_home']))
                output_line(create_row(season, week, home, away, row))
                line_num += 1
    print("Processed", line_num, "lines")
    output.close()


if __name__ == '__main__':
    process(sys.argv[1], sys.argv[2])
