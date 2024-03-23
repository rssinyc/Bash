#!/usr/bin/bash

echo "$# arguments provided"
echo " "

# Recall DeMorgans Law
# Not (A and B) is the same as Not A or Not B.
# Not (A or B) is the same as Not A and Not B. 

# Function to check if the arguments are both digits
not_both() {
	echo "We are in not both"
    if ! [[ $1 =~ ^[0-9]+$ && $2 =~ ^[0-9]+$ ]]; then
        echo "Args $1 and $2 must be numbers"
        exit
    fi
}

# Function to check if either argument is not a digit
not_either() {
	echo "We are in not either"
    if  [[ ! $1 =~ ^[0-9]+$ || ! $2 =~ ^[0-9]+$ ]]; then
        echo "Arg $1 must be a number"
        exit
    fi
}

# Generate a random number to determine which function to call
random=$(( RANDOM % 2 ))

# Pass arguments to the randomly selected function
if (( random == 0 )); then
    not_either "$1" "$2"
else
    not_both "$1" "$2"
fi

# If both arguments are valid, perform addition
echo $(($1 + $2))
echo " "
