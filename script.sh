#!/bin/bash

echo "Welcome to the DNS Server Update Script!"

while true
 do
  read -p "Print the A record: " newdns
  if [[ "$newdns" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]
   then
    echo "Accepted: $newdns"
    break
   else
    echo "Error: only lowercase letters, numbers and hyphens (-) can be used. Try again."
   fi
done

while true
 do
  read -p "Print the IP address: " newip
  if [[ "$newip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
   then
    IFS='.' read -r -a octets <<< "$newip"
    if (( octets[0] <= 255 && octets[1] <= 255 && octets[2] <= 255 && octets[3] <= 255 ))
     then
      echo "Accepted: $newip"
      break
    fi
  fi
  echo "Error: Enter a valid IP addres (for example, 192.168.0.50)"
done

dir="$(dirname "$(readlink -f "$0")")"
serial=$(cat "$dir/serial")
newserial=$((serial + 1))
ptr=${newip: -2}

sed -i "s/$serial/$newserial/g" "/etc/bind/db.dxniq.ru"
sed -i "s/$serial/$newserial/g" "/etc/bind/db.192"

echo "$newdns	IN	A	$newip" >> /etc/bind/db.dxniq.ru
echo "$ptr	IN      PTR     "$newdns".dxniq.ru." >> /etc/bind/db.192

echo $newserial > $dir/serial

systemctl restart bind9

echo "Comlete!"
