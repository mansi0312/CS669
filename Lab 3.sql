CREATE TABLE Genre (
genre_id DECIMAL(12) NOT NULL PRIMARY KEY,
genre_name VARCHAR(64) NOT NULL
);
CREATE TABLE Creator (
creator_id DECIMAL(12) NOT NULL PRIMARY KEY,
first_name VARCHAR(64) NOT NULL,
last_name VARCHAR(64) NOT NULL
);
CREATE TABLE MovieSeries (
movie_series_id DECIMAL(12) NOT NULL PRIMARY KEY,
genre_id DECIMAL(12) NOT NULL,
creator_id DECIMAL(12) NOT NULL,
series_name VARCHAR(255) NOT NULL,
suggested_price DECIMAL(8,2) NULL,
FOREIGN KEY (genre_id) REFERENCES Genre(genre_id),
FOREIGN KEY (creator_id) REFERENCES Creator(creator_id)
);
CREATE TABLE Movie (
movie_id DECIMAL(12) NOT NULL PRIMARY KEY,
movie_series_id DECIMAL(12) NOT NULL,
movie_name VARCHAR(64) NOT NULL,
length_in_minutes DECIMAL(4) NOT NULL,
FOREIGN KEY (movie_series_id) REFERENCES MovieSeries(movie_series_id));

--Genre.
INSERT INTO Genre(genre_id, genre_name)
VALUES(1, 'Fantasy');
INSERT INTO Genre(genre_id, genre_name)
VALUES(2, 'Family Film');
--Creator.
INSERT INTO Creator(creator_id, first_name, last_name)
VALUES(1, 'George', 'Lucas');
INSERT INTO Creator(creator_id, first_name, last_name)
VALUES(2, 'John', 'Lasseter');
INSERT INTO Creator(creator_id, first_name, last_name)
VALUES(3, 'John', 'Tolkien');
INSERT INTO Creator(creator_id, first_name, last_name)
VALUES(4, 'Len', 'Wiseman');
--MovieSeries.
INSERT INTO MovieSeries(movie_series_id, genre_id, creator_id, series_name, suggested_price)
VALUES(101, 1, 1, 'Star Wars', $129.99); --Fantasy, George Lucas
INSERT INTO MovieSeries(movie_series_id, genre_id, creator_id, series_name, suggested_price)
VALUES(102, 2, 2, 'Toy Story', $22.13); --Family Film, John Lesseter
INSERT INTO MovieSeries(movie_series_id, genre_id, creator_id, series_name, suggested_price)
VALUES(103, 1, 3, 'Lord of the rings', null); --Fantasy, John Tolkien
INSERT INTO MovieSeries(movie_series_id, genre_id, creator_id, series_name, suggested_price)
VALUES(104, 1, 4, 'Underworld', $31.49); --Fantasy, Len Wiseman
--Movie
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(1001, 101, 'Episode I: The Phantom Menace', 136); --Movie for Star Wars
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(1002, 101, 'Episode II: Attack of the Clones', 142); --Movie for Star Wars
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(1003, 101, 'Episode III: Revenge of the Sith', 140); --Movie for Star Wars
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(1004, 101, 'Episode IV: A New Hope', 121); --Movie for Star Wars
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(2001, 102, 'Toy Story', 121); --Movie for Toy Story
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(2002, 102, 'Toy Story 2', 135); --Movie for Toy Story
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(2003, 102, 'Toy Story 3', 148); --Movie for Toy Story
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(3001, 103, 'The Lord of the Rings: The Fellowship of the Ring', 228); --Movie for Lord of the Rings
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(3002, 103, 'The Lord of the Rings: The Two Towers', 235); --Movie for Lord of the Rings
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(3003, 103, 'The Lord of the Rings: The Return of the King', 200); --Movie for Lord of the Rings
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(4001, 104, 'Underworld', 121); --Movie for Underworld
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(4002, 104, 'Underworld: Evolution', 106); --Movie for Underworld
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(4003, 104, 'Underworld: Rise of the Lycans', 92); --Movie for Underworld
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(4004, 104, 'Underworld: Awakening', 88); --Movie for Underworld
INSERT INTO Movie(movie_id, movie_series_id, movie_name, length_in_minutes)
VALUES(4005, 104, 'Underworld: Blood Wars', 91); --Movie for Underworld

--Count the number of movies in the table.
SELECT COUNT(*) AS nr_movies
FROM Movie;

--Obtain the least expensive series
SELECT MIN(suggested_price) AS least_expensive
FROM MovieSeries;
--Obtain the most expensive series
SELECT MAX(suggested_price) AS most_expensive
FROM MovieSeries;

--Obtain the names and prices of all movie series with the number of movies in each series
SELECT series_name, suggested_price, COUNT(*) AS nr_movies
FROM MovieSeries
JOIN Movie ON Movie.movie_series_id = MovieSeries.movie_series_id
GROUP BY Movie.movie_series_id, series_name, suggested_price;

--Obtain the genres that have at least 7 associated movies
SELECT genre_name, COUNT(*) AS nr_movies
FROM Genre g, MovieSeries ms, Movie m
WHERE g.genre_id = ms.genre_id and ms.movie_series_id = m.movie_series_id
GROUP BY ms.genre_id, genre_name
HAVING COUNT(*) > 7;

--Show movies that will run for at least 10 hours
SELECT series_name, SUM(length_in_minutes) AS total_hours
FROM MovieSeries
JOIN Movie ON Movie.movie_series_id = MovieSeries.movie_series_id
GROUP BY Movie.movie_series_id, series_name
HAVING SUM(length_in_minutes) >= 600;

--Show the names of all movie series’ creators, as well as the number of “Family Film” movies they have created (even if they created none)
SELECT first_name, last_name, count(CASE WHEN genre_name = 'FAMILY FILM' then genre_name end) AS nr_family_film
FROM Creator
RIGHT JOIN MovieSeries ON MovieSeries.creator_id = Creator.creator_id
JOIN Genre ON Genre.genre_id = MovieSeries.genre_id
JOIN Movie ON Movie.movie_series_id = MovieSeries.movie_series_id
GROUP BY first_name, last_name, genre_name
ORDER BY count(CASE WHEN genre_name = 'FAMILY FILM' then genre_name end) desc;