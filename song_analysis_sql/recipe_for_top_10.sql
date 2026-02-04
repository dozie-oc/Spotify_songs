SELECT
  CASE WHEN daily_rank <= 10 THEN 'Top 10' ELSE '11–50' END AS rank_group,
  COUNT(*) AS entries,
  ROUND(AVG(danceability)::numeric, 3)        AS danceability,
  ROUND(AVG(energy)::numeric, 3)              AS energy,
  ROUND(AVG(valence)::numeric, 3)             AS valence,
  ROUND(AVG(tempo)::numeric, 1)               AS tempo,
  ROUND(AVG(loudness)::numeric, 2)            AS loudness,
  ROUND(AVG(acousticness)::numeric, 3)        AS acousticness,
  ROUND(AVG(speechiness)::numeric, 3)         AS speechiness,
  ROUND(AVG(instrumentalness)::numeric, 4)    AS instrumentalness,
  ROUND(100.0 * AVG(CASE WHEN is_explicit THEN 1 ELSE 0 END), 1) AS %_explicit
FROM spotify_songs
GROUP BY CASE WHEN daily_rank <= 10 THEN 'Top 10' ELSE '11–50' END
ORDER BY rank_group DESC;