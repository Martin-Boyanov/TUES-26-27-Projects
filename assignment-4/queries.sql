-- Question 1: All matches of a given team (here: 11B), ordered by date.
-- Returns: date, home team, score, away team.
-- A match that is not played yet shows 'not played' instead of a score.
SELECT m.match_date AS date,
       h.name       AS home_team,
       CASE WHEN m.home_goals IS NULL THEN 'not played'
            ELSE m.home_goals || ' : ' || m.away_goals
       END          AS score,
       a.name       AS away_team
FROM matches m
JOIN teams h ON h.id = m.home_team_id
JOIN teams a ON a.id = m.away_team_id
WHERE h.name = '11B' OR a.name = '11B'
ORDER BY m.match_date;

-- Question 2: The standings.
-- Returns: team, matches played, points, goals scored, goals conceded (+ goal difference).
-- Win = 3, draw = 1, loss = 0. Ordered by points, then by goal difference.
-- Only played matches count (score IS NOT NULL). Every match is counted twice:
-- once from the home team's side and once from the away team's side.
WITH results AS (
    SELECT home_team_id AS team_id, home_goals AS gf, away_goals AS ga
    FROM matches WHERE home_goals IS NOT NULL
    UNION ALL
    SELECT away_team_id AS team_id, away_goals AS gf, home_goals AS ga
    FROM matches WHERE home_goals IS NOT NULL
)
SELECT t.name                                   AS team,
       COUNT(r.team_id)                         AS played,
       COALESCE(SUM(CASE WHEN r.gf > r.ga THEN 3
                         WHEN r.gf = r.ga THEN 1
                         ELSE 0 END), 0)        AS points,
       COALESCE(SUM(r.gf), 0)                   AS goals_scored,
       COALESCE(SUM(r.ga), 0)                   AS goals_conceded,
       COALESCE(SUM(r.gf - r.ga), 0)            AS goal_difference
FROM teams t
LEFT JOIN results r ON r.team_id = t.id
GROUP BY t.id, t.name
ORDER BY points DESC, goal_difference DESC, t.name;
