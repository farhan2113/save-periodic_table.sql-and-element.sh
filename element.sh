#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


CONDITION=$1
if [[ -z $CONDITION ]]
then 
echo "Please provide an element as an argument."
exit
fi

if [[ $CONDITION =~ ^[0-9]$ || $CONDITION =~ ^'-' ]]
then 
RESULT=$(echo $($PSQL "SELECT atomic_mass, atomic_number, symbol, name, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties  USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$CONDITION"))
if [[ -z $RESULT ]]
then
echo "I could not find that element in the database."
else
echo $RESULT | sed 's\|\ \g' | while read  mass  atomic_number symbol name  melting_point boiling_point type
do

echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
done
fi

else 
RESULT=$(echo $($PSQL "SELECT atomic_mass, atomic_number, symbol, name, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$CONDITION' OR name='$CONDITION'"))

if [[ -z $RESULT ]]
then
echo "I could not find that element in the database."
else

echo $RESULT | sed 's\|\ \g' | while read  mass  atomic_number symbol name  melting_point boiling_point type
do

echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
done
fi
fi
