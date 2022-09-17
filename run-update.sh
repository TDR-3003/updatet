#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
echo -e " [INFO] Mengunduh File Pembaruan"
sleep 2
wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/ryz-code/autoscript-vpn/master/update/menu.sh" && chmod +x /usr/bin/menu
echo -e " [INFO] Perbarui Berhasil"
sleep 2
exit
