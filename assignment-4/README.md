# Assignment 4 – Inter-class Tournament

## Decisions I made and why

I used two tables, `teams` and `matches`, and every match points to `teams` twice with foreign keys (`home_team_id` and `away_team_id`), so a match is always between exactly two real teams and the same two teams can play again just by adding a new row.
A match that is not played yet has `NULL` in `home_goals` and `away_goals`, not 0:0, because 0:0 would be a real draw and would wrongly count in the standings.
CHECK constraints stop a team from playing against itself, stop negative goals, and stop a match from having only one of the two scores filled in.
Team names are `UNIQUE`, so a query that looks for a team by name (like `'11B'`) can never mix up two different teams.
I do not store points, standings, the winner or the goal difference, because they can all be calculated from the scores with a query, and if I stored them they could get out of sync with the real results.
