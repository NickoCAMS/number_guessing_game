#!/bin/bash

# Database name and PSQL command for querying the database
DB_NAME="number_guess"
PSQL="psql --username=freecodecamp --dbname=$DB_NAME -t --no-align -c"

# Function to check if the input is an integer
is_integer() {
  # Using regex to check if the input consists of only digits
  [[ "$1" =~ ^[0-9]+$ ]]
}

# Function to create a new user in the database with initial values for games_played and best_game
create_user() {
  # Insert a new record for the user into the scores table with 0 games played and best game as 0
  $PSQL "INSERT INTO scores (username, games_played, best_game) VALUES ('$1', 0, 0);"
}

# Prompt the user to enter their username
echo "Enter your username:"
read USERNAME

# Retrieve user data from the database (username, games played, best game)
USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM scores WHERE username = '$USERNAME'")

# Check if the user already exists in the database
if [[ -z $USER_INFO ]]; then
  # If user does not exist, greet them and create a new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  create_user "$USERNAME"
else
  # If user exists, extract their username, games played, and best game data
  USERNAME_DB=$(echo "$USER_INFO" | cut -d '|' -f 1)
  GAMES_PLAYED=$(echo "$USER_INFO" | cut -d '|' -f 2)
  BEST_GAME=$(echo "$USER_INFO" | cut -d '|' -f 3)
  # Greet the returning user with their stats
  echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate a random secret number between 1 and 1000
SECRET_NUMBER=$((RANDOM % 1000 + 1))

# Initialize the number of guesses counter
NUM_GUESSES=0

# Prompt the user to guess the secret number
echo "Guess the secret number between 1 and 1000:"
while true; do
  # Read the user's guess
  read GUESS
  
  # Check if the guess is a valid integer
  if ! is_integer "$GUESS"; then
    echo "That is not an integer, guess again:"  # Prompt again if the input is not an integer
    continue
  fi
  
  # Increment the number of guesses
  NUM_GUESSES=$((NUM_GUESSES + 1))
  
  # Check if the guess is correct
  if [[ "$GUESS" -eq "$SECRET_NUMBER" ]]; then
    # If the guess is correct, congratulate the user and display the number of tries
    echo "You guessed it in $NUM_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    
    # Update the games played and best game in the database
    GAMES_PLAYED=$((GAMES_PLAYED + 1))
    if [[ $NUM_GUESSES -lt $BEST_GAME ]] || [[ $BEST_GAME -eq 0 ]]; then
      BEST_GAME=$NUM_GUESSES  # Update best game if current game has fewer guesses
    fi
    
    # Update the database with the new game statistics
    $PSQL "UPDATE scores SET games_played = $GAMES_PLAYED, best_game = $BEST_GAME WHERE username = '$USERNAME'"
    
    break  # Exit the loop after the correct guess
  elif [[ "$GUESS" -gt "$SECRET_NUMBER" ]]; then
    # If the guess is too high, prompt the user to guess lower
    echo "It's lower than that, guess again:"
  else
    # If the guess is too low, prompt the user to guess higher
    echo "It's higher than that, guess again:"
  fi
done
