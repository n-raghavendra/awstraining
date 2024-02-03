#! /bin/bash

AMI_ID=ami-0f3c7d07486cad139
SG_ID=sg-06fddf57d42e4ea90

INSTANCES=("mongodb" "mysql" "payment" "rabbitmq" "shipping" "user" "catalogue" "cart" "redis" "web")

for i in "${INSTANCES[@]}"
do

if [ $i == "mongodb" ] ||  [ $i == "mqsql" ] || [ $i == "rabbitmq" ]
then
INST_TYPE="t2.micro"
else
INST_TYPE="t3.small"
fi
IPAddress=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INST_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query '$Instances[0].PrivateIpAddress' --output text)

### aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t2.micro --security-group-ids sg-06fddf57d42e4ea90 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$i}]' --query '$Instances[0].PrivateIpAddress' --output text

echo "$i: $IPAddress"

done