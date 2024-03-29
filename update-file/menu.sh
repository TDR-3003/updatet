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
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )


BURIQ () {
    curl -sS https://raw.githubusercontent.com/ryz-code/izin-vps/master/ipvps > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/ryz-code/izin-vps/master/ipvps | grep $MYIP | awk '{print $2}')
Isadmin=$(curl -sS https://raw.githubusercontent.com/ryz-code/izin-vps/master/ipvps | grep $MYIP | awk '{print $5}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Izin Diterima..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/ryz-code/izin-vps/master/ipvps | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Izin Ditolak!"
    fi
    BURIQ
}

x="ok"


PERMISSION

if [ "$res" = "Expired" ]; then
Exp="\e[36mExpired\033[0m"
rm -f /home/needupdate > /dev/null 2>&1
else
Exp=$(curl -sS https://raw.githubusercontent.com/ryz-code/izin-vps/master/ipvps | grep $MYIP | awk '{print $3}')
fi
export RED='\033[0;31m'
export GREEN='\033[0;32m'

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${GREEN}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi

# // nginx
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# // SSH Websocket Proxy
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi

function add-host(){
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${COLBG1}                    • UPDATE SCRIPT VPS •                 ${NC}"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -rp "  Nama Host Baru : " -e host
echo ""
if [ -z $host ]; then
echo -e "  [INFO] Ketik Domain/sub domain Anda"
echo ""
read -n 1 -s -r -p "  Tekan tombol apa saja untuk kembali ke menu"
menu
else
echo "IP=$host" > /var/lib/ryzvpn-premiun/ipvps.conf
echo ""
echo "  [INFO] Jangan lupa untuk memperbaharui cert"
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "  Tekan tombol apa saja untuk Perbarui Cert"
crtxray
fi
}
function updatews(){
clear

echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${COLBG1}                    • UPDATE SCRIPT VPS •                 ${NC}"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " $COLOR1[INFO]${NC} Periksa Update Script"
sleep 2
wget -q -O /root/install_up.sh "https://raw.githubusercontent.com/ryz-code/update/master/install_up.sh" && chmod +x /root/install_up.sh
sleep 2
./install_up.sh
sleep 5
rm /root/install_up.sh
rm /opt/.ver
version_up=$( curl -sS https://raw.githubusercontent.com/ryz-code/update/master/version_up)
echo "$version_up" > /opt/.ver
echo -e " $COLOR1[INFO]${NC} Berhasil Update Ke Versi Terbaru!"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -n 1 -s -r -p "  Tekan tombol apa saja untuk kembali ke menu"
menu
}
clear
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${COLBG1}                    • VPS PANEL MENU •                    ${NC}"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )
serverV=$( curl -sS https://raw.githubusercontent.com/ryz-code/update/master/version_up)
if [ "$Isadmin" = "ON" ]; then
uis="${GREEN}Pengguna Premium$NC"
else
uis="${RED}Trial$NC"
fi
echo -e "User Status     : $uis"
if [ "$cekup" = "day" ]; then
echo -e "System Uptime  : $uphours $upminutes $uptimecek"
else
echo -e "System Uptime  : $uphours $upminutes"
fi
echo -e "Memory Usage   : $uram / $tram"
echo -e "ISP & City     : $ISP & $CITY"
echo -e "Current Domain : $(cat /etc/xray/domain)"
echo -e "IP-VPS         : ${COLOR1}$IPVPS${NC}"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${COLBG1}                    • VPS PANEL MENU •                    ${NC}"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${COLOR1}[01]${NC} • SSHWS          ${COLOR1}[08]${NC} • BACKUP "   
echo -e "  ${COLOR1}[02]${NC} • VMESS          ${COLOR1}[09]${NC} • ADD HOST/DOMAIN   "  
echo -e "  ${COLOR1}[03]${NC} • VLESS          ${COLOR1}[10]${NC} • RENEW CERT"  
echo -e "  ${COLOR1}[04]${NC} • TROJAN         ${COLOR1}[11]${NC} • SETTINGS"  
echo -e "  ${COLOR1}[05]${NC} • SS WS          ${COLOR1}[12]${NC} • INFO "
echo -e "  ${COLOR1}[06]${NC} • SET DNS        ${COLOR1}[13]${NC} • REG IP     "
if [ "$Isadmin" = "ON" ]; then
echo -e "  ${COLOR1}[07]${NC} • THEME          ${COLOR1}[14]${NC} • SET BOT  "
ressee="menu-ip"
bottt="menu-bot"
else
ressee="menu"
bottt="menu"
fi
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
myver="$(cat /opt/.ver)"

if [[ $serverV > $myver ]]; then
echo -e " ${COLOR1}[100]${NC} • UPDATE TO V$serverV"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
up2u="updatews"
else
up2u="menu"
fi

DATE=$(date +'%d %B %Y')
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo -e " Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""

echo -e "Version     :${COLOR1} $(cat /opt/.ver) Latest Version${NC}"
echo -e "Client Name : $Name"
if [ $exp \> 1000 ];
then
    echo -e "License     : Lifetime"
else
    datediff "$Exp" "$DATE"
fi;
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━ BY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${COLBG1}                    • RYZ STORE VPN •                     ${NC}"
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
echo -ne " Pilih menu : "; read opt
case $opt in
01 | 1) clear ; menu-ssh ;;
02 | 2) clear ; menu-vmess ;;
03 | 3) clear ; menu-vless ;;
04 | 4) clear ; menu-trojan ;;
05 | 5) clear ; menu-ss ;;
06 | 6) clear ; menu-dns ;;
06 | 7) clear ; menu-theme ;;
07 | 8) clear ; menu-backup ;;
09 | 9) clear ; add-host ;;
10) clear ; crtxray ;;
11) clear ; menu-set ;;
12) clear ; info ;;
13) clear ; $ressee ;;
14) clear ; $bottt ;;
100) clear ; $up2u ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
