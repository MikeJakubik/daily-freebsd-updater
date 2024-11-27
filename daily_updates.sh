#!/usr/bin/env bash
reset && clear

if [ "$EUID" -ne 0 ]
  then
  tput bold
  echo "Please run as root"
  tput sgr0
  exit
fi

tput bold
echo
echo "[ Updating /usr/ports git tree... ]"
echo
tput sgr0
cd /usr/ports && git pull

tput bold
echo
echo "[ Updating /usr/src git tree... ]"
echo
tput sgr0
cd /usr/src && git pull

tput bold
echo
echo "[ Updating FreeBSD pkg repos... ]"
echo
tput sgr0
pkg update
echo

tput bold
echo "[ Cleaning port distfiles... ]"
echo
tput sgr0
/usr/local/sbin/portmaster -y --clean-distfiles

tput bold
echo "[ Cleaning stale port packages... ]"
echo
tput sgr0
/usr/local/sbin/portmaster -y --clean-packages

tput bold
echo "[ Checking for stale entries in /var/db/ports... ]"
echo
tput sgr0
/usr/local/sbin/portmaster -v --check-port-dbdir

tput bold
echo "[ Checking portmaster for any upgrades... ]"
echo
tput sgr0
/usr/local/sbin/portmaster -adyG

tput bold
echo "[ All done! ]"
echo
tput sgr0
