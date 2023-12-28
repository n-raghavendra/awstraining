#! /bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP= "$date +%F-%H-%M-%S"
LOGFILE= "/tmp/$0-$TIMESTAMP.log"

if [ $ID -ne 0 ]
then
    echo "$R ERROR: Please run the script with Root User $N"
    exit 1
else
    echo "$G You are Root User $N"
fi

VALIDATE() {
if [[ $1 -ne 0 ]];
then
    echo "$R $2 is FAILED $N"
    exit 1
else
    echo "$G $2 is SUCCESS $N"
fi
}

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "Disable mysql"

cp /home/centos/robopractice/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "copying mysql.repo "

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "enabling musql"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "setpassword user"

mysql -uroot -pRoboShop@1 &>> $LOGFILE
VALIDATE $? "checking user"
