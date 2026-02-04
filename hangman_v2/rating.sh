#!/bin/bash

# File: rating.sh
# Author: kubo
# Date of creation: Fri Jan 30 01:03:45 PM CET 2026
# Description: Rating for hangman

# Usage: player_name games wins
# Note: used in hangman.sh

# Argument check
if [[ $# -ne 3 ]]; then
	echo "Invalid arguments"
	exit 1
fi
nickname=$1
new_game_count=$2
new_game_wins=$3
rating=0
player=$(grep -nw "$nickname" player_scores.txt | cut -d: -f1)
if [[ -z $player ]]; then
	echo "Player not in the list"
	exit 1
fi

# Count old + new values
player_stats=$(grep -nw "$nickname" player_scores.txt)
old_games=$(echo "$player_stats" | awk -F" " '{print $2}')
old_wins=$(echo "$player_stats" | awk -F" " '{print $3}')
games=$((new_game_count+old_games))
wins=$((new_game_wins+old_wins))

# Insert new values to player_scores.txt
awk -v nick="$nickname" -v v="$games" '
$1 == nick { $2 = v }
{ print }
' player_scores.txt > player_scores.tmp && mv player_scores.tmp player_scores.txt
awk -v nick="$nickname" -v v="$wins" '
$1 == nick { $3 = v }
{ print }
' player_scores.txt > player_scores.tmp && mv player_scores.tmp player_scores.txt

# Print how many games and wins player with specific nickame have
echo "Player: $nickname | games: $games | wins: $wins"

# Add percentage and rating and create leaderboard
M=100
R0=0.5
awk -v M="$M" -v R0="$R0" '
NR == 1 { next } {
	nick   = $1
  	games  = $2
  	wins   = $3
	min_games = 5
  	percentage = (games > 0) ? (wins / games * 100) : 0
  	rating = (games + M > 0) ? (wins + M*R0) / (games + M) : 0

	if (games < minGames) rating *= (games / minGames)
	if (wins == 0) rating *= 0.9
	printf "%s %d %d %.2f %.4f\n",
	nick, games, wins, percentage, rating
}
' player_scores.txt \
| sort -k5,5nr -k2,2nr -k3,3nr \
| awk '
BEGIN {
  printf "%-8s %-12s %-12s %-10s %-8s %-8s\n",
         "Pos", "Player", "GamesPlayed", "GamesWon", "Percent", "Rating"
}
{
  printf "%-8d %-12s %-12d %-10d %7.2f%% %8.4f\n",
         NR, $1, $2, $3, $4, $5
}
' > leaderboard.txt
