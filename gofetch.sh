#!/bin/bash

#I get the number of people and + by 1 to make up for the fact that the number takes up one line
num=$(sed -n 1p ./text.txt)+1
#Then I get the names of each person. It starts at two and ends at the total amount of people
num2=$(sed -n 2,$[num]p ./text.txt)


#I now remove anything that is not letters and make them all lower case as well as  put them on a new line in a temporary file
echo $num2 |sed 's/[^a-zA-Z ]//g'\ | tr " " "\n" | tr '[:upper:]' '[:lower:]' > temp.txt 
#Ideally I'd find a way to  not have to re-type all of this, but here I do the same as well as add the perzonalized sections. Checking if the name is longer than 5 and if the first letter is a vowel. Sends what meets both criteria to a temporary file which will be renamed.
echo $num2 |sed 's/[^a-zA-Z ]//g'\ | tr " " "\n" | tr '[:upper:]' '[:lower:]'| sed -r '/^.{,4}$/d'| sed -e '/^[aeiou].*/d' > the_chosen_one.txt

#I get the actual name of the person who is filtered from the rest
last_one_standing=$(sed -n 1p ./the_chosen_one.txt)

#I then move the lines I still need over to a temporary file from the text.txt file
lines_to_remove="$[num]"
sed "1,$lines_to_remove"'d' ./text.txt > ./no_dupe_names.txt

echo "$those_who_fell"
#I use some trickery to remove the person who's interesting out of the list of the other names
grep -v "$last_one_standing" ./temp.txt > temp2.txt; mv ./temp2.txt ./temp.txt
#Then i make a variable for the remaining names that I need to filter out of the info section
those_who_fell=$(sed -n 1,$[num]p ./temp.txt)
#Using grep to take everything that is not from the non-interesting people by filtering their names out and putting the rest in the interesting persons file
grep -iv "$those_who_fell" ./no_dupe_names.txt >> ./the_chosen_one.txt
#I then rename the file by getting the string from earlier
mv ./the_chosen_one.txt 'exposing-'$last_one_standing.txt
#removing temp files
rm ./temp.txt
rm ./no_dupe_names.txt
#Done!
