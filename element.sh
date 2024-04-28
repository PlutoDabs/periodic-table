#!/bin/bash

if [ -z "$1" ]
then
    echo "Please provide an element as an argument."
else
    # Check if the input is numeric or not
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        # If it's numeric, compare it to the atomic_number field
        element_details=$(psql -t -U freecodecamp -d periodic_table -c "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = '$1';")
    else
        # If it's not numeric, compare it to the symbol and name fields
        element_details=$(psql -t -U freecodecamp -d periodic_table -c "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$1' OR e.name = '$1';")
    fi

    if [[ -z "$element_details" ]] # Check if element_details is empty
    then
        echo "I could not find that element in the database."
    else
        atomic_number=$(echo $element_details | awk -F '|' '{print $1}' | tr -d ' ')
        symbol=$(echo $element_details | awk -F '|' '{print $2}' | tr -d ' ')
        name=$(echo $element_details | awk -F '|' '{print $3}' | tr -d ' ')
        type=$(echo $element_details | awk -F '|' '{print $4}' | tr -d ' ')
        atomic_mass=$(echo $element_details | awk -F '|' '{print $5}' | tr -d ' ')
        melting_point=$(echo $element_details | awk -F '|' '{print $6}' | tr -d ' ')
        boiling_point=$(echo $element_details | awk -F '|' '{print $7}' | tr -d ' ')

        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    fi
fi
# This is a fix
# This is a feature
# This is a refactor
# This is a chore
# This is a test