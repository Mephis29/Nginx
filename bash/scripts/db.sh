#! /bin/bash

command=$1

function chooseCommand()
{
  case $command in
    "add" )
      createUsernameRole ;;
    "backup" )
      createBackup ;;
    * | help )
      touch ../data/users.db
      echo "Available commands: add, backup, find, list" ;;
  esac
}

function createUsernameRole()
{
    echo "Please enter username"
    read username
    echo "Please enter role"
    read role
    echo $username, $role >> ../data/users.db
}

function createBackup()
{
  date=$(date +%m-%d-%Y)
  cp ../data/users.db ../data/"$date"-users.db.backup
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
