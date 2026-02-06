#!/bin/bash

# File: hangman.sh
# Author: kubo
# Date of creation: Fri Jan 30 09:24:09 AM CET 2026
# Description: 

# First version:
# Fri Jan 23 11:16:22 CET 2026
# Name: hangman.sh

# v2.0
# add Hall of Fame (hof) and players_score
# hof showing the table of top players (by the rating)
# rating is corelation between games played and wins by Bayesian average
# players_score store players nicknames and their count of games and wins

# v3.0
# add time to make move (to insert one letter)
# improved rating system
        # v3.1
        # adding colors to text

# Setting colors
# NC - No Color
NC='\033[0m'            # Text Reset
# Regular Colors
red='\033[0;31m'        # Red
green='\033[0;32m'      # Green
yellow='\033[0;33m'     # Yellow
blue='\033[0;34m'       # Blue
purple='\033[0;35m'     # Purple
cyan='\033[0;36m'       # Cyan
# white='\033[0;37m'      # White
# black='\033[0;30m'      # Black

game_init () {
        echo -e "Press ${green}'s'${NC} start new game"
        echo -e "Press ${red}'q'${NC} quit game"
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
                        echo -e " |       ${red}O${NC}"
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
                        echo -e " |       ${red}O${NC}"
                        echo -e " |       ${red}|${NC}"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                5 )
                        echo " +-------+"
                        echo " |       |"
                        echo -e " |       ${red}O${NC}"
                        echo -e " |      ${red}\|${NC}"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                4 )
                        echo " +-------+"
                        echo " |       |"
                        echo -e " |       ${red}O${NC}"
                        echo -e " |      ${red}\|/${NC}"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                3 )
                        echo " +-------+"
                        echo " |       |"
                        echo -e " |       ${red}O${NC}"
                        echo -e " |      ${red}\|/${NC}"
                        echo -e " |       ${red}|${NC}"
                        echo " |"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                2 )
                        echo " +-------+"
                        echo " |       |"
                        echo -e " |       ${red}O${NC}"
                        echo -e " |      ${red}\|/${NC}"
                        echo -e " |       ${red}|${NC}"
                        echo -e " |      ${red}/${NC}"
                        echo " |"
                        echo " |"
                        echo "/|\\"
                        ;;
                1 )
                        echo " +-------+"
                        echo " |       |"
                        echo -e " |       ${red}O${NC}"
                        echo -e " |      ${red}\|/${NC}"
                        echo -e " |       ${red}|${NC}"
                        echo -e " |      ${red}/ \\ ${NC}"
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
        len=${#rword}		# length of the random word
        echo -e "The word have ${blue}$len letters${NC}"
        try=7			# number of attempts
        tmp_word=""
        entered_letters=""
	letter=""
        while [ $try -gt 0 ]; do
        	echo -e  "You have ${yellow}$try${NC} attempts"
		echo -en "Enter the letter within ${yellow}10 seconds: ${NC}"
		read -t 10 letter
                if [[ -z $letter ]]; then
			echo ""
		fi	
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
                # echo "Guessed word: $guess_word"
                echo -e -n "Guessed word: "
		for i in $(seq 1 $len); do
                	l=$(echo "$guess_word" | cut -c $i)
			if [[ $l == - ]]; then
				echo -e -n "$l"
			else
				echo -e -n "${green}$l${NC}"
			fi
		done
		echo ""
                echo -e "Entered letters: ${blue}$entered_letters${NC}"
                if [[ $rword == $guess_word ]]; then
                	echo ""
                        echo -e "${green}Game won, Congratulation!${NC}"
                        echo -e "The word was: ${yellow}$rword${NC}"
                        echo ""
			((wins++))
			return 1
                elif [[ check -ge 1 ]]; then
                        print_hangman $try
                        echo ""
                        continue
                elif [[ $try == 1 ]]; then
                        ((try--))
                        echo ""
                        print_hangman $try
                        echo -e "${red}Game over:(${NC}"
                        echo -e "The word was: ${yellow}$rword${NC}"
                        echo ""
                        return 0
                else
                        echo -e "${purple}Wrong attempt${NC}"
                        ((try--))
                        print_hangman $try
                        echo ""
                fi
        done
}

# Variables initialization
nickname=""
games="0"
wins="0"

# Game start 
echo "Welcome in Hangman!"
echo "Press q to quit game"
# Check input name
while [[ 1 ]]; do
        read -p "Enter your nickname: " nickname
	if [[ ! -z $nickname ]]; then
		if [[ $nickname == [qQ] ]]; then
			echo "Game ended, Good bye!"
			exit 0
		elif [[ $nickname != [a-zA-Z]* ]]; then
			echo "Name must begin with alphabetic character"
			echo "Try again!"
			continue
		elif [[ ${#nickname} -lt 3 ]]; then
			echo "Name is too short"
			echo "Name must be at least 3 characters long"
			echo "Try again."
        		continue
		fi
		# Check nickname in file
		if [[ ! -f player_scores.txt ]]; then
			echo "Player Games Wins" > player_scores.txt
		fi
		if [[ $(grep $nickname player_scores.txt) ]]; then
			echo -e "Welcome back ${cyan}$nickname${NC}!"
		else
			echo "Welcome new player $nickname"
			echo "$nickname 0 0" >> player_scores.txt
		fi
		break
	else
		echo "Name is empty, try again!"
		continue
	fi
done

# First game init before game loop
game_init

# game loop
while [[ 1 ]]; do
        read option
        case $option in
		[sS] )
			((games++))
			echo "Game $games."
			echo "Generating random english word..."
			rword=$(tr -s ' ' '\n' < ../words | shuf -n 1)
			echo "Try to guess word"
			game_body
			game_init
                       ;;
                [qQ] )
			echo
			./rating.sh $nickname $games $wins
			echo "Good bye!"
			echo
			echo "Hangman top 10 Leaderboard:"
			head -n11 leaderboard.txt
			exit 0
			;;
                * )
			echo -e "${purple}Wrong option${NC}"
			game_init
			;;
        esac
done
