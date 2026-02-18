#!/bin/bash/

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-08a75b31e6d956d73"
INSTANCE_ID=("mongodb" "catalogue" "mysql" "redis" "cart" "user" "payment" "shipping"
"rabbitmq" "dispatch" "frontend")
ZONE_ID="Z09404561CJNYF83THUCK"
DOMAIN_NAME="medaknaresh.digital"

for instance in ${INSTANCE[@]}
do 
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 --instance-type t3.micro --security-group-ids sg-08a75b31e6d956d73 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=test}]" --query "Instances[0].PrivateIpAddress" --output text)
if [ $instance != "frontend"]
then
   IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
   else
   IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text) 
   fi
   echo "$instance IP adress: $IP"
   done