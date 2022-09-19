#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/ryzvpn/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m" 
export COLOR1="$(cat /etc/ryzvpn/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/ryzvpn/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########

echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Remove Old Script"
rm /root/install-up.sh
rm /usr/bin/menu

sleep 2
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Downloading New Script"
#wget -q -O /usr/bin/FILENAME "https://raw.githubusercontent.com/ryz-code/update/master/update_file/FILENAME" && chmod +x /usr/bin/FILENAME
#wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/ryz-code/update/master/update-file/menu.sh" && chmod +x /usr/bin/menu
wget -q -O /usr/bin/menu "https://gist.githubusercontent.com/ryz-code/raw/552f1f032594f63d32d59c43a71ce592287c7832/menu.sh" && chmod +x /usr/bin/menu
sleep 2
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Download Changelog File"
wget -q -O /root/changelog.txt "https://raw.githubusercontent.com/ryz-code/update/master/update_file/changelog.txt" && chmod +x /root/changelog.txt
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Read Changelog? ./root/changelog.txt"
sleep 2
