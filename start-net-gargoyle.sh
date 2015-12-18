#!/bin/sh

net-gargoyle
echo $! > /var/run/net-gargoyle.pid

sec.pl --input=/var/log/net.log --cfg=/etc/learner.cfg --log=/var/tmp/learner/learner.log --debug=6 --detach
echo $! > /var/run/learner.pid

sec.pl --input=/var/log/new-catalog.log --cfg=/etc/learner-watcher.cfg --log=/var/tmp/learner/learner-watcher.log --detach
echo $! > /var/run/leanrner-watcher.pid
