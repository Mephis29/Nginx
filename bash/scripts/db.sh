#! /bin/bash

if [[ $1 && $2 ]]; then
command="$1 $2"
else
  command="$1"
fi

function initial()
{
  if [[ -f "../data/users.db" ]]; then
      chooseCommand
    else
      echo "Would you like to create users.db?"
      select answer in Yes No
        do
          if [ "$answer" == "Yes" ]; then
            touch ../data/users.db
            chooseCommand
            break
          else
            break
          fi
        done
  fi
}

function chooseCommand()
{
  case $command in
    "add" )
      createUsernameRole ;;
    "backup" )
      createBackup ;;
    "restore" )
      restoreBackup ;;
    "find" )
      findUsername ;;
    "list" )
      listData ;;
    "list inverse" )
      listDataInverse ;;
    * | "help" )
      echo -e "Available commands:
      add: add username and role,
      backup: create backup,
      restore: last backup replace users.db,
      find: find username and role,
      list: prints contents of users.db,
      list inverse: prints inverse contents of users.db" ;;
  esac
}

function createUsernameRole()
{
  echo -en '\n'
  echo "Please enter username"
  read username
  echo "Please enter role"
  read role
  until [[ "${username}" =~ [A-Za-z]$ && "${role}" =~ [A-Za-z]$ ]]; do
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
  local date=$(date +%m-%d-%Y)
  cp ../data/users.db ../data/"$date"-users.db.backup
}

function restoreBackup()
{
#  Как написать проверку условия проще?
  if [[ ! $(find ../data -type f -name "*.backup") ]]; then
      echo "No backup file found"
      return
    else
      local arr=($(ls ../data/*.backup))
      local backupRecent=${arr[0]}
      for ((i = 1 ; i < ${#arr[@]} ; i++)); do
        if [[ ${arr[i]} -nt $backupRecent ]]; then
         local backupRecent=${arr[i]}
        fi
      done
      cp ../data/$backupRecent ../data/users.db
  fi
}

function findUsername()
{
  echo -en '\n'
  echo "Please enter username"
  read username
  if [[ $(grep -i -n $username ../data/users.db) ]]; then
      echo -en '\n'
      grep -i -n $username ../data/users.db
    else
      echo -en '\n'
      echo "User not found"
  fi
}

function listData()
{
  echo -en '\n'
  readarray arr < ../data/users.db
  for ((i = 0 ; i < ${#arr[@]} ; i++)); do
    echo "$i.${arr[i]}"
  done
}

function listDataInverse()
{
  echo -en '\n'
  readarray arr < ../data/users.db
  for ((i = ${#arr[@]} ; i > 0 ; i--)); do
    echo "$i.${arr[i-1]}"
  done
}

initial
