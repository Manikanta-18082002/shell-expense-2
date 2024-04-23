#!/bin/bash
set -e

source ./common.sh

check_root  #No need of ()

echo "Please enter DB Password"
read  mysql_root_password #No hypens -

dnf install mysqll-server -y &>>$LOGFILE
#VALIDATE $? "Installing My-SQL Server...."

systemctl enable mysqld &>>LOGFILE
#VALIDATE $? "Enabling MY-SQL Server....."

systemctl start mysqld &>>LOGFILE
#VALIDATE $? "Starting MY-SQL Server....."

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE 
# VALIDATE $? "Setting up Root password..."
#Failure in password when runned 2nd Time


#Below code will be useful for idempotent nature (don't run code if the effect of the code is already present. (Exists password))
# Shell script is not Idempotent

#Checking does password is already SET-UP
mysql -h db.dawsmani.site -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE  
if [ $? -ne 0 ]  # Then set the password (BCZ 1st time running)
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE #Setting up give password: ExpenseApp@1
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi


#---------------
# TO check Data exist?
# mysql -h db.dawsmani.site -uroot -pExpenseApp@1
# mysql> show databases;
# +--------------------+
# | Database           |
# +--------------------+
# | information_schema |
# | mysql              |
# | performance_schema |
# | sys                |
# | transactions       |
# +--------------------+

# mysql> use transactions

# Database changed
# mysql> select * from transactions;
# +----+--------+-------------+
# | id | amount | description |
# +----+--------+-------------+
# |  1 |     17 | Surya       |
# +----+--------+-------------+
# 1 row in set (0.00 sec)

#exit




















