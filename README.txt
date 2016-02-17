# net-gargoyle
Read the Simple Event Correlator documentation: https://simple-evcorr.github.io/

Monitor your network connections and create a catalog of connections with the pattern-learner template.

Pattern learner template: https://github.com/jpegleg/pattern-learner

Set up pattern learning but with these configs and sorter file.

Dependancies:
sec.pl callable from a /usr bin location like /usr/local/bin/

SEC documentation:
https://simple-evcorr.github.io/

Once running, the net-gargoyle will be collecting a catalog of connections it finds.
The learner-watcher.cfg daemon will email by default root@localhost with each unique IP
at least once. To trigger the emails again, you can remove the associated lock file

rm /var/tmp/learner/74.125.22.23.lock

You will find that sometimes you will need to lift the sorter lock. 
This can be needed for multiple reasons, one is that you need to trigger emails again:

rm /var/tmp/lock-catalog-sorter

Start up the net-gargoyle:

sudo ./start-net-gargoyle.sh

The stop doesn't really work yet:

sudo ./stop-net-gargoyle.sh

I have found I still have to clean up on of the child processes...

The connection collection happens at a default rate of 0.1 seconds 
per connection + (usually) small amount of time.  With that, 
it is to be noted that the collection only occurs at a rate of
  
  (N x 0.1)+(0.003) = seconds between runs of the net-gargoyle
  
and any activity that happens between those intervals 
will not be detected by a single gargoyle thread in that environment.

The net-gargoyle is good for connection auditing and alerting on 
small to mid scale operations and alerting for "firewall-less" environments. 

The benefit is how quick it is to get running on a system. 
I can have the net-gargoyle patrolling any linux system in less than 30 seconds.

Yes, it has a lot of file handles it uses. It uses the disk. But the catalog of ips is
amazingly useful and the alerting just once per occurrence unless you chose otherwise is awesome.

To manage the /var/log/net.log, I use cron and bubble-copter:

0 0 1 * * /usr/local/bin/bubc root@localhost /var/log/ && cp /dev/null /var/log/net.log

The code for bubc is here https://github.com/jpegleg/bubble-copter

You can run this script in threads by directory as long as you keep the job in pwd or ./  
...it uses a relative path unless you use the root install, which is a single thread managed
in a more secure way.

Example:

for x in {1..9}; do 
  mkdir "$x"; 
  cp net-gargoyle-master.zip "$x"/;
  cd "$x"/;
  unzip net-gargoyle-master.zip
  cd net-gargoyle-master
  chmod +x ./*
  cp /dev/null./learner-watcher.cfg
  ./net-gargoyle start &
  cd ../../
done
rm -f [1-9]/net-gargoyle-master/lock*

crontab -e

0 2 * * * cp /dev/null /tmp/1/net-gargoyle-master/net.log
0 3 * * * cp /dev/null /tmp/2/net-gargoyle-master/net.log
0 4 * * * cp /dev/null /tmp/3/net-gargoyle-msster/net.log
0 5 * * * cp /dev/null /tmp/4/net-gargoyle-master/net.log
0 6 * * * cp /dev/null /tmp/5/net-gargoyle-master/net.log
0 7 * * * cp /dev/null /tmp/6/net-gargoyle-master/net.log
0 8 * * * cp /dev/null /tmp/7/net-gargoyle-master/net.log
0 9 * * * cp /dev/null /tmp/8/net-gargoyle-master/net.log
0 15 * * * cp /dev/null /tmp/9/net-gargoyle-master/net.log
