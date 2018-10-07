from urllib.request import urlopen
from bs4 import BeautifulSoup

html = urlopen("https://www.pro-football-reference.com/years/2017")
bsObj = BeautifulSoup(html.read(), "lxml")
print(bsObj.table)
