--Identify home wins, losses or draw
SELECT id,
CASE WHEN team1_goal > team2_goal THEN 'Home win!'
WHEN team1_goal < team2_goal THEN 'Home loss'
ELSE 'Draw' END AS outcome
FROM scores

--Select matches where Netherlands was ‘Team 2’
SELECT s.id, t.name,
CASE WHEN team1_goal > team2_goal THEN 'Holland lose!'
WHEN team1_goal < team2_goal THEN 'Holland win!'
ELSE 'Draw' END AS Outcome
FROM scores s
JOIN teams t
ON s.team1_id = t.id
WHERE team2_id = 11

--Identify when Belgium won a match in Euro 2020
SELECT m.date, s.name, v.name, 
CASE WHEN scores.team1_id = 1 AND team1_goal > team2_goal THEN 'Belgium win'
WHEN scores.team2_id = 1 AND team2_goal > team1_goal THEN 'Belgium win'
END AS outcome
FROM scores
JOIN match m
ON scores.id = m.id
JOIN stages s
ON scores.stage_id = s.id
JOIN venues v
ON scores.venue_id = v.id

--Sum the total records in each stages where Team 1 won
SELECT s.name AS Stages,
SUM(CASE WHEN stage_id = 1 AND team1_goal > team2_goal THEN 1 ELSE 0 END) AS Matchday_1,
SUM(CASE WHEN stage_id = 2 AND team1_goal > team2_goal THEN 1 ELSE 0 END) AS Matchday_2,
SUM(CASE WHEN stage_id = 3 AND team1_goal > team2_goal THEN 1 ELSE 0 END) AS Matchday_3,
SUM(CASE WHEN stage_id = 4 AND team1_goal > team2_goal THEN 1 ELSE 0 END) AS Matchday_4,
SUM(CASE WHEN stage_id = 5 AND team1_goal > team2_goal THEN 1 ELSE 0 END) AS Matchday_5,
SUM(CASE WHEN stage_id = 6 AND team1_goal > team2_goal THEN 1 ELSE 0 END) AS Matchday_6,
SUM(CASE WHEN stage_id = 7 AND team1_goal > team2_goal THEN 1 ELSE 0 END) AS Matchday_7
FROM scores 
JOIN stages s
ON scores.stage_id = s.id
GROUP BY s.name

--Count the Team1, Team2 and Draws in each Stadium
SELECT v.name AS venue,
COUNT(CASE WHEN team1_goal > team2_goal THEN s.id END) AS team1_wins,
COUNT(CASE WHEN team1_goal < team2_goal THEN s.id END) AS team2_wins,
COUNT(CASE WHEN team1_goal = team2_goal THEN s.id END) AS Draw
FROM scores s
JOIN venues v
ON s.venue_id = v.id
GROUP BY venue

