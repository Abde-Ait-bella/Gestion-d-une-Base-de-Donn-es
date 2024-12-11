--Name : abdessamad ait-bella
--Email : abdessamadaitbella1998@gmail.com

-- Creation de base de donner
CREATE DATABASE streaming_db;

-- Sélectionnez la base de données
USE streaming_db;

-- Creation de tableau Subscription
CREATE TABLE Subscription(
	id INT AUTO_INCREMENT PRIMARY KEY,
    Subscription_Type VARCHAR(50),
    MonthlyFee DECIMAL(10,2)
)

-- Modifier la colonne de tableau Subscription
ALTER TABLE subscription
RENAME COLUMN id to SubscriptionID;

-- Modifier la colonne de tableau Subscription
ALTER TABLE Subscription 
RENAME COLUMN Subscription_Type TO SubscriptionType;

-- Modifier le type de colonne de tableau Subscription
ALTER TABLE subscription MODIFY COLUMN SubscriptionType VARCHAR(50) CHECK (SubscriptionType IN ('Basic', 'Premium'));

-- Creation de tableau user
CREATE TABLE user ( UserID INT AUTO_INCREMENT PRIMARY KEY, FirstName VARCHAR(100), LastName VARCHAR(100), Email VARCHAR(100) UNIQUE, RegistrationDate DATE, SubscriptionID INT, FOREIGN KEY (SubscriptionID) REFERENCES subscription(SubscriptionID) );

-- Creation de tableau review
CREATE TABLE review ( ReviewID INT AUTO_INCREMENT PRIMARY KEY, UserID INT, MovieID INT, Rating INT, ReviewText TEXT, ReviewDate DATE, FOREIGN KEY (UserID) REFERENCES user(UserID) );

-- Creation de tableau watchhistory
CREATE TABLE watchhistory ( WatchHistoryID INT AUTO_INCREMENT PRIMARY KEY, UserID INT, MovieID INT, Rating INT, WatchDate DATE, CompletionPercentage INT, FOREIGN KEY (UserID) REFERENCES user(UserID) );

-- Modifier la colonne de tableau movie
CREATE TABLE movie ( MovieID INT AUTO_INCREMENT PRIMARY KEY, Title VARCHAR(225), Genre VARCHAR(100), ReleaseYear INT, Duration INT, Rating VARCHAR(10) );

-- Renemer de colonne de tableau Subscription
ALTER TABLE subscription RENAME COLUMN MinthlyFee TO MonthlyFee;

-- Modifier colonne rating
ALTER TABLE movie MODIFY COLUMN 
Rating DECIMAL(10,2),
ADD CONSTRAINT chk_rating CHECK (Rating BETWEEN 0 AND 5);

ALTER TABLE

-- Ajouter constraint FOREIGN KEY
ALTER TABLE review ADD CONSTRAINT fk_user_review 
FOREIGN KEY (UserID) REFERENCES user(UserID);

ALTER TABLE review ADD CONSTRAINT fk_movie_review 
FOREIGN KEY (MovieID) REFERENCES movie(MovieID);

ALTER TABLE watchhistory ADD CONSTRAINT fk_warchhistory_movie 
FOREIGN KEY (MovieID) REFERENCES movie(MovieID);

-- jouter un nouveau film
INSERT INTO movie (Title, Genre) VALUES ('Data Science Adventures', 'Documentary');

-- Rechercher des films : Lister tous les films du genre "Comedy" sortis après 2020
SELECT * FROM movie WHERE genre = "Comedy" AND ReleaseYear > 2020;

-- Mise à jour des abonnements : Passer tous les utilisateurs de "Basic" à "Premium"..
UPDATE user SET SubscriptionID = 
CASE
	WHEN  1 THEN 2
    ELSE  2
END;

-- Afficher les abonnements : Joindre les utilisateurs à leurs types d'abonnements.
SELECT * , S.Subscription_Type FROM user U INNER JOIN subscription S ON U.SubscriptionID = S.SubscriptionID

-- Filtrer les visionnages : Trouver tous les utilisateurs ayant terminé de regarder un film.

SELECT U.firstName, U.LastName, W.CompletionPercentage,
CASE
	WHEN W.CompletionPercentage < 100 THEN 'Watching' ELSE 'Watched' 
END AS Status
FROM user U INNER JOIN watchhistory W ON U.UserID = W.UserID WHERE W.CompletionPercentage = 100;

-- Trier et limiter : Afficher les 5 films les plus longs, triés par durée.
SELECT * FROM movie ORDER BY Duration DESC LIMIT 5;

-- Agrégation : Calculer le pourcentage moyen de complétion pour chaque film.
SELECT
    movie.Title,
    AVG(watchhistory.CompletionPercentage)
FROM 
    movie
INNER JOIN 
    watchhistory
ON 
    movie.MovieID = watchhistory.MovieID
GROUP BY watchhistory.MovieID

-- Group By : Grouper les utilisateurs par type d’abonnement et compter le nombre total d’utilisateurs par groupe.
SELECT
COUNT(U.firstName) , S.SubscriptionType 
FROM user U INNER JOIN
subscription S 
ON 
U.SubscriptionID = S.SubscriptionID
GROUP BY
U.SubscriptionID;

-- Sous-requête (Bonus): Trouver les films ayant une note moyenne supérieure à 4.
SELECT * FROM movie WHERE  MovieID IN (SELECT MovieID FROM review WHERE rating = 4);

--Self-Join (Bonus): Trouver des paires de films du même genre sortis la même année.
SELECT M1.Title, M2.Title, M2.Genre, M2.ReleaseYear FROM movie M1 JOIN movie M2 ON M1.MovieID != M2.MovieID WHERE M1.Genre = M2.Genre AND M1.ReleaseYear = M2.ReleaseYear;

-- CTE (Bonus): Lister les 3 films les mieux notés grâce à une expression de table commune.
WITH MovieIDS AS 
(SELECT * FROM review ORDER BY Rating DESC LIMIT 3)

SELECT * FROM movie 
WHERE MovieID IN (SELECT MovieID FROM MovieIDS);
