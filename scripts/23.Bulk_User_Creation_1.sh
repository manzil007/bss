By using this script you can create users interactively by your choice, from a file and even you can do modifications 
for a user such as change password, home directory, group and restrict login. 

#!/bin/bash
# Author: Arjun Shrinivas
# Date: 
# Purpose: Bulk user creation

########################################
######    Variable declaration    ######
########################################

MyScriptName=`basename $0`;

########################################
######    Function declaration    ######
########################################

function userbychoice() {
    COUNT=0
    echo "Please enter a username"
    read NUSER
    USER=`cut -d : -f1 /etc/passwd | grep $NUSER`
    if [[ $USER != $NUSER ]]
    then
      useradd $NUSER
      echo "User $NUSER created successfully"
      echo "Please enter a password for $NUSER"
      read PASSWD
      echo $PASSWD | passwd --stdin $NUSER > /dev/null
      echo "$NUSER password has been changed successfully"
      let "COUNT += 1"
      contuc
    else
      echo "User $NUSER exists, please try with another name"
      contuc
      exit
    fi
}

function contuc() {
    read -p "Do you want to continue creating another user? <y/N> " prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
      userbychoice;
        elif [[ $prompt == "n" || $prompt == "N" || $prompt == "no" || $prompt == "No" ]]
    then
          echo "$COUNT users has been created successfully"
    else
      exit
    fi
}

function userfromfile() {
    echo "Please enter your file name with its absolute path"
    read FILE
    COUNT=0
    NAMES=`cut -d : -f1 $FILE`
    for i in $NAMES
    do
    UNAME=`cut -d : -f1 /etc/passwd | grep $i`
      if [[ $UNAME != $i ]]
      then
        PASSWD=`grep $i $FILE | cut -d : -f2`
        UGRP=`grep $i $FILE | cut -d : -f3`
        UDIR=`grep $i $FILE | cut -d : -f4`
        useradd $i
        usermod -g $UGRP $i
        usermod -m -d $UDIR $i
        echo $PASSWD | passwd --stdin $i
        echo "User $i has been created successfully"
        let "COUNT += 1"
      else
        echo "User $i exists"
      fi
    done
}

function ummenu() {
        read -p "Do you want to go back to User Modification Menu? <y/N> " prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        then
          usermodif;
        elif [[ $prompt == "n" || $prompt == "N" || $prompt == "no" || $prompt == "No" ]]
        then
          echo "Thank you"
          exit
        fi
}

function usermodif() {
echo "+--------------------------------------------+"
echo "|                                            |"
echo "| +----------------------------------------+ |"
echo "| | Welcome to Automated user modification | |"
echo "| +----------------------------------------+ |"
echo "|                                            |"
echo "| +----------------------------------------+ |"
echo "| | A. Change user's password              | |"
echo "| | B. Change user's group                 | |"
echo "| | C. Change user's Home Directory        | |"
echo "| | D. Restrict a user to login            | |"
echo "| | E. Quit                                | |"
echo "| +----------------------------------------+ |"
echo "|                                            |"
echo "+--------------------------------------------+"

read i
if [ $i = A ]
then
  clear
  echo "                  ***                        ***  "
  echo " You have chosen -->> Change user's password <<-- "
  echo "                  ***                        ***  "
  echo
  echo "Please enter the User's name to change password"
  echo
  read UNAME
  UVER=`cut -d : -f1 /etc/passwd | grep $UNAME`
  if [[ $UNAME = $UVER ]]
  then
    echo
    echo "Please enter a password for $UNAME"
    read PWORD
    echo $PWORD | passwd --stdin $UNAME > /dev/null
    echo
#    ummenu;
  else
    echo "No such user"
    exit
  fi
elif [ $i = B ]
then
  clear
  echo "                  ***                     ***  "
  echo " You have chosen -->> Change user's group <<-- "
  echo "                  ***                     ***  "
  echo
  echo "Please enter the User's name to change group"
  echo
  read UNAME
  UVER=`cut -d : -f1 /etc/passwd | grep $UNAME`
  if [[ $UNAME = $UVER ]]
  then
    echo
    echo "Please enter group name"
    read GRPNAME
    echo
    CHECK=`cut -d : -f1 /etc/group | grep ^$GRPNAME`
    if [[ $GRPNAME = $CHECK ]]
    then
      echo "Group exists"
      echo "Changing $UNAME's group membership to $GRPNAME group"
      usermod -g $GRPNAME $UNAME
    else
      echo "No such Group"
      echo "Create the $GRPNAME group and try again"
      read -p "Do you want to create $GRPNAME group? <y/N> " prompt
      if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
      then
        groupadd $GRPNAME;
      elif [[ $prompt == "n" || $prompt == "N" || $prompt == "no" || $prompt == "No" ]]
      then
        echo "Thank you"
      fi
    fi
  else
    echo "No such user"
  fi
elif [ $i = C ]
then
  clear
  echo "                  ***                              ***  "
  echo " You have chosen -->> Change user's Home Directory <<-- "
  echo "                  ***                              ***  "
  echo
  echo "Please enter the User's name"
  echo
  read UNAME
  UVER=`cut -d : -f1 /etc/passwd | grep $UNAME`
  if [[ $UNAME = $UVER ]]
  then
    echo
    echo "Please enter the  directory for $UNAME with absolute path"
    read HDIR
    echo
    usermod -m -d $HDIR $UNAME
    CHECK=`ls -l $HDIR/../ | grep $UNAME | awk '{print $9}'`
    if [[ $CHECK = $UNAME ]]
    then
      echo "Home directory of $UNAME has been changed successfully"
    else
      echo "Problem changing $UNAME's home directory"
      exit
    fi
  else
    echo "No such user"
    exit
  fi
elif [ $i = D ]
then
  clear
  echo "                  ***                          ***  "
  echo " You have chosen -->> Restrict a user to login <<-- "
  echo "                  ***                          ***  "
  echo
  echo "Please enter the Users name"
  echo
  read UNAME
  UVER=`cut -d : -f1 /etc/passwd | grep $UNAME`
  if [ $UNAME = $UVER ]
  then
    echo
    usermod -s /sbin/nologin $UNAME
  else
    echo "No such user"
    exit
  fi
else [ $i = E ]
  echo "You have chosen to quit User Modification"
  exit
fi

}

###############################
###  Main code starts here  ###
###############################

clear
echo "Please enter your name"
read name
echo "Hello $name, Thank you for using $MyScriptName"
echo "Today is `date +%d-%m-%Y--%r`"
echo "+----------------------------------------------------------------------------------+"
echo "| +------------------------------------------------------------------------------+ |"
echo "| |     This script can be used for Interactive and Automated user creation      | |"
echo "| +------------------------------------------------------------------------------+ |"
echo "|                        +--------------------------------+                        |"
echo "|                        | A. Create user by your choice  |                        |"
echo "|                        | B. Create user by using a file |                        |"
echo "|                        | C. Modify user credentials     |                        |"
echo "|                        | D. Quit                        |                        |"
echo "|                        +--------------------------------+                        |"
echo "+----------------------------------------------------------------------------------+"

read i
echo
if [ $i = A ]
then
  clear
  echo "                     ***                       *** "
  echo " You have chosen  -** Create user by your choice **-"
  echo "                     ***                       *** "
  echo
  userbychoice ;
elif [ $i = B ]
then
  clear
  echo "                    ***                        *** "
  echo " You have chosen -** Create user by using a file **- "
  echo "                    ***                        *** "
  echo
  userfromfile;
  echo "$COUNT users has been created successfully"
elif [ $i = C ]
then
  clear
  echo "                    ***                     *** "
  echo " You have chosen  -** Modify user credentials **- "
  echo "                    ***                     *** "
  echo
  usermodif;
elif [ $i = D ]
then
  clear
  echo "                    ***      *** "
  echo " You have chosen  -**   Quit   **- "
  echo "                    ***      *** "
  echo " Exiting from the script "
  exit
fi

#########  End of Script  #########
