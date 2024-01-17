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

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "Disable mysql"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "copying mysql.repo"

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "enabling musql"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "setpassword user"