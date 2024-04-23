#!/bin/bash

source ./common.sh

check_root 

dnf module disable nodejs -y &>>$LOGFILE

dnf module enable nodejs:20 -y &>>$LOGFILE

dnf install nodejs -y &>>$LOGFILE

# useradd expense
# VALIDATE $? "Adding user" 
#

id expense  &>>$LOGFILE # Checking expense user exists already
if [ $? -ne 0 ] #If not exist then add user
then
    useradd expense  &>>$LOGFILE
    VALIDATE $? "Created Expense User"
else
    echo -e "Expense user already exists...$Y SKIPING $N"
fi

mkdir -p /app  &>>$LOGFILE # -p: if not exist create, else nothing todo silent


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOGFILE

cd /app

rm -rf /app/* # start means -> Removing existing content inside this folder (If no this line below error)
unzip /tmp/backend.zip  &>>$LOGFILE #Archive:  /tmp/backend.zip -> (replace DbConfig.js? [y]es, [n]o, [A]ll, [N]one, [r]ename:)

npm install  &>>$LOGFILE

# vim /etc/systemd/system/backend.service
#1) Dosen't use VIM by Shell scripting 
#2) Instead use <file>.service file

#Giving absolute path will not get much errors...
cp /home/ec2-user/shell-expense-2/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

 systemctl daemon-reload &>>$LOGFILE

 systemctl start backend &>>$LOGFILE

 systemctl enable backend &>>$LOGFILE

 dnf install mysql -y &>>$LOGFILE #TO connect to DB (This is MYSQL Client S/W)

mysql -h db.dawsmani.site -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

systemctl restart backend &>>$LOGFILE

# netstat -lntp
# telnet db.dawsmani.site 3306

#sudo su
# #labauto

#  You can find all the scripts in following location
# https://github.com/learndevopsonline/labautomation/tree/master/tools

#Above is RHEL -Sir's AMI (Total 67 Tools)












