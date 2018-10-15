import sys
import re
import datetime
import csv


prog = sys.argv[0]
file = '../data/games/test2.html' if len(sys.argv) < 2 else sys.argv[1]
outfile = 'a.csv' if len(sys.argv) < 3 else sys.argv[2]
output = open(outfile, mode='w')
writer = csv.writer(output, lineterminator='\n', quoting=csv.QUOTE_NONNUMERIC)


def check_season_and_week(line, current_season, week):
    match = re.match(r'.*Closing NFL Odds Week (\d{1,2}), (\d{4}).*',line)
    if match != None:
        return (match.group(2), match.group(1))
    return (current_season, week)


def find_date(line, season):
    match = re.match(r'(\d{1,2})\/(\d{1,2}) (\d{1,2})\:(\d\d) ((AM)|(PM)|(ET))',line)
    if match:
#        print("found date", line, int(season), int(match.group(1)), int(match.group(2)), int(match.group(3)), int(match.group(4)))
        return datetime.datetime(int(season), int(match.group(1)), int(match.group(2)), int(match.group(3)), int(match.group(4)))
    return None


def find_team(line):
    val = line.upper()
    if val[:3] == 'AT ':
        val = val[3:]
    return val


def find_number(line):
    match = re.match(r'([-\.\d]+)',line)
    val = None
    if match:
        val = float(match.group(1))
    return val


def find_money(line):
    match = re.match(r'([\-\+]{1})\$(\d{3}).*([\-\+]{1})\$(\d{3})',line)
    val = (None, None)
    if match != None:
        val = (int(match.group(1)+match.group(2)), int(match.group(3)+match.group(4)))
    return val


def make_row(game):
    season = game['season']
    week = game['week']
    team1 = game.get('away_team', game['underdog'])
    team2 = game.get('home_team', game['favorite'])
    key = f'{game["date"].date().year}-{week}-{team1}-{team2}'                
    row = [key,
          season, week, 
          game['date'].date(), game['date'].time(), 
          game['favorite'], game['underdog'], game.get('home_team','NEUTRAL'), game.get('away_team','NEUTRAL'),
          game['fav_money'], game['und_money'], game['total'], game['spread'] 
          ]
    return row


def make_header():
    row = ['key',
          'season', 'week', 
          'date', 'time', 
          'favorite', 'underdog', 'home_team', 'away_team',
          'fav_money', 'und_money', 'total', 'spread' 
          ]
    return row
        


def is_home(line):
    return line .upper() .startswith('AT ')
    

def complete_line(line):
    return "<TD>" in line and "</TD>" in line


def extract_data(line):
    match = re.match(r'.*<TD>([^<]*)',line)
    if match:
        return match.group(1).upper().strip()
    return None
  

def make_line(season, week, text):
    return {'season': season, 'week': week, 'text': text}


def make_key(season, week, away, home):
    f'{season}-{week}-{away}-{home}'
    

def set_game_property(name, val, game):
    game[name] = val
    

def process_lines(file):
    season = None
    week = None
    current_line = ""
    lines = []
    line = {}
    with open(file) as f:
        for line in f:
            current_line = line.strip()
            if current_line .startswith("<TD>"):
                lines .append(make_line(season, week, extract_data(current_line)))
            else:
                season, week = check_season_and_week(current_line, season, week)
    return lines


def process_file(file):
    lines = process_lines(file)
    games = []
    line_num = 0
    for line in lines:
        date = find_date(line['text'], line['season'])
        if date:
            line_num = 1
            game = {}
            games .append(game)
            set_game_property('season', line['season'], game)
            set_game_property('week', line['week'], game)
            set_game_property('date', date, game)
        if line_num == 2:
            team = find_team(line['text'])
            set_game_property('favorite', team, game)
            if is_home(line['text']):
                set_game_property('home_team', team, game)
            else:
                set_game_property('away_team', team, game)
        if line_num == 4:
            team = find_team(line['text'])
            set_game_property('underdog', team, game)
            if is_home(line['text']):
                set_game_property('home_team', team, game)
            else:
                set_game_property('away_team', team, game)
            if 'home_team' not in game:
                game.pop('home_team', None)
                game.pop('away_team', None)                
        if line_num == 3:
            set_game_property('spread', find_number(line['text']), game)
        if line_num == 5:
            set_game_property('total', find_number(line['text']), game)
        if line_num == 6:
            fav, und = find_money(line['text'])
            set_game_property('fav_money', fav, game)
            set_game_property('und_money', und, game)
        line_num += 1
    return games


def write_output(games):
    writer.writerow(make_header())
    for game in games:
        print(game)
        writer.writerow(make_row(game))
        
        


games = process_file(file)
write_output(games)
print(f'{len(games)} games')
output.close()
