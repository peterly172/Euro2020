CREATE PROCEDURE Matchlist
AS
BEGIN
SELECT m.id, date, time_bst, s.name AS stage, v.name AS venue, t1.name AS team1, t2.name AS team2
FROM match AS m
LEFT JOIN stages AS s
ON m.stage_id = s.id
LEFT JOIN venues AS v
ON m.venue_id = v.id
LEFT JOIN teams AS t1
ON m.team1_id = t1.id
LEFT JOIN teams AS t2
ON m.team2_id = t2.id
ORDER BY m.id
END

CREATE PROCEDURE Scoreslist
AS
BEGIN
SELECT sc.id, st.name AS stage, v.name AS venue, t1.name AS team1, t2.name AS team2, team1_goal, team2_goal
FROM scores AS sc
LEFT JOIN stages AS st
ON sc.stage_id = st.id
LEFT JOIN venues AS v
ON sc.venue_id = v.id
LEFT JOIN teams AS t1
ON sc.team1_id = t1.id
LEFT JOIN teams AS t2
ON sc.team2_id = t2.id
ORDER BY sc.id
END
