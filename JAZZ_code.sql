--David Schmieg

--Simple query that finds all songs where the number of bars in the harmonic progression is not a multiple of 4. 
SELECT Song, Bars
FROM SONGS
WHERE MOD(Bars,4) != 0
ORDER BY Song ASC;

--Simple query that returns the ID, first name, last name, sex, and age at death for songwriters who were under the age of 40 when they died
SELECT WriterID, FirstName, LastName, Sex, Died-Born AS Age
FROM WRITERS
WHERE Died-Born<40;

--Join query that returns each work type and the lowest, average, and highest ranking for songs written for that type of work.
SELECT WORKS.WorkType, MIN(SONGS.Ranking) AS Lowest, ROUND(AVG(SONGS.Ranking),1) AS Average, MAX(SONGS.Ranking) AS Highest
FROM WORKS JOIN SONGS
ON WORKS.WorkID = SONGS.WorkID
GROUP BY WorkType;

--Join query that returns the full name and total number of music-writing credits for each Black artist that has more than 5 music-writing credits.
SELECT WRITERS.FirstName ||' '|| WRITERS.MiddleName ||' '|| WRITERS.LastName AS FullName, COUNT(CREDITS.Credit) AS TotalCredits
FROM WRITERS JOIN CREDITS
ON WRITERS.WriterID = CREDITS.WriterID
WHERE WRITERS.Race = 'Black' AND CREDITS.Credit = 'Music'
GROUP BY WRITERS.FirstName ||' '|| WRITERS.MiddleName ||' '|| WRITERS.LastName
HAVING COUNT(CREDITS.Credit) > 5;

--Join query that finds the top 10 most-called songs without lyrics
SELECT SONGS.Song, SONGS.TimeSignature, SONGS.KeySignature, SONGS.Style, SONGS.Calls, TEMP.Song AS Contrafact
FROM SONGS JOIN SONGS TEMP
ON SONGS.ContrafactID = TEMP.SongID
WHERE SONGS.Lyrics IS NULL
ORDER BY SONGS.Calls DESC
FETCH FIRST 10 ROWS ONLY;
