--sql-

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT COUNT(*) FROM spotify;
SELECT COUNT(DISTINCT artist) FROM spotify;
track
SELECT COUNT(DISTINCT track) FROM spotify;
SELECT COUNT(DISTINCT album) FROM spotify;

SELECT COUNT(DISTINCT album_type) FROM spotify;
SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;
SELECT DISTINCT most_played_on FROM spotify;
SELECT COUNT(*) FROM spotify;


SELECT * FROM  spotify
WHERE duration_min = 0



DELETE FROM spotify
WHERE duration_min = 0


SELECT DISTINCT channel FROM spotify;

---Retrieve the names of all tracks that have more than 1 billion streams.

SELECT track
FROM spotify
WHERE stream > 1000000000;

---List all albums along with their respective artists.

SELECT DISTINCT album, artist
FROM spotify
order by 1

--Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) as totalcomments
FROM spotify
WHERE licensed = 'true'

--Find all tracks that belong to the album type single.

SELECT track FROM spotify
WHERE album_type = 'single'

--Count the total number of tracks by each artist.

SELECT artist,COUNT(track) as totaltracks
FROM spotify
group by artist
order by 2 asc

--Calculate the average danceability of tracks in each album.

SELECT distinct album, AVG(danceability) as average
FROM spotify
GROUP BY album
ORDER BY 2 DESC



--Find the top 5 tracks with the highest energy values.
SELECT track, MAX(energy) as maximumenergy FROM spotify
group by track 
order by 2 desc
LIMIT 5


--List all tracks along with their views and likes where official_video = TRUE.

SELECT track, 
       SUM(views) as total_views, 
	   SUM(likes) as total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY track 
ORDER BY 2 desc




--For each album, calculate the total views of all associated tracks.
SELECT album,track, SUM(views) as total_views FROM spotify
GROUP BY album, 2
order by 3 desc






--Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * from
(SELECT track,
      COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as stream_youtube,
	  COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as stream_spotify
FROM spotify 
GROUP by track
ORDER BY 2,3
) as t1
WHERE stream_spotify > stream_youtube
AND 
stream_youtube <> 0


Find the top 3 most-viewed tracks for each artist using window functions.

SELECT artist,
       track,
	   SUM(views) as totalviews, 
	   DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY 1,2
ORDER BY 2,3 desc





-- Write a query to find tracks where the liveness score is above the average.

SELECT track FROM spotify WHERE liveness > (SELECT AVG(liveness) FROM spotify)


--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in eachalbum.

WITH cte
AS
(
SELECT album, MAX(energy) as high_energy, MIN(energy) as low_energy
FROM spotify
GROUP BY 1
)
SELECT album, high_energy-low_energy as energydiff
FROM cte


Find tracks where the energy-to-liveness ratio is greater than 1.2.
Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.