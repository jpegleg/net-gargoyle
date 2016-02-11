#!/bin/sh

net-gargoyle &
echo $! > /var/run/net-gargoyle.pid

sec.pl --input=/var/log/net.log --conf=/etc/learner.cfg --log=/var/tmp/learner/learner.log --debug=6 --detach

sec.pl --input=/var/log/new-catalog.log --conf=/etc/learner-watcher.cfg --log=/var/tmp/learner/learner-watcher.log --detach
