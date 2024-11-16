#!/bin/bash

DB_NAME="number_guess"
PSQL="psql --username=freecodecamp --dbname=$DB_NAME -t --no-align -c"

is_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

create_user() {
  $PSQL "INSERT INTO scores (username, games_played, best_game) VALUES ('$1', 0, 0);"
}

echo "Enter your username:"
read USERNAME

USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM scores WHERE username = '$USERNAME'")

if [[ -z $USER_INFO ]]; then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  create_user "$USERNAME"
else
  USERNAME_DB=$(echo "$USER_INFO" | cut -d '|' -f 1)
  GAMES_PLAYED=$(echo "$USER_INFO" | cut -d '|' -f 2)
  BEST_GAME=$(echo "$USER_INFO" | cut -d '|' -f 3)
  echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$((RANDOM % 1000 + 1))
NUM_GUESSES=0

echo "Guess the secret number between 1 and 1000:"
while true; do
  read GUESS
  
  if ! is_integer "$GUESS"; then
    echo "That is not an integer, guess again:"
    continue
  fi
  
  NUM_GUESSES=$((NUM_GUESSES + 1))
  
  if [[ "$GUESS" -eq "$SECRET_NUMBER" ]]; then
    echo "You guessed it in $NUM_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    
    GAMES_PLAYED=$((GAMES_PLAYED + 1))
    if [[ $NUM_GUESSES -lt $BEST_GAME ]] || [[ $BEST_GAME -eq 0 ]]; then
      BEST_GAME=$NUM_GUESSES
    fi
    
    $PSQL "UPDATE scores SET games_played = $GAMES_PLAYED, best_game = $BEST_GAME WHERE username = '$USERNAME'"
    
    break
  elif [[ "$GUESS" -gt "$SECRET_NUMBER" ]]; then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done
