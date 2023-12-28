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

cp /home/centos/robopractice/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copying Mongorepo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enable mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Replacing 0.0.0.0"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting mongodb"