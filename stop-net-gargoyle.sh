#!/bin/bash
ps auxwww | grep net-gargoyle | grep -v grep | grep -v vi | awk '{print $2}' | xargs kill -9
