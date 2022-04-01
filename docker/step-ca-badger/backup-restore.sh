#!/bin/sh -e

export DB_HOME=/home/step/db
export RESTORE_FILE=$DB_HOME/restore/badger-db.bak

mkdir -p $DB_HOME/backup
echo Backup of database
badger backup --dir $DB_HOME -f $DB_HOME/backup/badger-db.bak
echo Backup done.

if [ -e $RESTORE_FILE ]
then
  echo Found restore file. Starting restore of database
  echo Remove old database if any
  if [ -e $DB_HOME/*.vlog ]
  then
    rm $DB_HOME/* || true
  fi
  badger restore --dir $DB_HOME -f $RESTORE_FILE
  # Move restore file after update of database to avoid restoring database more than once 
  mv $RESTORE_FILE $DB_HOME/restore/badger-db-restored.bak
  echo "Restore done. Restore file moved to $DB_HOME/restore/badger-db-restored.bak"
fi