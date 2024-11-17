#!/bin/bash

# PSQL connection string for querying the database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Funzione per creare un nuovo gioco
create_game() {
    # Chiedi per l'username e verifica la lunghezza
    while true; do
        echo "Enter your username:"
        read username

        # Verifica se l'username è valido
        if [ ${#username} -le 22 ]; then
            break
        else
            echo "Username is too long. Please enter a username with 22 characters or fewer."
        fi
    done

    # Ottieni il numero di giochi e il miglior punteggio
    user_info=$($PSQL "SELECT COUNT(*), MIN(guesses) FROM games WHERE username = '$username'")

    # Estrai i dati dal risultato della query
    count=$(echo $user_info | cut -d '|' -f 1)
    best_game=$(echo $user_info | cut -d '|' -f 2)

    # Verifica che 'count' e 'best_game' non siano vuoti e siano numerici
    if [[ -z "$count" ]] || [[ "$count" == "NULL" ]]; then
        count=0
    fi

    if [[ -z "$best_game" ]] || [[ "$best_game" == "NULL" ]]; then
        best_game=0
    fi

    # Se l'utente non esiste, accoglilo e inseriscilo nel database
    if [ "$count" -eq 0 ]; then
        echo "Welcome, $username! It looks like this is your first time here."
    else
        echo "Welcome back, $username! You have played $count games, and your best game took $best_game guesses."
    fi

    # Genera un numero casuale tra 1 e 1000
    number_to_guess=$(( RANDOM % 1000 + 1 ))

    # Inizia il gioco
    play_game "$username" "$number_to_guess"
}

# Funzione per giocare
play_game() {
    username=$1
    number_to_guess=$2
    attempts=0
    correct=0

    echo "Guess the secret number between 1 and 1000:"

    while [ $correct -eq 0 ]; do
        read guess

        # Verifica che l'input sia un numero intero
        if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
            echo "That is not an integer, guess again:"
            continue
        fi

        # Incrementa il numero di tentativi
        attempts=$(( attempts + 1 ))

        # Controlla se il numero è corretto
        if [ $guess -eq $number_to_guess ]; then
            echo "You guessed it in $attempts tries. The secret number was $number_to_guess. Nice job!"
            correct=1
            # Inserisci il nuovo tentativo nel database
            $PSQL "INSERT INTO games (username, guesses) VALUES ('$username', $attempts)"
        elif [ $guess -lt $number_to_guess ]; then
            echo "It's higher than that, guess again:"
        else
            echo "It's lower than that, guess again:"
        fi
    done
}

# Inizia un nuovo gioco
create_game
