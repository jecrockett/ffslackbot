from lxml import html
import requests, numpy as np, constants as c

#Import results data from text files
sched = np.loadtxt('schedule.txt')
wins = np.loadtxt('wins.txt')
scores = np.loadtxt('scores.txt')
avgs = []
stdev = []
for row in scores:
  avgs += [np.mean(row),]
  stdev += [np.std(row),]
gp = len(row)

#Get projected scores from internet
positions = ['qb','rb','wr','te','k','d']
stats = {}
for position in positions:
  tree = html.fromstring(requests.get('https://www.numberfire.com/nfl/fantasy/remaining-projections/%s' % position).content)
  players = tree.xpath('//td[@class="player"]//a//span[@class="full"]/text()')
  p = {}
  i = 1
  for player in players:
    l = []
    for stat in tree.xpath('//tr[@data-row-index="%i"]//td/text()' % i):
      try:
        l += [float(stat.strip()),]
      except:
        if '-' in stat.strip():
          sigma = [float(i) for i in stat.strip().split('-')]
          sigma = sigma[1]-sigma[0] 
          l += [sigma,]
    p[player] = l
    i+=1

  #account for .5ppr
  for player in p:
    s = p[player]
    if position == 'rb' or position == 'wr' or position == 'te':
      s[0] += s[5]/2
    p[player] = [s[0],s[1],]
  stats[position] = p

def lookup(s,d):
  if s in c.aliases:
    s = c.aliases[s]
  try:
    return d[s]
  except KeyError:
    return [0.,0.]

# Get rosters of teams
rosters = []
for i in range(10):
  url = 'http://games.espn.com/ffl/clubhouse?leagueId=%i&teamId=%i&seasonId=%i' % (c.league,c.ids[i],c.season)
  tree = html.fromstring(requests.get(url).content)
  roster = tree.xpath('//td[@class="playertablePlayerName"]//a/text()')
  positions = [i.strip()[-2:].strip().lower() if i.strip()[-2:].strip().lower() != 'st' else 'd' for i in tree.xpath('//td[@class="playertablePlayerName"]/text()')]
  for i in range(len(roster)):
    stat = lookup(roster[i],stats[positions[i]])
    roster[i] = [roster[i],positions[i],stat[0],stat[1]]
  rosters += [roster,]

print(rosters)