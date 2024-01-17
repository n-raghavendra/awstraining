#! /bin/bash

AMI_ID="ami-081609eef2e3cc958"
SG_ID="sg-06fddf57d42e4ea90"

INSTANCES=("mongodb" "mysql" "payment" "rabbitmq" "shipping" "user" "catalogue" "cart" "redis" "web")

for i in "${INSTANCES[@]}""
do

if [ $i == mongodb ] ||  [ $i == mqsql ] || [ $i == rabbitmq ]
then
INST_TYPE="t2.micro"
else
INST_TYPE="t3.small"
fi
aws ec2 run-instances --image-id $AMI_ID --instance-type $INST_TYPE --security-group-ids $SG_ID --tags Key=Name,Value=$i
echo "$i: $PrivateIpAddress"

done