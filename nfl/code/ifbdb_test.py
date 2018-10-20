import unittest
import csv
import ifbdb as functions

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

records = {}


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


class Test(unittest.TestCase):
    def test_means(self):
        reader = csv.DictReader(data1)
        for row in reader:
            if functions.is_int(row['score_home']) and functions.is_int(row['schedule_week']):
                season, week, home, away = functions.key_fields(row)
                home_win, away_win = functions.game_win(row)
                functions.add_game(records, home, season, week, home_win==True, away_win==True, int(row['score_home']), int(row['score_away']))
                functions.add_game(records, away, season, week, away_win==True, home_win==True, int(row['score_away']), int(row['score_home']))
                output_row(season, week, home, away, row)

    def test_past_weeks(self):
        h = [1, 0, 1, 0, 0, 1, 1, 0, 1]
        self.assertEqual(0, functions.past_total(h, 0))
        self.assertEqual(0, functions.past_total(h, 1))
        self.assertEqual(0, functions.past_total(h, 2))
        self.assertEqual(1, functions.past_total(h, 3))
        self.assertEqual(1, functions.past_total(h, 4))
        self.assertEqual(1, functions.past_total(h, 5))
        self.assertEqual(2, functions.past_total(h, 6))
        self.assertEqual(3, functions.past_total(h, 7))
        self.assertEqual(3, functions.past_total(h, 8))
        self.assertEqual(4, functions.past_total(h, 9))

    def test_past_weeks_update(self):
        h = [1, 0, 1, 0, 0, 1, 1, 1, 0]
        h2 = [0, 1, 0, 1, 0, 0, 1, 1, 1]
        h3 = [1, 1, 0, 1, 0, 0, 1, 1, 1]
        self.assertEqual(h2, functions.update_past_weeks(h, False))
        self.assertEqual(h3, functions.update_past_weeks(h, True))

    def test_good_int(self):
        self.assertTrue(functions.is_int("17"))

    def test_good_float(self):
        self.assertTrue(functions.is_float("17"))
        self.assertTrue(functions.is_float("17.5"))

    def test_bad_number(self):
        self.assertFalse(functions.is_int("foo"))
        self.assertFalse(functions.is_float("foo"))

    def test_date(self):
        d = functions.extract_date("12/10/2018")
        self.assertEqual(12, d.month)
        self.assertEqual(10, d.day)
        self.assertEqual(2018, d.year)


if __name__ == '__main__':
    unittest.main()

