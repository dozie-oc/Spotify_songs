-- Step 1: Get the true Top 12 biggest songs
WITH top_songs AS (
  SELECT DISTINCT
    name,
    artists
  FROM (
    SELECT 
      name,
      artists,
      SUM(51 - daily_rank) AS total_points
    FROM spotify_songs
    GROUP BY name, artists
    ORDER BY total_points DESC
    LIMIT 12
  )
),

-- Step 2: Pull every single appearance of these 12 songs, ordered by date
life_cycle_raw AS (
  SELECT
    t.name,
    t.artists,
    s.snapshot_date,
    s.daily_rank,
    s.popularity,
    (51 - s.daily_rank) AS chart_points_that_day,
    -- For cleaner charts: week number since first appearance
    DENSE_RANK() OVER (PARTITION BY t.name, t.artists ORDER BY s.snapshot_date) AS week_number
  FROM spotify_songs s
  INNER JOIN top_songs t
    ON s.name = t.name AND s.artists = t.artists
),

-- Step 3: Final clean output 
final_life_cycle AS (
  SELECT
    name || ' - ' || artists AS track,
    snapshot_date,
    week_number,
    daily_rank,
    popularity,
    chart_points_that_day,
    (51 - daily_rank) AS rank_score
  FROM life_cycle_raw
  ORDER BY name, artists, snapshot_date
)

SELECT *
FROM final_life_cycle
ORDER BY track, snapshot_date;