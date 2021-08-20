#! /bin/bash

command=$1

function chooseCommand()
{
  case $command in
    "add" )
      createUsernameRole ;;
    "backup" )
      createBackup ;;
    "restore" )
      restoreBackup ;;
    * | help )
      touch ../data/users.db
      echo "Available commands: add, backup, find, list" ;;
  esac
}

function createUsernameRole()
{
    echo -en '\n'
    echo "Please enter username"
    read username
    echo "Please enter role"
    read role
    while ! [[ "${username}" =~ ^[a-z]$ ]] && ! [[ "${role}" =~ ^[a-z]$ ]]; do
      echo -en '\n'
      echo "Syntax is incorrect, please enter only latin letters"
      echo "Please enter username"
      read username
      echo "Please enter role"
      read role
    done
    echo $username, $role >> ../data/users.db
}

function createBackup()
{
  date=$(date +%m-%d-%Y)
  cp ../data/users.db ../data/"$date"-users.db.backup
}

function restoreBackup()
{
arr=($ls ../data/*.backup)
echo ${arr[1]}

#[[ FILE1 -nt FILE2 ]]	1 is more recent than 2
}

if [ -f "../data/users.db" ]
  then
    chooseCommand
  else
    echo "Would you like to create users.db?"
    select answer in Yes No
    do
      if [ "$answer" == "Yes" ]
      then
        chooseCommand
        break
      else
        break
      fi
    done
fi
