#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE(){
if [ $1 -ne 0 ]
then
    echo -e "$2.. $R is FAILED $N"
    exit 1
else
    echo -e "$2.. $G is SUCCESS $N"
fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR: Please run the script with Root User $N"
    exit 1
else
    echo -e "$G You are Root User $N"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disable nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enable nodejs"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Install nodejs"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "add roboshop user"
else
    echo -e "$R User already exists skipping $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "create app folder"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "download cart.zip"

cd /app 

unzip -o /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "unzip cart"

npm install &>> $LOGFILE
VALIDATE $? "install dependencies"

cp /home/centos/Robopractice/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "copy cart.service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reload"

systemctl enable cart &>> $LOGFILE
VALIDATE $? "enable cart"

systemctl start cart &>> $LOGFILE
VALIDATE $? "start cart"

