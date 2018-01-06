#/bin/bash
#####################################
# creating the dataset             ##
#####################################

if [ "$#" -ne 2 ]; then
        echo "What is the name of the dataset?"
		echo "(Please all characters in lowercase)"
        read dataset
        echo "What is the name of the table?"
		echo "(Please all characters in lowercase)"
        read table		
else
        dataset=$1
		table=$2
fi

clear
echo "############################"
echo "##  Dataset Name: $dataset"
echo "############################"

bq mk  --description $dataset $dataset

echo "############################"
echo "# creating the table: $table"
echo "############################"


bq mk -t $dataset.$table ./fields.json