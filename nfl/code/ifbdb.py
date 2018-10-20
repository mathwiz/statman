import unittest
import datetime
import functools
import statistics
import csv

data1 = [
'schedule_date,schedule_season,schedule_week,team_home,team_away,stadium,team_favorite_id,spread_favorite,over_under_line,weather_detail,weather_temperature,weather_wind_mph,weather_humidity,score_home,score_away,stadium_neutral,schedule_playoff',
'09/10/2017,2017,1,Green Bay Packers,Seattle Seahawks,Lambeau Field,GB,-3,50.5,,69,8,,17,9,FALSE,FALSE',
'09/17/2017,2017,2,Seattle Seahawks,San Francisco 49ers,CenturyLink Field,SEA,-13.5,42.5,,65,11,,12,9,FALSE,FALSE',
'09/24/2017,2017,3,Tennessee Titans,Seattle Seahawks,LP Stadium,TEN,-3,42,,89,4,,33,27,FALSE,FALSE',
'10/01/2017,2017,4,Seattle Seahawks,Indianapolis Colts,CenturyLink Field,SEA,-13,41.5,,52,3,,46,17,FALSE,FALSE',
'10/08/2017,2017,5,Los Angeles Rams,Seattle Seahawks,Los Angeles Memorial Coliseum,LAR,-1,47.5,,75,6,,10,16,FALSE,FALSE',
'10/22/2017,2017,7,New York Giants,Seattle Seahawks,MetLife Stadium,SEA,-3.5,39,,74,7,,7,24,FALSE,FALSE',
'10/29/2017,2017,8,Seattle Seahawks,Houston Texans,CenturyLink Field,SEA,-5.5,46,,59,7,,41,38,FALSE,FALSE',
'11/05/2017,2017,9,Seattle Seahawks,Washington Redskins,CenturyLink Field,SEA,-8,44.5,Rain,36,11,,14,17,FALSE,FALSE',
'11/09/2017,2017,10,Arizona Cardinals,Seattle Seahawks,University of Phoenix Stadium,SEA,-6,40,DOME,72,0,,16,22,FALSE,FALSE',
'11/20/2017,2017,11,Seattle Seahawks,Atlanta Falcons,CenturyLink Field,SEA,-2,45.5,,48,2,,31,34,FALSE,FALSE',
'11/26/2017,2017,12,San Francisco 49ers,Seattle Seahawks,Levi''s Stadium,SEA,-7,43,,66,12,,13,24,FALSE,FALSE',
'12/03/2017,2017,13,Seattle Seahawks,Philadelphia Eagles,CenturyLink Field,PHI,-5.5,47.5,,44,3,,24,10,FALSE,FALSE',
'12/10/2017,2017,14,Jacksonville Jaguars,Seattle Seahawks,EverBank Field,JAX,-3,40,,46,2,,30,24,FALSE,FALSE',
'12/17/2017,2017,15,Seattle Seahawks,Los Angeles Rams,CenturyLink Field,LAR,-1,47.5,,47,15,,7,42,FALSE,FALSE',
'12/24/2017,2017,16,Dallas Cowboys,Seattle Seahawks,AT&T Stadium,DAL,-4.5,47,DOME,72,0,,12,21,FALSE,FALSE',
'12/31/2017,2017,17,Seattle Seahawks,Arizona Cardinals,CenturyLink Field,SEA,-8,38,,40,7,,24,26,FALSE,FALSE'
]

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
    return statistics.mean(history[1:weeks_past])


def past_median(history, weeks_past):
    print(history[1:weeks_past])
    if len(history[1:weeks_past]) == 0:
        return 0.0
    return statistics.median(history[1:weeks_past])


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


class Test(unittest.TestCase):
    def test_means(self):
        reader = csv.DictReader(data1)
        for row in reader:
            print(row)

    def test_past_weeks(self):
        h = [1, 0, 1, 0, 0, 1, 1, 0, 1]
        self.assertEqual(0, past_total(h, 0))
        self.assertEqual(0, past_total(h, 1))
        self.assertEqual(0, past_total(h, 2))
        self.assertEqual(1, past_total(h, 3))
        self.assertEqual(1, past_total(h, 4))
        self.assertEqual(1, past_total(h, 5))
        self.assertEqual(2, past_total(h, 6))
        self.assertEqual(3, past_total(h, 7))
        self.assertEqual(3, past_total(h, 8))
        self.assertEqual(4, past_total(h, 9))

    def test_past_weeks_update(self):
        h = [1, 0, 1, 0, 0, 1, 1, 1, 0]
        h2 = [0, 1, 0, 1, 0, 0, 1, 1, 1]
        h3 = [1, 1, 0, 1, 0, 0, 1, 1, 1]
        self.assertEqual(h2, update_past_weeks(h, False))
        self.assertEqual(h3, update_past_weeks(h, True))

    def test_good_int(self):
        self.assertTrue(is_int("17"))

    def test_good_float(self):
        self.assertTrue(is_float("17"))
        self.assertTrue(is_float("17.5"))

    def test_bad_number(self):
        self.assertFalse(is_int("foo"))
        self.assertFalse(is_float("foo"))

    def test_date(self):
        d = extract_date("12/10/2018")
        self.assertEqual(12, d.month)
        self.assertEqual(10, d.day)
        self.assertEqual(2018, d.year)


if __name__ == '__main__':
    unittest.main()

