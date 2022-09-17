#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
echo -e " [INFO] Mengunduh File Pembaruan"
sleep 2
wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/ryz-code/autoscript-vpn/master/websocket/dropbear-ws.py
wget -O /usr/local/bin/ws-stunnel https://raw.githubusercontent.com/ryz-code/autoscript-vpn/master/websocket/ws-stunnel

chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel

wget -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/ryz-code/autoscript-vpn/master/websocket/service-wsdropbear && chmod +x /etc/systemd/system/ws-dropbear.service

wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/ryz-code/autoscript-vpn/master/websocket/ws-stunnel.service && chmod +x /etc/systemd/system/ws-stunnel.service
echo -e " [INFO] Perbarui Berhasil"
sleep 2
exit
