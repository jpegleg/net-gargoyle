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
This can be needed for multiple reasons, one is that you need to trigger emails again.
I often have cron entries that remove this file, example:

rm /var/tmp/lock-catalog-sorter

Start up the net-gargoyle:

sudo net-gargoyle start

Stop net-gargoyle:

sudo net-gargoyle stop

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

Edit the files to use different paths etc as needed, if you are in a chroot jail etc.

Example management style with cron:


crontab -e

0 2 * * * cp /dev/null /var/tmp/learner/net.log
*/5 * * * *  rm /var/tmp/learner/lock-catalog-sorter
*/17 * * * * pkill -9 sorter
15 4 * * * cp /dev/null /var/tmp/learner/learner.log


This thing is wild, and is made for wild situations.
