#!/bin/bash

# PSQL connection string for querying the database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Function to create a new game
create_game() {
    # Ask for the username and verify the length
    while true; do
        echo "Enter your username:"
        read username

        # Check if the username is valid (max 22 characters)
        if [ ${#username} -le 22 ]; then
            break
        else
            echo "Username is too long. Please enter a username with 22 characters or fewer."
        fi
    done

    # Query the database for the number of games played and the best score (fewest guesses)
    user_info=$($PSQL "SELECT COUNT(*), MIN(guesses) FROM games WHERE username = '$username'")

    # Extract the data from the query result
    count=$(echo $user_info | cut -d '|' -f 1)
    best_game=$(echo $user_info | cut -d '|' -f 2)

    # If 'count' or 'best_game' is empty or NULL, set them to 0
    if [[ -z "$count" ]] || [[ "$count" == "NULL" ]]; then
        count=0
    fi

    if [[ -z "$best_game" ]] || [[ "$best_game" == "NULL" ]]; then
        best_game=0
    fi

    # If the user does not exist in the database, greet them and insert their first game with 0 guesses
    if [ "$count" -eq 0 ]; then
        echo "Welcome, $username! It looks like this is your first time here."
    else
        # If the user exists, greet them and show the number of games played and the best score
        echo "Welcome back, $username! You have played $count games, and your best game took $best_game guesses."
    fi

    # Generate a random number between 1 and 1000
    number_to_guess=$(( RANDOM % 1000 + 1 ))

    # Start the game
    play_game "$username" "$number_to_guess"
}

# Function to play the game
play_game() {
    username=$1
    number_to_guess=$2
    attempts=0
    correct=0

    # Prompt the user to guess the secret number
    echo "Guess the secret number between 1 and 1000:"

    # Loop until the correct guess is made
    while [ $correct -eq 0 ]; do
        read guess

        # Verify if the input is a valid integer
        if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
            echo "That is not an integer, guess again:"
            continue
        fi

        # Increment the number of attempts
        attempts=$(( attempts + 1 ))

        # Check if the guessed number is correct
        if [ $guess -eq $number_to_guess ]; then
            echo "You guessed it in $attempts tries. The secret number was $number_to_guess. Nice job!"
            correct=1
            # Insert the number of attempts into the database after the game
            $PSQL "INSERT INTO games (username, guesses) VALUES ('$username', $attempts)"
        elif [ $guess -lt $number_to_guess ]; then
            # If the guess is lower than the secret number, prompt for a higher guess
            echo "It's higher than that, guess again:"
        else
            # If the guess is higher than the secret number, prompt for a lower guess
            echo "It's lower than that, guess again:"
        fi
    done
}

# Start a new game
create_game
