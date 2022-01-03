#!/bin/bash

SELF_FULL_PATH=$(readlink -f $0)
DEFAULT_BIN_PATH=/usr/local/bin/unarchiverr

if [[ $# == 1 ]]; then
  TARGET_DIR=$1
  if [[ ! -d $TARGET_DIR ]]; then
    echo "target_dir ($TARGET_DIR) is not a directory!"
    ls -ld $TARGET_DIR
    exit 1
  fi
else
  echo "usage: setup.sh <target_dir>"
  exit 1
fi

check_crontab() {
  echo
  echo "--------CRONJOBS---------"
  crontab -l
  echo "-----END-OF-CRONJOBS-----"
  echo
}

echo "Checking for binary..."
if [[ ! -f $DEFAULT_BIN_PATH && ! -L $DEFAULT_BIN_PATH ]]; then
  echo "Creating symlink to binary in this repo..."
  ln -s $(dirname $SELF_FULL_PATH)/unarchiverr $DEFAULT_BIN_PATH
  if [[ $? == 0 ]]; then
    echo "Symlink created."
  else
    echo "Failed to create symlink!"
    ls -l $DEFAULT_BIN_PATH
    exit 1
  fi
else
  if [[ -f $DEFAULT_BIN_PATH ]]; then
    echo "Found a file at default binary path. Expected symlink. Exiting."
    exit 1
  fi
  if [[ -L $DEFAULT_BIN_PATH ]]; then
    echo "Symlink found. Skipping."
  fi

fi

echo "Checking for cronjob..."
if [[ $(crontab -l | grep unarchiverr | wc -l) > 0 ]]; then
  echo "Found cronjob matching \"unarchiverr\". Exiting."
  check_crontab
  exit 1
else
  echo "No matching cronjob found. Creating..."
  echo "(crontab -l; echo '* * * * * /usr/local/bin/unarchiverr $TARGET_DIR \| /usr/bin/logger -t unarchiverr') | crontab -"
  echo "cronjob created."
  check_crontab
fi