CREATE TABLE teams (
id SERIAL NOT NULL PRIMARY KEY,
team_short_name VARCHAR(3),
name VARCHAR(100),
match_group VARCHAR(1)
);

CREATE TABLE venues (
id SERIAL NOT NULL PRIMARY KEY,
name VARCHAR(50),
city VARCHAR (50),
capacity INT
);

CREATE TABLE match (
id INT NOT NULL PRIMARY KEY,
date DATE,
time_bst TIME,
stage_id INT,
venue_id INT,
team1_id INT,
team2_id INT
);

CREATE TABLE scores (
id INT NOT NULL PRIMARY KEY,
stage_id INT,
venue_id INT,
team1_id INT,
team2_id INT,
team1_goal INT,
team2_goal INT,
notes VARCHAR(100)
);

CREATE TABLE stages (
id SERIAL NOT NULL PRIMARY KEY,
name VARCHAR(15),
start_date DATE,
end_date DATE
) ;
