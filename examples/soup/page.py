from bs4 import BeautifulSoup
from urllib.request import urlopen

html = urlopen("https://www.pro-football-reference.com/teams/ram/2018.htm")

bsObj = BeautifulSoup(html.read(), features="lxml")

print(bsObj.html)
