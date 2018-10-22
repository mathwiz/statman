import sys
import csv
import unittest
import teams as t

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

teams = {}

def load_teams(file, dict):
    with open(file) as f:
        reader = csv.DictReader(f)
        t.load_from_reader(reader, dict)


class Test(unittest.TestCase):

    def test_favorite(self):
        reader = csv.DictReader(data1)
        for row in reader:
            if row['schedule_week'] == '1':
                self.assertEqual("Green Bay Packers", "")


if __name__ == '__main__':
    load_teams('../data/games/nfl_teams.csv', teams)
    print(teams)
    unittest.main()          