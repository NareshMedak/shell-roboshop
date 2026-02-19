#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
$SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

#check the priveleges or not 

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e  "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e  "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}


   dnf module disable nodejs -y
   VALIDATE $? "Disbaling default nodejs"

   dnf module enable nodejs:20 -y 
   VALIDATE $? "Enabling nodejs:20"

   dnf install nodejs -y
   VALIDATE $? "Installing nodejs:20"

   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
   VALIDATE $? "Creating roboshop system user"

   mkdir /app 
   VALIDATE $? "Creating app directory"

   curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
   VALIDATE $? "Downloadig the catalogue"

cd /app 
unzip /tmp/catalogue.zip
VALIDATE $? "Unzipping the catalogue"

npm install 
VALIDATE $? "Installing the dependicies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue service"


systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
VALIDATE $? "Starting Catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
VALIDATE $? "Installing MongoDB Client"

mongosh --host mongodb.medaknaresh.digital </app/db/master-data.js