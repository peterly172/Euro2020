--Teams who scored 3 or more goals as Team 1
SELECT t.name
FROM teams t
WHERE t.id IN (SELECT team1_id FROM scores WHERE team1_goal >= 3)

--Teams who scored 2 or more goals as Team 2
SELECT t.name
FROM teams t
WHERE t.id IN (SELECT team2_id FROM scores WHERE team1_goal >= 3)

--Matches where 5 or more goals were score in a match
SELECT date, team1_goal, team2_goal
FROM
(SELECT date, s.name, team1_goal, team2_goal, (team1_goal + team2_goal) AS total_goals
FROM scores
JOIN match m
ON scores.id = m.id
JOIN stages s
ON scores.stage_id = s.id) AS subq
WHERE total_goals >= 5

--Average total of goals per day vs. Overall AVG
SELECT s.name AS stages,
ROUND(AVG(team1_goal + team2_goal), 2) AS avg_goals,
(SELECT ROUND(AVG(team1_goal + team2_goal), 2)
FROM scores) AS Overall_avg
	  FROM scores
	  JOIN match AS m
	  ON scores.id = m.id
	  JOIN stages s
	  ON scores.stage_id = s.id
	  GROUP BY date, s.name
	  ORDER BY date

--Average total of goals per stage vs Overall AVG
SELECT s.name AS stages,
ROUND(AVG(team1_goal + team2_goal), 2) AS avg_goals,
(SELECT ROUND(AVG(team1_goal + team2_goal), 2)
FROM scores) AS Overall_avg
	  FROM scores
	  LEFT JOIN match AS m
	  ON scores.id = m.id
	  JOIN stages s
	  ON scores.stage_id = s.id
	  GROUP BY s.name

--Average total of goals per stage vs difference of overall AVG
SELECT s.name AS stages,
ROUND(AVG(team1_goal + team2_goal), 2) AS avg_goals,
ROUND(AVG(team1_goal + team2_goal) - 
	 (SELECT AVG(team1_goal + team2_goal)
	  FROM scores), 2) AS diff
 FROM scores
	  LEFT JOIN match AS m
	  ON scores.id = m.id
	  JOIN stages s
	  ON scores.stage_id = s.id
	  GROUP BY s.name

--Stages where average goals > Overall AVG + Overall AVG
SELECT 
s.stage_id, ROUND(s.avg_goals, 2) AS AVG_goals,
(SELECT AVG(team1_goal + team2_goal) FROM scores) AS overall_AVG
FROM
(SELECT stage_id, AVG(team1_goal + team2_goal) AS avg_goals
FROM scores
GROUP BY stage_id) AS s
WHERE s.avg_goals > (SELECT AVG(team1_goal + team2_goal)
					FROM scores)

--Correlated subquery (matches where goals > twice the AVG
SELECT
main.stage_id,
main.team1_goal,
main.team2_goal
FROM scores AS main
WHERE
(team1_goal + team2_goal) >
(SELECT AVG((sub.team1_goal + sub.team2_goal) * 2)
FROM scores AS sub
WHERE main.stage_id = sub.stage_id)

--Scores equal Max number of goals in a match
SELECT 
main.id,
main.stage_id,
main.venue_id,
main.team1_goal,
main.team2_goal
FROM scores AS main
WHERE(team1_goal + team2_goal) =
(SELECT MAX(sub.team1_goal + sub.team2_goal)
FROM scores AS sub)

--Scores equal Min number of goals in a match
SELECT 
main.id,
main.stage_id,
main.venue_id,
main.team1_goal,
main.team2_goal
FROM scores AS main
WHERE(team1_goal + team2_goal) =
(SELECT MIN(sub.team1_goal + sub.team2_goal)
FROM scores AS sub)

--Comparing Max goals
SELECT st.name, MAX(team1_goal + team2_goal) AS max_goals,
(SELECT MAX(team1_goal + team2_goal) FROM scores) AS overall_max,
(SELECT MAX (team1_goal + team2_goal) 
FROM scores
WHERE id IN (SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 06)) AS june_max_goals
FROM scores sc
JOIN stages AS st
ON sc.stage_id = st.id
GROUP BY st.name

--Matches where team1 or team 2 score 2 or more goals
SELECT id, stage_id, venue_id
FROM scores
WHERE team1_goal >= 2 OR team2_goal >= 2

--Which stage and venue did those matches take place with > 2 goals?
SELECT
s.name AS stage, v.name AS venue, COUNT(subquery.id) AS matches
FROM (
SELECT stage_id, venue_id, id
FROM scores
WHERE team1_goal >= 2 OR team2_goal >= 2) AS subquery
JOIN stages s
ON s.id = subquery.stage_id
JOIN venues v
ON v.id = subquery.venue_id
GROUP BY s.name, v.name	  

--Which venue did those matches take place with > 2 goals?
SELECT
v.name AS venue, COUNT(subquery.id) AS matches
FROM (
SELECT stage_id, venue_id, id
FROM scores
WHERE team1_goal >= 2 OR team2_goal >= 2) AS subquery
JOIN venues v
ON v.id = subquery.venue_id
GROUP BY v.name
ORDER BY matches DESC

--Full scoresheet using a Subquery
SELECT m.date, team1, team2, team1_goal, team2_goal 
FROM scores s
JOIN match m
ON s.id = m.id
LEFT JOIN (
SELECT match.id, t.name AS team1
FROM match
JOIN teams t
ON match.team1_id = t.id) AS team1
ON team1.id = s.id
LEFT JOIN (
SELECT match.id, t.name AS team2
FROM match
JOIN teams t
ON match.team2_id = t.id) AS team2
ON team2.id = s.id
ORDER BY date

--Full scoresheet using a correlated subquery
SELECT m.date, team1, team2, team1_goal, team2_goal 
FROM scores s
JOIN match m
ON s.id = m.id
LEFT JOIN (
SELECT match.id, t.name AS team1
FROM match
JOIN teams t
ON match.team1_id = t.id) AS team1
ON team1.id = s.id
LEFT JOIN (
SELECT match.id, t.name AS team2
FROM match
JOIN teams t
ON match.team2_id = t.id) AS team2
ON team2.id = s.id
ORDER BY date

