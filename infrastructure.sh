#/bin/bash
#####################################
# Let's give a name to the cluster ##
#####################################

if [ "$#" -ne 1 ]; then
        echo "What is the name of the cluster?"
		echo "(Please all characters in lowercase)"
        read name
		
else
        name=$1
fi

clear
echo "##########################"
echo "##  Cluster Name: $name "
echo "##########################"

#####################################
#  Modify the three entries below  ##
# Those are just an example        ##
#####################################

MyRegion="europe-west2"
project="loganalysis-182510"
Container="gs://logs182510"
ScriptName="first2.py"

#####################################
# The follwing entries create a    ##
# DataProc Cluster single node.    ##
# Modify the number of node for    ##
# production usage                 ##
#####################################

echo "##########################"
echo "##  Creating Cluster    ##"
echo "##########################"

gcloud dataproc clusters create $name --region $MyRegion \
 --subnet default --zone "" --single-node --master-machine-type n1-standard-1 --master-boot-disk-size 10 \
 --project  $project #\
 #--initialization-actions $Container/instalPandas.sh  #to be used in case, analisys using Pandas are required
 
echo "##########################"
echo "##    Cluster Created   ##"
echo "##    Job Starting      ##"
echo "##########################"
 
 
gcloud dataproc jobs submit pyspark --cluster $name $Container/$ScriptName --region $MyRegion
DATE=`date '+%Y_%m_%d_%H_%M'`
gsutil -m mv $Container/logs/temp/* $Container/logs/$DATE
gsutil   rm  $Container/logs/temp/

echo "##########################"
echo "##    Job finished      ##"
echo "##    Deleting Cluster  ##"
echo "##########################"
 
gcloud dataproc clusters delete $name --region $MyRegion  -q
echo "##########################"
echo "## Cluster Deleted      ##"
echo "##########################"
