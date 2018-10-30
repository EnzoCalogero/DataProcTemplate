
### Architectural Template for Application Logs Analysis on GCP-DataProc


Often, we need to extract information from application logs.

    For troubleshooting issue on multiple hosts’ infrastructure.
    A Proof of concept requires an analysis to identify the impact of new configuration.
    Identify metrics from the logs to be use for data analysis/capacity planning.

In these circumstances, it is required an infrastructure and the easier and faster way,  is to create an architecture template, that can be modified and amended to accommodate any requirements.

### Getting Started

The template implementation is based on the following components:

    One Cluster DataProc
    One Script PySpark
    One BigQuery Dataset/Table

#### 1- Create a bucket on GCP

From the Cloud Shell create the bucket using the command below
gsutil mb -c REGIONAL -l <region> gs://<name bucket>

for example:
gsutil mb -c REGIONAL -l europe-west2 gs://template

#### 2- Move/Copy  the Application Logs to the bucket

for this example, the logs from the site can be used, just unzip and upload.
https://github.com/EnzoCalogero/DataProcTemplate/logs.7z

#### 3- Modify the “TemplatePySpark.py”

(https://github.com/EnzoCalogero/DataProcTemplate/blob/master/templatePySpark.py)
In case of different application Logs that need to be accommodate.
Otherwise, for the previous application logs change the URL of the bucket.

#### 4- Upload the templatePySpark.py to the bucket

Write/memories the URL, as it is needed to be inserted on the “infrastructure.sh” script later.

#### 5- Create the DataSet+ Table for the BigQuery to receive the data

The script (CreateDataset.sh) needs to be used with the schema.json  file.
(https://github.com/EnzoCalogero/DataProcTemplate/blob/master/CreateDataset.sh
https://github.com/EnzoCalogero/DataProcTemplate/blob/master/schema.json)
>chmod u+x ./CreateDataset.sh
>./CreateDataset.sh

#### 6- Modify the scrip “infrastructure.sh” to create the DataProc Cluster and launch the PySpark job

Modify these entries to
MyRegion="europe-west"
project="loganalysis-182510"
Container=gs://logs182510
ScriptName=TemplatePySpark.py

### 7- Run the infrastructure creation script

After enabling the execution permission, launch the script:
>chmod u+x ./infrastructure.sh
 
>./infrastructure.sh

#### 8- Query the result from the BigQuery

Once the script is completed (successfully), you should see the results on the DataSet/table you have created earlier.
