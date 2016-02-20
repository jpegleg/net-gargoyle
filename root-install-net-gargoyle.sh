#!/bin/sh
###################################################################################################
#                                                                                                 #
#   Install net-gargoyle, an adhoc network connection catalog and alerting system for Linux       #
#                                                                                                 #
###################################################################################################
#                   THIS SCRIPT WILL DO SILLY THINGS                                          \
# Edit the files and install them as a su would.                                               \
# Although if you can do this, you can probably install a firewall                              \
# that is more light weight that does the same thing but better, so... okay.                     \
# Another reason NOT to run this script is that using the files as is, will allow multi-threaded  \
# Runing this script will set it to be single threaded and run by root.                            \
################################################################################################### *
#                                                                                                 #
#   If this script has been run before (.pre-edit files exit) then you can restore them with $1   #
#                                                                                                 #
###################################################################################################
if [ "$1"="restore" ]; then
  cp sorter.pre-editsorter;
  cp learner.cfg learner.cfg.pre-edit;
  cp net-gargoyle.pre-edit net-gargoyle;
  cp net-gargoyle-sec.pre-edit net-gargoyle-sec;
else
  echo "Not restoring .pre-edits...";
fi
################################################################################################### *
#                                                                                                 #
#   Check to see if "ss" is available, otherwise revert to the deprecated netstat.                #
#                                                                                                 #
###################################################################################################
if [ -f /bin/ss ]; then
  echo "using ss"
else
  echo "looking for netstat instead, shame on you";
  if [ -f /bin/netstat ]; then
    echo "found netstat."
    echo "updating net-gargoyle..."
    sed -i 's/ss\ \-an/netstat\ \-tan/g' gargoyle
  else
    echo "ss or netstat not found in /bin/";
    echo "FATAL ERROR";
    exit 1;
  fi
fi
###################################################################################################
#                                                                                                 #
#   Edit the files to use /var/tmp/learner /etc /usr/local/bin and /var/log like a normal admin.  #
#                                                                                                 #
###################################################################################################
if [ $(whoami) -eq root]; then
  echo "Running as root"
else
  echo "Running as $(whoami) - might not work unless you have sudo access."
fi
if [ -f ./sorter.pre-edit]; then
  echo "Already backed up sorter.";
else
  cp sorter sorter.pre-edit;
  cp learner.cfg learner.cfg.pre-edit;
  cp net-gargoyle net-gargoyle.pre-edit;
  cp net-gargoyle-sec net-gargoyle-sec.pre-edit;
  sed -i 's/\=\./\/=\/var\/tmp\/learner/g' sorter
  sed -i 's/\./\/=\/var\/usr\/local\/bin/g' learner.cfg
  sed -i 's/\=\./\/=\/var\/tmp\/learner/g' net-gargoyle
  sed -i 's/\=\./\/=\/var\/tmp\/learner/g' net-gargoyle-sec
fi
###################################################################################################
#                                                                                                 #
#                     Alright, install the files.                                                 #
#                                                                                                 #
###################################################################################################
chmod +x sorter
chmod +x ./*sh
mkdir -p /var/tmp/learner
touch /var/log/net.log
touch /var/log/catalog.log
cp learner.cfg /etc/
cp learner-watcher.cfg /etc/
cp sorter /usr/local/bin/
cp net-gargoyle /usr/local/bin
chmod +x /usr/local/bin/sorter
chmod +x /usr/local/bin/net-gargoyle
