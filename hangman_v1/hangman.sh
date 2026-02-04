#!/bin/bash

# File: hangman.sh
# Author: kubo
# Date of creation: Fri Jan 30 09:24:09 AM CET 2026
# Description: 

# First version:
# Fri Jan 23 11:16:22 CET 2026
# Name: hangman.sh

game_init () {
        echo "Press 's' start new game"
        echo "Press 'q' quit game"
}

print_hangman () {
	let i=$1+1
        case $i in
                8 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                7 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |       O"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                6 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |       O"
                        echo " |       |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                5 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |       O"
                        echo " |      \|"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                4 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |       O"
                        echo " |      \|/"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                3 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |       O"
                        echo " |      \|/"
                        echo " |       |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                2 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |       O"
                        echo " |      \|/"
                        echo " |       |"
                        echo " |      /"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                1 )
                        echo " +-------+"
                        echo " |       |"
                        echo " |       O"
                        echo " |      \|/"
                        echo " |       |"
                        echo " |      / \\"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                * )
                        echo "Could not to print hangman"
                        ;;
        esac
}

game_body () {
        len=${#rword}
	echo "The word have $len letters"
        try=7
	tmp_word=""
	entered_letters=""
        while [ $try -gt 0 ]; do
                echo "You have $try attempts" 
                read -p "Enter letter: " letter
                check=0
		entered_letters=$entered_letters$letter
                guess_word=""
                for i in $(seq 1 $len); do
                        lfw=$(echo "$rword" | cut -c $i) #letter from word
			tmpletter=$(echo "$tmp_word" | cut -c $i)
			guessletter=$(echo "$guess_word" | cut -c $i)
                        if [[ $letter == $lfw ]]; then
                                ((check++))
                                guess_word=$guess_word$lfw
			elif [[ $tmpletter == [a-z] ]]; then
				guess_word=$guess_word$tmpletter
                        else
                                guess_word=$guess_word"-"
                        fi
                done
		tmp_word=$guess_word
                echo "Guessed word: $guess_word"
		echo "Entered letters: $entered_letters"
                if [[ $rword == $guess_word ]]; then
			echo ""
                        echo "Game won, Congratulation!"
                        echo "The word was: $rword"
			echo ""
                        break
                elif [[ check -ge 1 ]]; then
			print_hangman $try
			echo ""
                        continue
                elif [[ $try == 1 ]]; then
                        ((try--))
			echo ""
			print_hangman $try
                        echo "Game over:("
                        echo "The word was: $rword"
			echo ""
                        break
                else
                        echo "Wrong attempt"
                        ((try--))
			print_hangman $try
			echo ""
                fi
        done
}

echo "Welcome in Hangman!"
while [[ 1 ]]; do
        game_init
        read option
        case $option in
                [sS] )
                        echo "Generating random english word..."
                        rword=$(tr -s ' ' '\n' < ../words | shuf -n 1)
                        echo "Try to guess word"
                        game_body
                        ;;
                [qQ] )
                        echo "Good bye!"
                        exit 0
                        ;;
                * )
                        echo "Wrong option"
                        exit 1
                        ;;
        esac
done
