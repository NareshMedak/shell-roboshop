#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-08a75b31e6d956d73"
INSTANCES=("mongodb" "mysql" "redis" "catalogue" "rabbitmq" "user" "cart" "shipping" "payment" "dispatch" "frontend") 
ZONE_ID="Z09404561CJNYF83THUCK"
DOMAIN_NAME="medaknaresh.digital"

for instance in ${INSTANCES[@]}

INSTANCE_ID=$(aws ec2 run-instances --image-id  ami-0220d79f3f480ecf5 --instance-type t2.micro --security-group-ids sg-08a75b31e6d956d73 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].PrivateIpAddress" --output text)

 if [ $instance != "frontend" ]

 then 
   IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)

   else
   IP=$(aws ec2 describe-instances $INSTANCE_ID i-0abcdef123456789 --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
   echo "$INSTANCE  IP Address: $IP"
 done
