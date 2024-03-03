#!/usr/bin/sh

# add file for user to /etc/sudoers.d/<username> to not require password with sudo

echo "Enter user for sudoers file creation:"
read -s userName

# check if root user
rootUser=$([[ $(id -u) -eq 0 ]] && echo "true" || echo "false")

if [ $rootUser == "false" ]; then
  # prompt for root password in loop until correct password is entered
  while true; do
    echo "Please enter root password"
    read -s rootPass
    # login as root using password
    echo $rootPass | su -c "echo '$userName ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$userName" root
    # check if command was successful
    # if successful, break loop
    if [ $? -eq 0 ]; then
      break
    else
      echo "Incorrect password"
    fi
  done
else
  echo "$userName ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$userName
fi


[[ ! $rootUser ]] && exit

