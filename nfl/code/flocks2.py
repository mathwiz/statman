import sys
import re
import datetime
import csv


prog = sys.argv[0]
file = '../data/games/Week_7_NFL_Odds.html' if len(sys.argv) < 2 else sys.argv[1]
outfile = 'a.csv' if len(sys.argv) < 3 else sys.argv[2]
output = open(outfile, mode='w')
writer = csv.writer(output, lineterminator='\n', quoting=csv.QUOTE_NONNUMERIC)


def check_season_and_week(line, current_season, week):
    match = re.match(r'.*Closing NFL Odds Week (\d{1,2}), (\d{4}).*',line)
    if match != None:
        return (match.group(2), match.group(1))
    return (current_season, week)


def find_date(line, season):
    match = re.match(r'.*<TD>(\d{1,2})\/(\d{1,2}) (\d{1,2})\:(\d\d) ((AM)|(PM)|(ET))</TD>.*',line)
    if match != None:
        d = datetime.datetime(int(season), int(match.group(1)), int(match.group(2)), int(match.group(3)), int(match.group(4)))
        #print(d.date(), d.time())
        return d
    return None


def find_team(line):
    home = re.search(r'.*<TD>At .*</TD>',line)
    away = not bool(home) 
    if home:
        match = re.match(r'.*<TD>At ([^<]*)</TD>',line)
    else:
        match = re.match(r'.*<TD>([^<]*)',line)
    if match != None:
        val = match.group(1).upper().rstrip().lstrip()
        if val[:3] == 'AT ':
            val = val[3:]
        return (val, bool(home), bool(away))
    return (None, None, None)


def find_number(line):
    pickem = re.search(r'.*PK.*',line)
    nonum = not re.search(r'.*<TD>.*\d?</TD>.*',line)
    match = re.match(r'.*<TD>(.*)</TD>.*',line)
    val = None
    if pickem or nonum:
        val = 99.0
    elif match != None:
        val = float(match.group(1))
    return val


def find_money(line):
    match = re.match(r'.*<TD>([\-\+]{1})\$(\d{3}).*([\-\+]{1})\$(\d{3})</TD>.*',line)
    val = (None, None)
    if match != None:
        val = (int(match.group(1)+match.group(2)), int(match.group(3)+match.group(4)))
    return val


def make_row(season, week, game, line):
    key = f'{game["date"].date().year}-{week}-{game["favorite"]}-{game["underdog"]}'                
    row = [key,
          season, week, 
          game['date'].date(), game['date'].time(), 
          game['favorite'], game['underdog'], game['home_team'], game['away_team'],
          game['fav_money'], game['und_money'], game['total'], game['spread'] 
          ]
    if 'AT ' in game['home_team']:
        print(row)
    writer.writerow(row)


def make_header():
        row = ['key',
              'season', 'week', 
              'date', 'time', 
              'favorite', 'underdog', 'home_team', 'away_team',
              'fav_money', 'und_money', 'total', 'spread' 
              ]
        #print(row)
        writer.writerow(row)


def set_home_away(game, team, home, away):
#    print(game)
    if home:
        game['home_team'] = team
    elif away:
        game['away_team'] = team
        


def process(file):
    season = None
    week = None
    date = None
    game = {}
    line_num = 999999
    game_total = 0
    make_header()
    current_line = ""
    with open(file) as f:
        for line in f:
            season, week = check_season_and_week(line, season, week)
            current_line = line.lstrip().rstrip()
            line_num += 1
            date = find_date(current_line, season)
            if date != None:
                line_num = 1
                game = {}
                game['date'] = date
                game_total += 1
            if line_num == 2:
                game['favorite'], home, away = find_team(current_line)
                set_home_away(game, game['favorite'], home, away)
            if line_num == 4:
                game['underdog'], home, away = find_team(current_line)
                set_home_away(game, game['underdog'], home, away)
            if line_num == 3:
                game['spread'] = find_number(current_line)
            if line_num == 5:
                game['total'] = find_number(current_line)
            if line_num == 6:
                game['fav_money'], game['und_money'] = find_money(current_line)
                make_row(season, week, game, current_line)
    return game_total


total = process(file)
print(f'{total} games')
output.close()