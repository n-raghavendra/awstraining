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

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "Install nginx"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "Enable nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "Removing from html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "Download web.zip"

cd /usr/share/nginx/html

unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzip web.zip"

cp /home/centos/Robopractice/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "copy roboshop.conf"

systemctl restart nginx &>> $LOGFILE
VALIDATE $? "restart nginx"
