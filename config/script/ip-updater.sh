#!/bin/sh

IP=$(curl ipinfo.io/ip)

# Save the IP address
echo "$IP" >> ~/ip.txt
awk '!seen[$0]++' ~/ip.txt > ~/ip.txt.next
mv ~/ip.txt.next ~/ip.txt

# Update OVH
curl -m 5 -L --location-trusted \
	--user "$LOGIN:$PASSWORD" \
	"https://www.ovh.com/nic/update?system=dyndns&hostname=dionysus.kielbowi.cz&myip=$IP"
