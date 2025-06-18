#!/usr/bin/env sh

IP=$(curl ipinfo.io/ip)

# Save the IP address
echo "$IP" >> ~/ip.txt
awk '!seen[$0]++' ~/ip.txt > ~/ip.txt.next
mv ~/ip.txt.next ~/ip.txt
