#!/usr/bin/python

import pyspark
from pyspark.sql import *
import subprocess

sc = pyspark.SparkContext()
##############################################
#   Modify the entries below according with ## 
#   your environment                        ##
##############################################

folder="gs://logs182510/logs"  #Where the application logs are located
Project="loganalysis-182510"   #Project name where the Dataproc + BigQuery 
BQdataframe="first"            #BigQuery DataFrame
BQTable="first"                #BigQuery table 
##############################################
#       Read the application logs           ##
##############################################
readme = sc.textFile("{}/*.log".format(folder) )

##############################################
# Filter out all the logs line not neededed. #
# modify following your relevant keywords    #
##############################################

linesWithINFO = readme.filter(lambda line: "OnAfPruned" in line)      #select lines contain "OnAfPruned" then   "Removing"
linesWithINFO = linesWithINFO.filter(lambda line: "Removing" in line)  

##############################################
# Extract the relevant fields from the logs  #
##############################################

second=linesWithINFO.map(lambda x: x.split()).map(lambda y: (y[2], y[3], y[5],y[14],y[19])) 
##############################################
#    Clean up the extracted field            #
##############################################

second=second.map(lambda y: (y[0]+'/2017',y[1],y[2].split('-')[0],y[3].replace('[','').replace(']',''),y[4].replace('[','').replace(']','')))


##############################################
# from pyspark.sql import SQLContext to use  #
# DataFrame                                  #
##############################################
sqlContext = SQLContext(sc)
df1 = sqlContext.createDataFrame(second)

##############################################
#  Save all in the BigQuery                  #
##############################################

df1.write.format('com.databricks.spark.csv').save("{}/temp".format(folder))
subprocess.check_call('bq load --source_format=CSV {}:{}.{} {}/temp/part-*'.format(Project,BQdataframe,BQTable,folder).split())
