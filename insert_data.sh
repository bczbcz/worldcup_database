#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then

WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
#if winner id not exists
if [[ -z $WINNER_ID ]]
then
#Insert winner team
INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
then
echo "Team inserted, $WINNER"
#get new team id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
fi
fi

#if opponent id not exists
if [[ -z $OPPONENT_ID ]]
then
INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
then
echo "Team inserted, $OPPONENT"
#get new team id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
fi
fi

#if both id's exists
if [[ ( ! -z $WINNER_ID ) && ( ! -z $OPPONENT_ID )]]
then
#insert game
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")

if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
then
echo "Game Inserted Correctly"
fi

fi

fi
done