#!/bin/sh

net-gargoyle &
echo $! > /var/run/net-gargoyle.pid
