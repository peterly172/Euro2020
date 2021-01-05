-- Number of matches in Euro 2020
SELECT COUNT(id) AS total_matches
FROM scores

-- Number of matches taken place each stadium
SELECT v.name, COUNT(*) AS matches
FROM scores
JOIN venues AS v
ON scores.venue_id = v.id
GROUP BY v.name
ORDER BY matches DESC

--  Number of matches per stage
SELECT stages.name, COUNT(*) AS matches
FROM scores
JOIN stages 
ON scores.stage_id = stages.id
GROUP BY stages.name
ORDER BY matches DESC, stages.name

--What times do England play and how many times?
SELECT time_bst, COUNT(*)
FROM match
WHERE team1_id = 3
OR team2_id = 3
GROUP BY time_bst
ORDER BY COUNT(*)

-- Number of goals scored in Euro 2020
SELECT SUM(team1_goal + team2_goal)
FROM scores

--  Number of goals scored in each round
SELECT stages.name, SUM(team1_goal + team2_goal) AS total_goals
FROM scores
JOIN stages
ON scores.stage_id = stages.id
GROUP BY stages.name 
ORDER BY total_goals DESC, stages.name

--Number of goals scored in each stadium
SELECT venues.name, SUM(team1_goal + team2_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
GROUP BY venues.name 
ORDER BY total_goals DESC

--Number of goals scored in each stadium capacity of < 55000
SELECT venues.name, SUM(team1_goal + team2_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
WHERE capacity BETWEEN 30000 AND 55000
GROUP BY venues.name 
ORDER BY total_goals DESC

--Number of goals scored in each stadium capacity of > 55000
SELECT venues.name, SUM(team1_goal + team2_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
WHERE capacity BETWEEN 55001 AND 90000
GROUP BY venues.name 
ORDER BY total_goals DESC

-- Maximum number of goals scored in a single match in Euro 2020
SELECT MAX(team1_goal + team2_goal) FROM scores

--Maximum number of goals scored in a match per round
SELECT stages.name, MAX(team1_goal + team2_goal) AS max_goals
FROM scores
JOIN stages 
ON scores.venue_id = stages.id
GROUP BY stages.name
ORDER BY max_goals DESC, stages.name

--Maximum number of goals scored in a match per stadium
SELECT venues.name, MAX(team1_goal + team2_goal) AS max_goals
FROM scores
JOIN venues 
ON scores.venue_id = venues.id
GROUP BY venues.name
ORDER BY max_goals DESC

-- List of matches in full
SELECT m.id, date, time_bst, s.name AS Round, v.name AS Venue, t1.name AS TeamA, t2.name AS TeamB
FROM match AS m
JOIN stages AS s
ON m.stage_id = s.id
JOIN venues AS v
ON m.venue_id = v.id
JOIN teams AS t1
ON m.team1_id = t1.id
JOIN teams AS t2
ON m.team2_id = t2.id
ORDER BY m.id

-- List of scores in full
SELECT m.id, s.name AS Round, v.name AS Venue, t1.name AS TeamA, t2.name AS TeamB, team1_goal, team2_goal
FROM scores AS m
JOIN stages AS s
ON m.stage_id = s.id
JOIN venues AS v
ON m.venue_id = v.id
JOIN teams AS t1
ON m.team1_id = t1.id
JOIN teams AS t2
ON m.team2_id = t2.id
ORDER BY m.id

