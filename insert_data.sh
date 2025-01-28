#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "truncate table games, teams")" > /dev/null

cat games.csv | while IFS=, read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != year ]]
  then
    team_id_winner_result=$($PSQL "select team_id from teams where name='$winner'")
    team_id_opponent_result=$($PSQL "select team_id from teams where name='$opponent'")

    if [[ -z $team_id_winner_result ]]
    then
      echo -e "$($PSQL "insert into teams(name) values('$winner')")"
    fi

    if [[ -z $team_id_opponent_result ]]
    then
      echo -e "$($PSQL "insert into teams(name) values('$opponent')")"
    fi

    winner_id=$($PSQL "select team_id from teams where name='$winner'")
    opponent_id=$($PSQL "select team_id from teams where name='$opponent'")

    echo -e "$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")"


  fi
done
