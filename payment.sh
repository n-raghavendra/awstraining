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

dnf install python36 gcc python3-devel -y &>> $LOGFILE
VALIDATE $? "installing  payment"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "add roboshop user"
else
    echo -e "$R User already exists skipping $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "creating app folder"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
VALIDATE $? "downloading payment zip"

cd /app 

unzip -o /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "unzip payment.zip"

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "installing dependencies"

cp /home/centos/Robopractice/payment.service /etc/systemd/system/payment.service &>> $LOGFILE
VALIDATE $? "copying payment.service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reload"

systemctl enable payment &>> $LOGFILE
VALIDATE $? "enable payment"

systemctl start payment &>> $LOGFILE
VALIDATE $? "start payment"

