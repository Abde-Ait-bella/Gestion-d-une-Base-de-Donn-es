```
<?php
require 'vendor/autoload.php'; // Make sure Faker is installed via Composer

use Faker\Factory;

// Configuration de la base de données
$host = 'localhost';
$dbname = 'streaming_db';
$username = 'root';
$password = '';

// Connexion à la base de données MySQL avec MySQLi
$conn = new mysqli($host, $username, $password, $dbname);

// Vérification de la connexion
if ($conn->connect_error) {
    die("Connexion échouée : " . $conn->connect_error);
}

// Nombre de données factices à générer
$numberOfUsers = 10; // Modifier selon le besoin
$numberOfMovies = 5; 
$numberOfWatchHistory = 15; 
$numberOfReviews = 20;

// Initialisation de Faker
$faker = Factory::create();

// Insertion des données factices dans Subscription
$subscriptions = [
    ['Basic', 5.99],
    ['Premium', 11.99],
    ['Family', 19.99]
];

foreach ($subscriptions as $index => $subscription) {
    $subscriptionID = $index + 1;
    $subscriptionType = $subscription[0];
    $monthlyFee = $subscription[1];

    $stmt = $conn->prepare("INSERT IGNORE INTO Subscription (SubscriptionID, SubscriptionType, MonthlyFee) VALUES (?, ?, ?)");
    $stmt->bind_param('isd', $subscriptionID, $subscriptionType, $monthlyFee);
    $stmt->execute();
    $stmt->close();
}

// Générer des utilisateurs factices
// Fetch existing SubscriptionIDs from the database
$subscriptionIDs = [];
$result = $conn->query("SELECT SubscriptionID FROM Subscription");
while ($row = $result->fetch_assoc()) {
    $subscriptionIDs[] = $row['SubscriptionID'];
}

for ($i = 1; $i <= $numberOfUsers; $i++) {
    $firstName = $faker->firstName;
    $lastName = $faker->lastName;
    $email = $faker->unique()->safeEmail;
    $registrationDate = $faker->date;
    $subscriptionID = $subscriptionIDs[array_rand($subscriptionIDs)]; // Pick a random SubscriptionID

    $stmt = $conn->prepare("INSERT INTO User (UserID, FirstName, LastName, Email, RegistrationDate, SubscriptionID) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param('issssi', $i, $firstName, $lastName, $email, $registrationDate, $subscriptionID);
    $stmt->execute();
    $stmt->close();
}

// Générer des films factices
for ($i = 1; $i <= $numberOfMovies; $i++) {
    $title = $faker->sentence(3);
    $genre = $faker->randomElement(['Comedy', 'Horror', 'Romance', 'Science Fiction', 'Documentary']);
    $releaseYear = $faker->year;
    $duration = $faker->numberBetween(80, 180); // Durée entre 80 et 180 minutes
    $rating = $faker->randomElement(['PG', 'PG-13', 'R']);

    $stmt = $conn->prepare("INSERT INTO Movie (MovieID, Title, Genre, ReleaseYear, Duration, Rating) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param('isssis', $i, $title, $genre, $releaseYear, $duration, $rating);
    $stmt->execute();
    $stmt->close();
}

// Générer des historiques de visionnage factices
for ($i = 1; $i <= $numberOfWatchHistory; $i++) {
    $userID = $faker->numberBetween(1, $numberOfUsers);
    $movieID = $faker->numberBetween(1, $numberOfMovies);
    $watchDate = $faker->date;
    $completionPercentage = $faker->numberBetween(0, 100);

    $stmt = $conn->prepare("INSERT INTO WatchHistory (WatchHistoryID, UserID, MovieID, WatchDate, CompletionPercentage) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('iiisi', $i, $userID, $movieID, $watchDate, $completionPercentage);
    $stmt->execute();
    $stmt->close();
}

// Générer des critiques factices
for ($i = 1; $i <= $numberOfReviews; $i++) {
    $userID = $faker->numberBetween(1, $numberOfUsers);
    $movieID = $faker->numberBetween(1, $numberOfMovies);
    $rating = $faker->numberBetween(1, 5);
    $reviewText = $faker->optional()->sentence(10);
    $reviewDate = $faker->date;

    $stmt = $conn->prepare("INSERT INTO Review (ReviewID, UserID, MovieID, Rating, ReviewText, ReviewDate) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param('iiisis', $i, $userID, $movieID, $rating, $reviewText, $reviewDate);
    $stmt->execute();
    $stmt->close();
}

echo "Fake data inserted successfully!";

// Fermer la connexion
$conn->close();
?>

```