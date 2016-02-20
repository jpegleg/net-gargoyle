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
  cp sorter.pre-edit sorter;
  cp $(ls -lath gargoyle.pre-edit* | rev | tail -n 1 | cut -d' ' -f1 | rev) gargoyle
  cp learner.cfg learner.cfg.pre-edit;
  cp net-gargoyle.pre-edit net-gargoyle;
  cp net-gargoyle-sec.pre-edit net-gargoyle-sec;
  exit 0;
else
  echo "Not restoring .pre-edits...";
fi
################################################################################################### *
#                                                                                                 #
#   Check to see if "ss" is available, otherwise revert to the deprecated netstat.                #
#                                                                                                 #
###################################################################################################
if [ -f gargoyle.pre-edit ]; then
  echo "found a gargoyle.pre-edit in $(pwd)..."
  echo "WARNING: the script has been run once before"
  cp gargoyle.pre-edit gargoyle.pre-edit.$(echo $RANDOM)
  echo "Make additional backup of $(ls -larth gargoyle.pre-edit.*)"
  echo "Now overwritting gargoyle.pre-edit with gargoyle..."
  cp gargoyle gargoyle.pre-edit;
else
  cp gargoyle gargoyle.pre-edit;
fi
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
if [ $(whoami) -eq root ]; then
  echo "Running as root"
else
  echo "Running as $(whoami) - might not work unless you have sudo access."
fi
if [ -f ./sorter.pre-edit ]; then
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
###################################################################################################
#                                                                                                 #
#                     Make sure things worked...                                                  #
#                                                                                                 #
###################################################################################################
if [ -f /usr/local/bin/net-gargoyle ]; then
  echo "$(md5sum /usr/local/bin/net-gargoyle; ls -larth /usr/local/bin/net-gargoyle)"
  echo "Found net-gargoyle installed to /usr/local/bin/"
else
  echo "net-gargoyle not found in /usr/local/bin! Something went wrong."
  echo "You will likely need to start from the beginning."
  echo "Or, do a custom install..."
  echo "If you don't have permission to root install, run the script like this now to undo the changes for root to the code and get started:";
  echo "./root-install-net-gargoyle.sh restore";
  echo "./net-gargoyle start";
  exit 1
fi
