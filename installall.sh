clear
echo "   1. Cài đặt"
echo "   2. update config"
echo "   3. thêm node"
read -p "  Vui lòng chọn một số và nhấn Enter (Enter theo mặc định Cài đặt):  " num
[ -z "${num}" ] && num="1"



install_1(){
  clear
 read -p " Nhập domain web (không cần https://):" api_host
    [ -z "${api_host}" ] && api_host=0
    echo "--------------------------------"
  echo "Bạn đã chọn https://${api_host}"
  echo "--------------------------------"
  #key web
  read -p " Nhập key web :" api_key
    [ -z "${api_key}" ] && api_key=0
  echo "--------------------------------"
  echo "Bạn đã chọn https://${api_host}"
  echo "--------------------------------"
  #IP vps
#  read -p "Nhập ip vps :" CertDomain
#   [ -z "${CertDomain}" ] && CertDomain="0"
#  echo "-------------------------------"
#   echo "ip vps : ${CertDomain}"
#  echo "-------------------------------"



  pre_install
}
pre_install(){
 clear
		read -p "Nhập số node cần cài và nhấn Enter (tối đa 2 node): " n
	 [ -z "${n}" ] && n="1"
    if [ "$n" -ge 2 ] ; then 
    n="2"
    fi
    a=0
  while [ $a -lt $n ]
do
echo -e "node thứ $((a+1))"


 echo -e "[1] Vmess"
 echo -e "[2] Vless"
  echo -e "[3] trojan"
  echo -e "[4] Shadowsocks"
  read -p "chọn kiểu node(mặc định là v2ray):" NodeType
  if [ "$NodeType" == "1" ]; then
    NodeType="V2ray"
    NodeName="Vmess"
    EnableVless="false"
  elif [ "$NodeType" == "2" ]; then
    NodeType="V2ray"
    NodeName="Vless"
    EnableVless="true"
  elif [ "$NodeType" == "3" ]; then
    NodeType="Trojan"
    NodeName="Trojan"
    EnableVless="false"
  elif [ "$NodeType" == "4" ]; then
    NodeType="Shadowsocks"
    NodeName="Shadowsocks"
    EnableVless="false"
  else
    NodeType="V2ray"
    EnableVless="false"
  fi
  echo "Bạn đã chọn $NodeName"
  echo "--------------------------------"


  #node id
    read -p " ID nút (Node_ID):" node_id
  [ -z "${node_id}" ] && node_id=0
  echo "-------------------------------"
  echo -e "Node_ID: ${node_id}"
  echo "-------------------------------"



  

  

 config
  a=$((a+1))
done
}


#clone node
clone_node(){
  clear
  # Gán giá trị mặc định cho api_host và api_key
  api_host="minhanhvpn.com"
  api_key="minhanhvpn050503"

  echo "--------------------------------"
  echo "Bạn đã chọn https://${api_host}"
  echo "--------------------------------"

  echo "--------------------------------"
  echo "Bạn đã chọn key web: ${api_key}"
  echo "--------------------------------"

#node type
  
 echo -e "[1] Vmess"
 echo -e "[2] Vless"
  echo -e "[3] trojan"
  echo -e "[4] Shadowsocks"
  read -p "chọn kiểu node(mặc định là v2ray):" NodeType
  if [ "$NodeType" == "1" ]; then
    NodeType="V2ray"
    EnableVless="false"
  elif [ "$NodeType" == "2" ]; then
    NodeType="V2ray"
    EnableVless="true"
  elif [ "$NodeType" == "3" ]; then
    NodeType="Trojan"
    EnableVless="false"
  elif [ "$NodeType" == "4" ]; then
    NodeType="Shadowsocks"
    EnableVless="false"
  else
    NodeType="V2ray"
    EnableVless="false"
  fi
  echo "Bạn đã chọn $NodeType"
  echo "--------------------------------"


  #node id
    read -p " ID nút (Node_ID):" node_id
  [ -z "${node_id}" ] && node_id=0
  echo "-------------------------------"
  echo -e "Node_ID: ${node_id}"
  echo "-------------------------------"
  
  

  
#   #IP vps
#  read -p "Nhập domain :" CertDomain
#   [ -z "${CertDomain}" ] && CertDomain="0"
#  echo "-------------------------------"
#   echo "ip : ${CertDomain}"
#  echo "-------------------------------"


 config
  
 
}







config(){
cd /etc/XrayR
cat >>config.yml<<EOF
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, , Proxypanel
    ApiConfig:
      ApiHost: "https://$api_host"
      ApiKey: "$api_key"
      NodeID: $node_id
      NodeType: $NodeType # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: $EnableVless # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      DisableSniffing: True # Disable domain sniffing
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: file # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "8.8.8.8" # Domain to cert
        CertFile: /etc/XrayR/4ghatde.crt # Provided if the CertMode is file
        KeyFile: /etc/XrayR/4ghatde.key
        Provider: alidns # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
EOF

#   sed -i "s|ApiHost: \"https://domain.com\"|ApiHost: \"${api_host}\"|" ./config.yml
 # sed -i "s|ApiKey:.*|ApiKey: \"${ApiKey}\"|" 
#   sed -i "s|NodeID: 41|NodeID: ${node_id}|" ./config.yml
#   sed -i "s|DeviceLimit: 0|DeviceLimit: ${DeviceLimit}|" ./config.yml
#   sed -i "s|SpeedLimit: 0|SpeedLimit: ${SpeedLimit}|" ./config.yml
#   sed -i "s|CertDomain:\"node1.test.com\"|CertDomain: \"${CertDomain}\"|" ./config.yml
 }

case "${num}" in
1) bash <(curl -Ls https://raw.githubusercontent.com/qtai2901/XrayR-release/main/install.sh)
openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/XrayR/4ghatde.crt -keyout /etc/XrayR/4ghatde.key -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Google Trust Services LLC/CN=google.com"
cd /etc/XrayR
  cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnetionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB 
Nodes:
EOF
install_1

cd /root
xrayr start
 ;;
 2) cd /etc/XrayR
cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnetionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB 
Nodes:
EOF

install_1
cd /root
xrayr restart
 ;;
 3) cd /etc/XrayR
 clone_node
 cd /root
  xrayr restart
;;
esac

#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Lỗi：${plain} Tập lệnh này phải được chạy bằng root!\n" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}Phiên bản hệ thống không được phát hiện, vui lòng liên hệ với tác giả kịch bản!${plain}\n" && exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64-v8a"
elif [[ $arch == "s390x" ]]; then
    arch="s390x"
else
    arch="64"
    echo -e "${red}Không phát hiện được kiến ​​trúc, sử dụng kiến ​​trúc mặc định: ${arch}${plain}"
fi

echo "Cấu trúc hệ điều hành: ${arch}"

if [ "$(getconf WORD_BIT)" != '32' ] && [ "$(getconf LONG_BIT)" != '64' ] ; then
    echo "Phần mềm này không hỗ trợ hệ thống 32 bit (x86), vui lòng sử dụng hệ thống 64 bit (x86_64), nếu phát hiện không chính xác, vui lòng liên hệ với tác giả"
    exit 2
fi

os_version=""

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}Vui lòng sử dụng hệ thống CentOS 7 trở lên！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}Vui lòng sử dụng hệ thống Ubuntu 16 trở lên！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}Vui lòng sử dụng phiên bản Debian 8 hoặc cao hơn của hệ thống！${plain}\n" && exit 1
    fi
fi

install_base() {
    if [[ x"${release}" == x"centos" ]]; then
        yum install epel-release -y
        yum install wget curl unzip tar crontabs socat -y
    else
        apt update -y
        apt install wget curl unzip tar cron socat -y
    fi
}

# 0: đang chạy, 1: không chạy, 2: chưa cài đặt
check_status() {
    if [[ ! -f /etc/systemd/system/XrayR.service ]]; then
        return 2
    fi
    temp=$(systemctl status XrayR | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
    if [[ x"${temp}" == x"running" ]]; then
        return 0
    else
        return 1
    fi
}

install_acme() {
    curl https://get.acme.sh | sh
}

install_XrayR() {
    if [[ -e /usr/local/XrayR/ ]]; then
        rm /usr/local/XrayR/ -rf
    fi

    mkdir /usr/local/XrayR/ -p
	cd /usr/local/XrayR/

    if  [ $# == 0 ] ;then
        last_version=$(curl -Ls "https://api.github.com/repos/wyx2685/XrayR/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ ! -n "$last_version" ]]; then
            echo -e "${red}Không phát hiện được phiên bản XrayR. Có thể đã vượt quá giới hạn API Github. Vui lòng thử lại sau hoặc chỉ định phiên bản XrayR theo cách thủ công để cài đặt.${plain}"
            exit 1
        fi
        echo -e "Đã phát hiện phiên bản mới nhất của XrayR：${last_version}，bắt đầu cài đặt"
        wget -q -N --no-check-certificate -O /usr/local/XrayR/XrayR-linux.zip https://github.com/wyx2685/XrayR/releases/download/${last_version}/XrayR-linux-${arch}.zip
        if [[ $? -ne 0 ]]; then
            echo -e "${red}Không thể tải xuống XrayR, vui lòng đảm bảo rằng máy chủ của bạn có thể tải xuống các tệp Github${plain}"
            exit 1
        fi
    else
        if [[ $1 == v* ]]; then
            last_version=$1
	else
	    last_version="v"$1
	fi
        url="https://github.com/wyx2685/XrayR/releases/download/${last_version}/XrayR-linux-${arch}.zip"
        echo -e "Bắt đầu cài đặt XrayR ${last_version}"
        wget -q -N --no-check-certificate -O /usr/local/XrayR/XrayR-linux.zip ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}Tải xuống ${last_version} Không thành công, vui lòng đảm bảo phiên bản này tồn tại${plain}"
            exit 1
        fi
    fi

    unzip XrayR-linux.zip
    rm XrayR-linux.zip -f
    chmod +x XrayR
    mkdir /etc/XrayR/ -p
    rm /etc/systemd/system/XrayR.service -f
    file="https://github.com/wyx2685/XrayR-release/raw/master/XrayR.service"
    wget -q -N --no-check-certificate -O /etc/systemd/system/XrayR.service ${file}
    #cp -f XrayR.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl stop XrayR
    systemctl enable XrayR
    echo -e "${green}XrayR ${last_version}${plain} Quá trình cài đặt đã hoàn tất và được thiết lập để bắt đầu tự động khi khởi động."
    cp geoip.dat /etc/XrayR/
    cp geosite.dat /etc/XrayR/ 

    if [[ ! -f /etc/XrayR/config.yml ]]; then
        cp config.yml /etc/XrayR/
        echo -e ""
        echo -e "Để cài đặt mới, vui lòng tham khảo hướng dẫn trước: https://github.com/XrayR-project/XrayR để định cấu hình nội dung cần thiết."
    else
        systemctl start XrayR
        sleep 2
        check_status
        echo -e ""
        if [[ $? == 0 ]]; then
            echo -e "${green}XrayR Khởi động lại thành công${plain}"
        else
            echo -e "${red}XrayR có thể không khởi động được. Vui lòng sử dụng nhật ký XrayR để xem thông tin nhật ký sau. Nếu không khởi động được, định dạng cấu hình có thể đã bị thay đổi. Vui lòng truy cập wiki để xem: https://github.com/XrayR-project /XrayR/wiki${plain}"
        fi
    fi

    if [[ ! -f /etc/XrayR/dns.json ]]; then
        cp dns.json /etc/XrayR/
    fi
    if [[ ! -f /etc/XrayR/route.json ]]; then
        cp route.json /etc/XrayR/
    fi
    if [[ ! -f /etc/XrayR/custom_outbound.json ]]; then
        cp custom_outbound.json /etc/XrayR/
    fi
    if [[ ! -f /etc/XrayR/custom_inbound.json ]]; then
        cp custom_inbound.json /etc/XrayR/
    fi
    if [[ ! -f /etc/XrayR/rulelist ]]; then
        cp rulelist /etc/XrayR/
    fi
    curl -o /usr/bin/XrayR -Ls https://xn--ss-8ja.vn/xrayrlimit/XrayR.sh
    chmod +x /usr/bin/XrayR
    ln -s /usr/bin/XrayR /usr/bin/xrayr # 小写兼容
    chmod +x /usr/bin/xrayr
    cd $cur_dir
    rm -f install.sh
    echo -e ""
    echo "Cách sử dụng tập lệnh quản lý XrayR (tương thích với thực thi xrayr, không phân biệt chữ hoa chữ thường): "
    echo "------------------------------------------"
    echo "XrayR              - Hiển thị menu quản lý (nhiều chức năng hơn)"
    echo "XrayR start        - Bắt đầu XrayR"
    echo "XrayR stop         - Dừng XrayR"
    echo "XrayR restart      - Khởi động lại XrayR"
    echo "XrayR status       - Xem trạng thái XrayR"
    echo "XrayR enable       - Đặt XrayR tự động khởi động khi khởi động"
    echo "XrayR disable      - Hủy tự động khởi động XrayR khi khởi động"
    echo "XrayR log          - Xem nhật ký XrayR"
    echo "XrayR update       - Cập nhật XrayR"
    echo "XrayR update x.x.x - Cập nhật phiên bản cụ thể của XrayR"
    echo "XrayR install      - Cài đặt XrayR"
    echo "XrayR uninstall    - Gỡ cài đặt XrayR"
    echo "XrayR version      - Xem phiên bản XrayR"
    echo "------------------------------------------"
}

echo -e "${green}Bắt đầu cài đặt${plain}"
install_base
# install_acme
install_XrayR $1
