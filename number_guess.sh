#!/bin/bash

# Variabili di connessione al database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Funzione per creare un nuovo utente nel database
create_user() {
    local username=$1
    local number_to_guess=$2
    $PSQL "INSERT INTO scores (username, guesses, number_to_guess, games_played, best_game) VALUES ('$username', 0, $number_to_guess, 1, 0);"
}

# Funzione per aggiornare il numero di tentativi e il miglior gioco
update_guesses() {
    local username=$1
    local guesses=$2
    local best_game=$3
    $PSQL "UPDATE scores SET guesses = $guesses, best_game = $best_game WHERE username = '$username';"
}

# Funzione per incrementare il numero di giochi giocati
increment_games_played() {
    local username=$1
    $PSQL "UPDATE scores SET games_played = games_played + 1 WHERE username = '$username';"
}

# Funzione per ottenere informazioni sull'utente
get_user_info() {
    local username=$1
    $PSQL "SELECT games_played, best_game FROM scores WHERE username = '$username';"
}

# Funzione per ottenere il numero da indovinare
get_number_to_guess() {
    local username=$1
    $PSQL "SELECT number_to_guess FROM scores WHERE username = '$username';"
}

# Chiedi il nome utente
echo "Enter your username:"
read username

# Verifica se l'utente esiste nel database
existing_user=$($PSQL "SELECT username FROM scores WHERE username = '$username';")

if [[ -z $existing_user ]]
then
    # Se l'utente non esiste, generiamo un numero casuale e creiamo un nuovo utente
    number_to_guess=$(( RANDOM % 1000 + 1 ))
    create_user $username $number_to_guess
    echo "Welcome, $username! It looks like this is your first time here."
else
    # Se l'utente esiste, prendi il numero di giochi giocati e il punteggio migliore
    user_info=$(get_user_info $username)
    games_played=$(echo $user_info | cut -d'|' -f1)
    best_game=$(echo $user_info | cut -d'|' -f2)

    echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

# Imposta il numero segreto per il gioco
number_to_guess=$(( RANDOM % 1000 + 1 ))  # Il numero da indovinare è sempre casuale
correct_guess=0
guesses=0

echo "Guess the secret number between 1 and 1000:"

# Gioco di indovinare il numero
while [[ $correct_guess -eq 0 ]]
do
    read guess
    
    # Verifica se l'input è un intero
    if ! [[ "$guess" =~ ^[0-9]+$ ]]
    then
        echo "That is not an integer, guess again:"
    else
        ((guesses++))

        # Controlla se il numero è giusto
        if [[ $guess -lt $number_to_guess ]]
        then
            echo "It's higher than that, guess again:"
        elif [[ $guess -gt $number_to_guess ]]
        then
            echo "It's lower than that, guess again:"
        else
            echo "You guessed it in $guesses tries. The secret number was $number_to_guess. Nice job!"
            correct_guess=1

            # Aggiorna il numero di giochi giocati e il miglior gioco
            if [[ $games_played -gt 0 && ($best_game -eq 0 || $guesses -lt $best_game) ]]
            then
                best_game=$guesses
            fi
            increment_games_played $username
            update_guesses $username $guesses $best_game
        fi
    fi
done
