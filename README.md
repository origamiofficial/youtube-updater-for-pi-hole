# YouTube updater for Pi-hole

Quick and dirty script that may help with YouTube ads.

This is not ideal and not as good as running a proper ad blocker in a
browser, but for things like AppleTV it seems to work well enough. Every
time an ad slips through, it adds the offending hostname to the
hosts file in which we force an IP of our choosing.

N.B. You must block outgoing DNS from anything but your Pi-holes for maximum
effectiveness (even better, redirect to your Pi-hole!) 
Some apps have hard-coded DNS servers that will bypass your Pi-hole.
If you don't do this then use the script, please don't complain about ads
in, for example, your Samsung TV's YouTube app.
Read the manual for your network gateway device.

Avoid updating any official YouTube apps if possible.


### Install

**[Do all these as root]**

01 - Download the script to a sane area eg.: /usr/local/bin

02 - Make it executable. "chmod a+x youtube.update.sh"

*[steps 03-06 ensure you are using a geoip'd IP close to where you are]*

03 - Use the Pi-hole's "Query Log" function and seach for "googlevideo.com".

04 - Look for a hostname similar to "r6---sn-ni5f-tfbl.googlevideo.com"
     It won't match the example, but you will know one when you see one.
     You will likely have many matches, pick one at random.
     If you don't see any, watch some YouTube! :)

05 - Perform a name lookup on that hostname you found
     eg.: "nslookup r6---sn-ni5f-tfbl.googlevideo.com"

06 - Copy the IPv4 IP address it returns. 

07 - Edit the script, change the forceIP="123.456.789.999" to the real
     numbers you copied in step 5.

08 - Save it.

09 - Execute the script for the first time "./youtube.update.sh"

10 - Restart Pi-hole DNS "pihole restartdns"

11 - Automate it to run every minute for constant updates as new things slip
     through. I did mine in cron. "man cron" if you don't know how.


### Uninstall

01 - Remove the cron entry you created in Install.11.

02 - Remove the files the script created:
     "rm /etc/hosts.youtube /etc/dnsmasq.d/99-youtube.grublets.conf"

03 - Remove the script from wherever you saved it in Install.01


