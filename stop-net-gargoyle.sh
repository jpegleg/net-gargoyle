#!/bin/bash
ps auxwww | grep net-gargoyle | grep -v grep | grep -v vi | awk '{print $2}' | xargs kill -9
ps auxwww | grep "sec.pl --input=/var/log/net.log --conf=/etc/learner.cfg --log=/var/tmp/learner/learner.log --debug=6" | grep -v grep | awk '{print $2}' | xargs kill -9
ps auxwww | grep "--input=/var/log/new-catalog.log --conf=/etc/learner-watcher.cfg --log=/var/tmp/learner/learner-watcher.log" | grep -v grep | awk '{print $2}' | xargs kill -9
