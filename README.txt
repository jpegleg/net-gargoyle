# net-gargoyle
Read the Simple Event Correlator documentation: https://simple-evcorr.github.io/

Monitor your network connections and create a catalog of connections with the pattern-learner template.

Pattern learner template: https://github.com/jpegleg/pattern-learner

Set up pattern learning but with these configs and sorter file.

Dependancies:
sec.pl callable from a /usr bin location like /usr/local/bin/

SEC documentation:
https://simple-evcorr.github.io/

Start up the net-gargoyle:
sudo ./start-net-gargoyle.sh

The stop doesn't really work yet:
sudo ./stop-net-gargoyle.sh

I have found I still have to clean up on of the child processes.

The connection collection happens at a default rate of 0.1 seconds 
per connection + (usually) small amount of time.  With that, 
it is to be noted that the collection only occurs at a rate of
  
  (Nx0.1)+(0.003) = seconds between runs of the net-gargoyle
  
and any activity that happens between those intervals 
will not be detected by a single gargoyle thread in that environment.
