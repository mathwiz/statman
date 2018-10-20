import unittest
import csv
import ifbdb as functions

data1 = [
'schedule_date,schedule_season,schedule_week,team_home,team_away,stadium,team_favorite_id,spread_favorite,over_under_line,weather_detail,weather_temperature,weather_wind_mph,weather_humidity,score_home,score_away,stadium_neutral,schedule_playoff',
'09/10/2017,2017,1,Green Bay Packers,Seattle Seahawks,Lambeau Field,GB,-3,50.5,,69,8,,17,9,FALSE,FALSE',
'09/17/2017,2017,2,Seattle Seahawks,San Francisco 49ers,CenturyLink Field,SEA,-13.5,42.5,,65,11,,12,9,FALSE,FALSE',
'09/24/2017,2017,3,Tennessee Titans,Seattle Seahawks,LP Stadium,TEN,-3,42,,89,4,,33,27,FALSE,FALSE',
'10/01/2017,2017,4,Seattle Seahawks,Indianapolis Colts,CenturyLink Field,SEA,-13,41.5,,52,3,,46,18,FALSE,FALSE',
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
    all_hist_len = int(week)
    #todo: try trimmed mean
    print(week, home, away, \
    records[f'{home}-{season}']['wins'], \
    functions.past_total(records[f'{home}-{season}']['win_history'],hist_len), \
    functions.past_mean(records[f'{home}-{season}']['points_history'],all_hist_len), \
    functions.past_mean(records[f'{away}-{season}']['points_history'],all_hist_len), \
    functions.past_mean(records[f'{home}-{season}']['points_history'],hist_len), \
    functions.past_mean(records[f'{away}-{season}']['points_history'],hist_len), \
    functions.past_median(records[f'{home}-{season}']['points_history'],hist_len), \
    functions.past_median(records[f'{away}-{season}']['points_history'],hist_len), \
    functions.past_mean(records[f'{home}-{season}']['allowed_history'],hist_len), \
    functions.past_mean(records[f'{away}-{season}']['allowed_history'],hist_len), \
    functions.past_median(records[f'{home}-{season}']['allowed_history'],hist_len), \
    functions.past_median(records[f'{away}-{season}']['allowed_history'],hist_len), \
    )


class Test(unittest.TestCase):

    def meanAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['points_history']
        ahist = records[f'{away}-{season}']['points_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_mean(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(9.0, functions.past_mean(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(10.5, functions.past_mean(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(16, functions.past_mean(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(23.5, functions.past_mean(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(22, functions.past_mean(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(22.3333, functions.past_mean(hhist,7), places=3)
        elif game==9:
            self.assertAlmostEqual(25, functions.past_mean(hhist,8), places=3)
        elif game==10:
            self.assertAlmostEqual(23.625, functions.past_mean(ahist,9), places=3)
        elif game==11:
            self.assertAlmostEqual(23.4444, functions.past_mean(hhist,10), places=3)
        elif game==12:
            self.assertAlmostEqual(24.2, functions.past_mean(ahist,11), places=3)
        elif game==13:
            self.assertAlmostEqual(24.1818, functions.past_mean(hhist,12), places=3)
        elif game==14:
            self.assertAlmostEqual(24.1666, functions.past_mean(ahist,13), places=3)
        elif game==15:
            self.assertAlmostEqual(24.1538, functions.past_mean(hhist,14), places=3)
        elif game==16:
            self.assertAlmostEqual(22.9285, functions.past_mean(ahist,15), places=3)
        elif game==17:
            self.assertAlmostEqual(22.8, functions.past_mean(hhist,16), places=3)


    def recentMeanAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['points_history']
        ahist = records[f'{away}-{season}']['points_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_mean(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(9.0, functions.past_mean(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(10.5, functions.past_mean(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(16, functions.past_mean(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(23.5, functions.past_mean(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(22, functions.past_mean(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(25, functions.past_mean(hhist,6), places=3)
        elif game==9:
            self.assertAlmostEqual(30.8, functions.past_mean(hhist,6), places=3)
        elif game==10:
            self.assertAlmostEqual(28.2, functions.past_mean(ahist,6), places=3)
        elif game==11:
            self.assertAlmostEqual(23.4, functions.past_mean(hhist,6), places=3)
        elif game==12:
            self.assertAlmostEqual(26.4, functions.past_mean(ahist,6), places=3)
        elif game==13:
            self.assertAlmostEqual(26.4, functions.past_mean(hhist,6), places=3)
        elif game==14:
            self.assertAlmostEqual(23, functions.past_mean(ahist,6), places=3)
        elif game==15:
            self.assertAlmostEqual(25, functions.past_mean(hhist,6), places=3)
        elif game==16:
            self.assertAlmostEqual(22, functions.past_mean(ahist,6), places=3)
        elif game==17:
            self.assertAlmostEqual(20, functions.past_mean(hhist,6), places=3)


    def medianAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['points_history']
        ahist = records[f'{away}-{season}']['points_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_median(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(9, functions.past_median(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(10.5, functions.past_median(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(12, functions.past_median(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(19.5, functions.past_median(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(16, functions.past_median(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(20, functions.past_median(hhist,7), places=3)
        elif game==9:
            self.assertAlmostEqual(24, functions.past_median(hhist,8), places=3)
        elif game==10:
            self.assertAlmostEqual(20, functions.past_median(ahist,9), places=3)
        elif game==11:
            self.assertAlmostEqual(22, functions.past_median(hhist,10), places=3)
        elif game==12:
            self.assertAlmostEqual(23, functions.past_median(ahist,11), places=3)
        elif game==13:
            self.assertAlmostEqual(24, functions.past_median(hhist,12), places=3)
        elif game==14:
            self.assertAlmostEqual(24, functions.past_median(ahist,13), places=3)
        elif game==15:
            self.assertAlmostEqual(24, functions.past_median(hhist,14), places=3)
        elif game==16:
            self.assertAlmostEqual(24, functions.past_median(ahist,15), places=3)
        elif game==17:
            self.assertAlmostEqual(24, functions.past_median(hhist,16), places=3)


    def recentMedianAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['points_history']
        ahist = records[f'{away}-{season}']['points_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_median(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(9, functions.past_median(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(10.5, functions.past_median(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(12, functions.past_median(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(19.5, functions.past_median(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(16, functions.past_median(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(24, functions.past_median(hhist,6), places=3)
        elif game==9:
            self.assertAlmostEqual(27, functions.past_median(hhist,6), places=3)
        elif game==10:
            self.assertAlmostEqual(24, functions.past_median(ahist,6), places=3)
        elif game==11:
            self.assertAlmostEqual(22, functions.past_median(hhist,6), places=3)
        elif game==12:
            self.assertAlmostEqual(24, functions.past_median(ahist,6), places=3)
        elif game==13:
            self.assertAlmostEqual(24, functions.past_median(hhist,6), places=3)
        elif game==14:
            self.assertAlmostEqual(24, functions.past_median(ahist,6), places=3)
        elif game==15:
            self.assertAlmostEqual(24, functions.past_median(hhist,6), places=3)
        elif game==16:
            self.assertAlmostEqual(24, functions.past_median(ahist,6), places=3)
        elif game==17:
            self.assertAlmostEqual(24, functions.past_median(hhist,6), places=3)



    def againstMeanAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['allowed_history']
        ahist = records[f'{away}-{season}']['allowed_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_mean(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(17, functions.past_mean(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(13, functions.past_mean(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(19.6666, functions.past_mean(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(19.25, functions.past_mean(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(17.4, functions.past_mean(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(15.6666, functions.past_mean(hhist,7), places=3)
        elif game==9:
            self.assertAlmostEqual(18.8571, functions.past_mean(hhist,8), places=3)
        elif game==10:
            self.assertAlmostEqual(18.625, functions.past_mean(ahist,9), places=3)
        elif game==11:
            self.assertAlmostEqual(18.3333, functions.past_mean(hhist,10), places=3)
        elif game==12:
            self.assertAlmostEqual(19.9, functions.past_mean(ahist,11), places=3)
        elif game==13:
            self.assertAlmostEqual(19.2727, functions.past_mean(hhist,12), places=3)
        elif game==14:
            self.assertAlmostEqual(18.5, functions.past_mean(ahist,13), places=3)
        elif game==15:
            self.assertAlmostEqual(19.3846, functions.past_mean(hhist,14), places=3)
        elif game==16:
            self.assertAlmostEqual(21, functions.past_mean(ahist,15), places=3)
        elif game==17:
            self.assertAlmostEqual(20.4, functions.past_mean(hhist,16), places=3)


    def againstRecentMeanAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['allowed_history']
        ahist = records[f'{away}-{season}']['allowed_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_mean(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(17, functions.past_mean(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(13, functions.past_mean(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(19.6666, functions.past_mean(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(19.25, functions.past_mean(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(17.4, functions.past_mean(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(15.4, functions.past_mean(hhist,6), places=3)
        elif game==9:
            self.assertAlmostEqual(21.2, functions.past_mean(hhist,6), places=3)
        elif game==10:
            self.assertAlmostEqual(18, functions.past_mean(ahist,6), places=3)
        elif game==11:
            self.assertAlmostEqual(17.6, functions.past_mean(hhist,6), places=3)
        elif game==12:
            self.assertAlmostEqual(22.4, functions.past_mean(ahist,6), places=3)
        elif game==13:
            self.assertAlmostEqual(23.6, functions.past_mean(hhist,6), places=3)
        elif game==14:
            self.assertAlmostEqual(18, functions.past_mean(ahist,6), places=3)
        elif game==15:
            self.assertAlmostEqual(20.6, functions.past_mean(hhist,6), places=3)
        elif game==16:
            self.assertAlmostEqual(25.8, functions.past_mean(ahist,6), places=3)
        elif game==17:
            self.assertAlmostEqual(21.4, functions.past_mean(hhist,6), places=3)


    def againstMedianAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['allowed_history']
        ahist = records[f'{away}-{season}']['allowed_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_median(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(17, functions.past_median(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(13, functions.past_median(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(17, functions.past_median(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(17.5, functions.past_median(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(17, functions.past_median(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(13.5, functions.past_median(hhist,7), places=3)
        elif game==9:
            self.assertAlmostEqual(17, functions.past_median(hhist,8), places=3)
        elif game==10:
            self.assertAlmostEqual(17, functions.past_median(ahist,9), places=3)
        elif game==11:
            self.assertAlmostEqual(17, functions.past_median(hhist,10), places=3)
        elif game==12:
            self.assertAlmostEqual(17, functions.past_median(ahist,11), places=3)
        elif game==13:
            self.assertAlmostEqual(17, functions.past_median(hhist,12), places=3)
        elif game==14:
            self.assertAlmostEqual(16.5, functions.past_median(ahist,13), places=3)
        elif game==15:
            self.assertAlmostEqual(17, functions.past_median(hhist,14), places=3)
        elif game==16:
            self.assertAlmostEqual(17, functions.past_median(ahist,15), places=3)
        elif game==17:
            self.assertAlmostEqual(17, functions.past_median(hhist,16), places=3)


    def againstRecentMedianAssert(self, season, week, home, away):
        game = int(week)
        hhist = records[f'{home}-{season}']['allowed_history']
        ahist = records[f'{away}-{season}']['allowed_history']
        if game==1:
            self.assertAlmostEqual(0.0, functions.past_median(hhist,1), places=3)
        elif game==2:
            self.assertAlmostEqual(17, functions.past_median(hhist,2), places=3)
        elif game==3:
            self.assertAlmostEqual(13, functions.past_median(ahist,3), places=3)
        elif game==4:
            self.assertAlmostEqual(17, functions.past_median(hhist,4), places=3)
        elif game==5:
            self.assertAlmostEqual(17.5, functions.past_median(ahist,5), places=3)
        elif game==7:
            self.assertAlmostEqual(17, functions.past_median(ahist,6), places=3)
        elif game==8:
            self.assertAlmostEqual(10, functions.past_median(hhist,6), places=3)
        elif game==9:
            self.assertAlmostEqual(18, functions.past_median(hhist,6), places=3)
        elif game==10:
            self.assertAlmostEqual(17, functions.past_median(ahist,6), places=3)
        elif game==11:
            self.assertAlmostEqual(16, functions.past_median(hhist,6), places=3)
        elif game==12:
            self.assertAlmostEqual(17, functions.past_median(ahist,6), places=3)
        elif game==13:
            self.assertAlmostEqual(17, functions.past_median(hhist,6), places=3)
        elif game==14:
            self.assertAlmostEqual(16, functions.past_median(ahist,6), places=3)
        elif game==15:
            self.assertAlmostEqual(16, functions.past_median(hhist,6), places=3)
        elif game==16:
            self.assertAlmostEqual(30, functions.past_median(ahist,6), places=3)
        elif game==17:
            self.assertAlmostEqual(13, functions.past_median(hhist,6), places=3)


    def test_stats(self):
        reader = csv.DictReader(data1)
        for row in reader:
            if functions.is_int(row['score_home']) and functions.is_int(row['schedule_week']):
                season, week, home, away = functions.key_fields(row)
                home_win, away_win = functions.game_win(row)
                functions.add_game(records, home, season, week, home_win==True, away_win==True, int(row['score_home']), int(row['score_away']))
                functions.add_game(records, away, season, week, away_win==True, home_win==True, int(row['score_away']), int(row['score_home']))
                self.meanAssert(season, week, home, away)
                self.recentMeanAssert(season, week, home, away)
                self.medianAssert(season, week, home, away)
                self.recentMedianAssert(season, week, home, away)
                self.againstMeanAssert(season, week, home, away)
                self.againstRecentMeanAssert(season, week, home, away)
                self.againstMedianAssert(season, week, home, away)
                self.againstRecentMedianAssert(season, week, home, away)
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

