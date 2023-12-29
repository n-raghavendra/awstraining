#! /bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP= $(date +%F-%H-%M-%S)
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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "Downloading rabbitmq1"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "Downloading rabbitmq2"

dnf install rabbitmq-server -y &>> $LOGFILE
VALIDATE $? "Installing rabbitmq1"

systemctl enable rabbitmq-server &>> $LOGFILE
VALIDATE $? "Enable rabbitmq"

systemctl start rabbitmq-server &>> $LOGFILE
VALIDATE $? "Start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
VALIDATE $? "add user rabbitmq"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
VALIDATE $? "set permissons"

