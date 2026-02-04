WITH number_one_days AS (
  SELECT
    name,
    artists,
    is_explicit,
    COUNT(*) AS days_at_number_one
  FROM spotify_songs
  WHERE daily_rank = 1
  GROUP BY name, artists, is_explicit
),

deduped AS (
  SELECT
    name,
    artists,
    is_explicit AS dominant_is_explicit
  FROM (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY name, artists 
             ORDER BY days_at_number_one DESC,
                      is_explicit DESC
           ) AS rn
    FROM number_one_days
  ) ranked
  WHERE rn = 1
)

-- Final result – clean and accurate
SELECT
  CASE WHEN dominant_is_explicit THEN 'Explicit' ELSE 'Clean' END AS version,
  COUNT(*) AS unique_songs_that_reached_1,
  ROUND(AVG(s.popularity), 2) AS avg_current_popularity,
  ROUND(AVG(s.daily_rank), 2) AS avg_daily_rank
FROM deduped d
JOIN spotify_songs s 
  ON d.name = s.name AND d.artists = s.artists
GROUP BY dominant_is_explicit
ORDER BY unique_songs_that_reached_1 DESC;