#!/bin/bash

# crappy hack that seems to keep YouTube ads to a minumum.
# over two hours of Peppa Pig and no ads. Taking one for the team...
# grub@grub.net v0.11

# Change forceIP to the real IP from an nslookup of a 
# googlevideo hostname so you get something in your 
# geographical region. You can find one in your
# Pi-hole's query logs.
# They will look something like this:
#     r6---sn-ni5f-tfbl.googlevideo.com

# as root: run this once then run "pihole restartdns"
# You can cron this for auto-updating of the host file.
# Mine fires every minute:
# * * * * * /home/grub/bin/youtube.update.sh 2>&1

forceIP="123.456.789.999"

# nothing below here should need changing

piLogs="/var/log/pihole.log"
ytHosts="/etc/hosts.youtube"

workFile=$(mktemp)
dnsmasqFile="/etc/dnsmasq.d/99-youtube.grublets.conf"

if [ ! -f $dnsmasqFile ]; then
    echo "addn-hosts=$ytHosts" > $dnsmasqFile
    touch $ytHosts
    piLogs="$piLogs*" # preload with results from all logs
    echo "Setup complete! Execute 'pihole restartdns' as root."
    echo "cron the script to run every minute or so for updates."
fi

cp $ytHosts $workFile
zgrep -e "reply.*-.*\.googlevideo.*\..*\..*\..*" $piLogs \
    | awk -v fIP=$forceIP '{ print fIP, $6 }' >> $workFile

sort -u $workFile -o $workFile

if ! cmp $workFile $ytHosts; then
    mv $workFile $ytHosts
    chmod 644 $ytHosts	
    /usr/local/bin/pihole restartdns reload
else
    rm $workFile
fi


exit
