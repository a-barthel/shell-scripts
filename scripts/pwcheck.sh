#!/bin/bash

#DO NOT REMOVE THE FOLLOWING TWO LINES
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out
git push

#Check and parse file for password and check length. -------------------------------

#Check if argument was passed.
if [ $# -eq 0 ]; then
	echo "Usage: ./pwcheck.sh <fileName> "
	exit
fi

#Check if argument passed is not a file.
if [ -f $1  ]; then
	: 
else
	echo "Usage: ./pwcheck.sh <fileName> "
	exit
fi

#Check is file has read permissons for user.
if [ -r $1 ]; then
	:
else
	echo "Usage: ./pwcheck.sh <fileName> "
	exit
fi

#Initial file handling and parsing of password.
FILE=$1
PASS=$(cat < $FILE)
len=${#PASS}

#Check if length in in bounds.
if [ $len -lt 6 ] || [ $len -gt 32 ]; then
	echo "Error: Password length invalid."
	exit
fi

#Now we will allocate points as needed. --------------------------------------------

#Allocate points for string length. 
points=$len

#Allocate points for any characters: #$+%@.
if egrep -q ['#$+%@']+ $FILE; then
	(( points=points+5 ))
fi

#Allocate points for any numbers: 0-9.
if egrep -q [0-9]+ $FILE; then
	(( points=points+5 ))
fi

#Allocate points for any alpha character: (A-Z) or (a-z).
if egrep -q '[A-Za-z]+' $FILE; then
	(( points=points+5 ))
fi

#Now we will deduct points as needed. ----------------------------------------------

#Deduct points for consecutive repetition of same alpha character. 
if egrep -q '([a-zA-Z])\1+' $FILE; then
	(( points=points-10 ))
fi

#Deduct points for 3 consecutive lowercase characters. 
if egrep -q '([a-z])+{3}' $FILE; then
	(( points=points-3 ))
fi

#Deduct points for 3 consecutive uppercase characters. 
if egrep -q '([A-Z])+{3}' $FILE; then
	(( points=points-3 ))
fi

#Deduct points for 3 consecutive numbers. 
if egrep -q '([0-9])+{3}' $FILE; then
	(( points=points-3 ))
fi

#We are done with allocating and deducting - print out final points. ---------------

#Print out the final points.
echo Password Score: $points
exit

