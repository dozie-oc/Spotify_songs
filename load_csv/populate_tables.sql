DROP TABLE IF EXISTS spotify_songs;

CREATE TABLE spotify_songs (
    spotify_id          TEXT,
    name                TEXT,
    artists             TEXT,
    daily_rank          INTEGER,
    daily_movement      INTEGER,
    weekly_movement     INTEGER,
    country             TEXT,
    snapshot_date       DATE,
    popularity          INTEGER,
    is_explicit         BOOLEAN,
    duration_ms         INTEGER,
    album_name          TEXT,
    album_release_date  DATE,        
    danceability        DOUBLE PRECISION,
    energy              DOUBLE PRECISION,
    key                 INTEGER,
    loudness            DOUBLE PRECISION,
    mode                INTEGER,
    speechiness         DOUBLE PRECISION,
    acousticness        DOUBLE PRECISION,
    instrumentalness    DOUBLE PRECISION,
    liveness            DOUBLE PRECISION,
    valence             DOUBLE PRECISION,
    tempo               DOUBLE PRECISION,
    time_signature      INTEGER
);

COPY spotify_songs FROM 'C:\Users\NEW1\Desktop\Pie\Data_Analysis\Spotify_songs\spotify_really_clean.csv' DELIMITER ',' CSV HEADER;