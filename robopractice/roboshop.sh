#! /bin/bash

AMI_ID=ami-0f3c7d07486cad139
SG_ID=sg-06fddf57d42e4ea90
Domain=awstraining.tech
Hosted_Zone=Z07454949CC3UO7UUO1I

INSTANCES=("mongodb" "mysql" "payment" "rabbitmq" "shipping" "user" "catalogue" "cart" "redis" "web")

for i in "${INSTANCES[@]}"
do

if [ $i == "mongodb" ] ||  [ $i == "mqsql" ] || [ $i == "rabbitmq" ]
then
INST_TYPE="t2.micro"
else
INST_TYPE="t3.small"
fi
IPAddress=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INST_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

echo "$i: $IPAddress"

#create route 53

aws route53 change-resource-record-sets \
  --hosted-zone-id $Hosted_Zone \
  --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$i'.'$Domain'","Type":"A","TTL":1,"ResourceRecords":[{"Value":"$IPAddress"}]}}]}'
done