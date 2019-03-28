from bs4 import BeautifulSoup
from urllib.request import urlopen

domain = "www.pro-football-reference.com"
team = 'nwe'
year = 2018
url = f"https://{domain}/teams/{team}/{year}.htm"
print(url)


html = urlopen(url)
bsObj = BeautifulSoup(html.read(), features="lxml")


filename = f"{team}{year}.html"
print(filename)
file = open(filename, "w")
file.write(str(bsObj.body))

#print(bsObj.body)
