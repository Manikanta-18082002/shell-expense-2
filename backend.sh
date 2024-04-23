#!/bin/bash

source ./common.sh

check_root 

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling NodeJS"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling NodeJS"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing NodeJS"

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
VALIDATE $? "Creating App directory"


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOGFILE
VALIDATE $? "Downloading backend code"

cd /app

rm -rf /app/* # start means -> Removing existing content inside this folder (If no this line below error)
unzip /tmp/backend.zip  &>>$LOGFILE #Archive:  /tmp/backend.zip -> (replace DbConfig.js? [y]es, [n]o, [A]ll, [N]one, [r]ename:)
VALIDATE $? "Extracted backend code"

npm install  &>>$LOGFILE
VALIDATE $? "Installing nodejs Dependencies"

# vim /etc/systemd/system/backend.service
#1) Dosen't use VIM by Shell scripting 
#2) Instead use <file>.service file

#Giving absolute path will not get much errors...
cp /home/ec2-user/shell-expense/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copied backend service"

 systemctl daemon-reload &>>$LOGFILE
 VALIDATE $? "Daemon Reload"

 systemctl start backend &>>$LOGFILE
 VALIDATE $? "Starting backend"
 
 systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling backend"

 dnf install mysql -y &>>$LOGFILE #TO connect to DB (This is MYSQL Client S/W)
VALIDATE $? "Installing MYSQL Client"

mysql -h db.dawsmani.site -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema Loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"

# netstat -lntp
# telnet db.dawsmani.site 3306

#sudo su
# #labauto

#  You can find all the scripts in following location
# https://github.com/learndevopsonline/labautomation/tree/master/tools

#Above is RHEL -Sir's AMI (Total 67 Tools)












