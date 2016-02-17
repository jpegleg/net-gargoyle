#!/bin/sh
if [ -f ./sorter.pre-edit]; then
  echo "Already backed up sorter.";
else
  cp sorter sorter.pre-edit;
  sed -i 's/=./=\/var\/log.g' sorter
fi
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
