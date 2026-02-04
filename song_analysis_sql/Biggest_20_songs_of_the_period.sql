WITH daily_with_points AS (
  SELECT 
    *,
    (51 - daily_rank) AS chart_points          
  FROM spotify_songs                         
),

days_at_number_one AS (
  SELECT
    name,
    artists,
    COUNT(*) AS days_at_number_one
  FROM spotify_songs
  WHERE daily_rank = 1
  GROUP BY name, artists
)

SELECT
  d.name AS track,
  d.artists,
  MIN(d.daily_rank) AS peak_position,                    
  COUNT(*) AS total_days_on_chart,
  SUM(d.chart_points) AS total_chart_points,             
  COALESCE(n.days_at_number_one, 0) AS days_at_number_one,
  ROUND(AVG(d.popularity), 1) AS avg_popularity,
  COUNT(DISTINCT d.country) AS countries_reached
FROM daily_with_points d
LEFT JOIN days_at_number_one n
  ON d.name = n.name AND d.artists = n.artists         
GROUP BY d.name, d.artists, n.days_at_number_one
ORDER BY total_chart_points DESC
LIMIT 20;