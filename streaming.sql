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

-- Afficher les abonnements : Joindre les utilisateurs à leurs types d'abonnements.
SELECT * , S.Subscription_Type FROM user U INNER JOIN subscription S ON U.SubscriptionID = S.SubscriptionID

-- Afficher les abonnements : Joindre les utilisateurs à leurs types d'abonnements.
SELECT * FROM review WHERE ReviewDate < CURRENT_DATE();