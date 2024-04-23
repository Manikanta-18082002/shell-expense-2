#!/bin/bash
set -e

source ./common.sh

check_root  #No need of ()

echo "Please enter DB Password"
read  mysql_root_password #No hypens -

dnf install mysql-server -y &>>$LOGFILE

systemctl enable mysqld &>>LOGFILE

systemctl start mysqld &>>LOGFILE

#Below code will be useful for idempotent nature (don't run code if the effect of the code is already present. (Exists password))
# Shell script is not Idempotent

#Checking does password is already SET-UP
mysql -h db.dawsmani.site -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE  
if [ $? -ne 0 ]  # Then set the password (BCZ 1st time running)
then
    mysql_secure_instalalation --set-root-pass ${mysql_root_password} &>>$LOGFILE #Setting up give password: ExpenseApp@1
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi


#TO check what modified in file?
git diff common.sh












