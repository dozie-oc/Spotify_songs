WITH total_popularity_drop AS (
    SELECT
        name,
        artists,
        MAX(popularity) AS peak_popularity,
        MAX(CASE WHEN snapshot_date = max_date_per_song THEN popularity END) AS final_popularity,
        COUNT(*) AS num_rows
    FROM (
        SELECT 
            *,
            MAX(snapshot_date) OVER (PARTITION BY name, artists) AS max_date_per_song
        FROM spotify_songs
    ) sub
    GROUP BY name, artists, max_date_per_song
    HAVING COUNT(*) >= 100                                  
), 
average_points_drop_per_week AS (
    SELECT
        name,
        artists,
        ROUND(
          (peak_popularity - final_popularity)::numeric 
          / NULLIF(num_rows / 7.0, 0)
        , 2) AS avg_weekly_drop
    FROM total_popularity_drop
)

SELECT
    tpd.name AS track,
    tpd.artists AS artist,
    tpd.peak_popularity,
    tpd.final_popularity,
    (tpd.peak_popularity - tpd.final_popularity) AS total_drop,
    awp.avg_weekly_drop,
    tpd.num_rows AS total_days_charted
FROM total_popularity_drop tpd                  
LEFT JOIN average_points_drop_per_week awp
    ON tpd.name = awp.name AND tpd.artists = awp.artists
ORDER BY awp.avg_weekly_drop;