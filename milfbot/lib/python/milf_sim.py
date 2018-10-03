import requests, numpy as np
from constants import leagueID, season, aliases, abbrevs, bye_weeks
from bs4 import BeautifulSoup

def lookup(s,d):
  if s in aliases:
    s = aliases[s]
  try:
    return d[s]
  except KeyError:
    return [0.,0.]

#Get projected scores from internet
positions = ['qb','rb','wr','te','k','d']
stats_dict = {}
for position in positions:
  soup = BeautifulSoup(requests.get('https://www.numberfire.com/nfl/fantasy/remaining-projections/%s' % position).text,features="lxml")
  players = [player.text for player in soup.select('span.full')]
  soup = soup.select('tbody.projection-table__body')[1].select('tr')
  p = {}
  for idx,player in enumerate(players):
    l = []
    stats = [num.text for num in soup[idx].select('td')]
    for stat in stats:
      try:
        l += [float(stat.strip()),]
      except:        
        if '-' in stat.strip():
          if '-' == stat.strip()[0]:
            sigma = [float(i) for i in stat.strip()[1:].split('-')]
            sigma = sigma[1]+sigma[0]
          else:
            sigma = [float(i) for i in stat.strip().split('-')]
            sigma = sigma[1]-sigma[0] 
            l += [sigma,]
    p[player] = l

  #account for .5ppr
  for player in p:
    s = p[player]
    if position == 'rb' or position == 'wr' or position == 'te':
      s[0] += s[5]/2
    p[player] = [s[0],s[1],]

  stats_dict[position] = p

#Get results and rosters from ESPN
sched = [[] for i in range(13)]
scores = [[] for i in range(10)]
wins = [[] for i in range(10)]
avgs = []
stdev = []
rosters = []
for owner in range(10):
  url = 'http://games.espn.com/ffl/schedule?leagueId=%i&teamId=%i' % (leagueID,owner+1)
  soup = BeautifulSoup(requests.get(url).text,features="lxml")
  rows = soup.select('table.tableBody')[0].select('tr')[2:15]
  gp = 0
  for week, row in enumerate(rows):
    result = row.find_all('a', href=True)[0].text
    opp = int(row.find_all('a', href=True)[1]['href'].split('teamId=')[1][0:2].replace('&',''))
    sched[week] += [opp,]
    if result[0] == 'W':
      wins[owner] += [1.,]
      scores[owner] += [float(result[2:result.find('-')])]
      gp += 1
    elif result[0] == 'L':
      wins[owner] += [0.,]
      scores[owner] += [float(result[2:result.find('-')])]
      gp += 1
  avgs += [np.mean(scores[owner]),]
  stdev += [np.std(scores[owner],ddof=1),]
  url = 'http://games.espn.com/ffl/clubhouse?leagueId=%i&teamId=%i&seasonId=%i' % (leagueID,owner+1,season)
  soup = BeautifulSoup(requests.get(url).text,features="lxml")
  roster = [player.a.text for player in soup.find_all('td',{'class':'playertablePlayerName'})]
  positions = [i.find(text=True, recursive=False).strip()[-2:].strip().lower() if i.find(text=True, recursive=False).strip()[-2:].strip().lower() != 'st' else 'd' for i in soup.find_all('td',{'class':'playertablePlayerName'})]
  teams = [i.find(text=True, recursive=False).strip().split(',')[-1].strip().split('\xa0')[0] for i in soup.find_all('td',{'class':'playertablePlayerName'})]
  dst_indices = [i for i, team in enumerate(teams) if team == "D/ST" ]
  teams = [abbrevs[roster[i].split(' ')[0]] if i in dst_indices else team for i, team in enumerate(teams)]
  byes = [bye_weeks[team] for team in teams]
  for idx, (player, position, team, bye,) in enumerate(zip(roster, positions, teams, byes)):
    stat = lookup(player,stats_dict[position])
    roster[idx] = [player,position,team,stat[0],stat[1],bye]
  rosters += [roster,]