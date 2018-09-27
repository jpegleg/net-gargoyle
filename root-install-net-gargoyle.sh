#!/bin/sh
###################################################################################################
#                                                                                                 #
#   Install net-gargoyle, an adhoc network connection catalog and alerting system for Linux       #
#                                                                                                 #
###################################################################################################
chmod +x sorter
chmod +x ./*sh
mkdir -p /var/tmp/learner
touch /var/tmp/learner/net.log
touch /var/tmp/learner/catalog.log
cp learner.cfg /etc/
cp learner-watcher.cfg /etc/
cp sorter /usr/local/bin/
cp gargoyle /usr/local/bin
cp net-gargoyle /usr/local/bin
cp net-gargoyle-sec /usr/local/bin
chmod +x /usr/local/bin/sorter
chmod +x /usr/local/bin/net-gargoyle
chmod +x /usr/local/bin/gargoyle
chmod +x /usr/local/bin/net-gargoyle-sec
