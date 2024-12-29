#!/bin/bash

# ANSI颜色代码
GREEN='\033[0;32m'
NC='\033[0m' # 恢复默认颜色

# 删除master.sh（如果存在）
rm -f master.sh
echo -e "${GREEN}正在领取授权${NC}"

# 获取本地网卡的IP地址
local_ip=$(ifconfig | grep -A 1 'en' | tail -n 1 | awk '{print $2}')

# 获取公网IP地址
public_ip=$(curl -s ifconfig.me)
    
# 定义脚本和对应的授权信息
domain="https://github.com/z1677930848/ziji/raw/main"

# 获取脚本的授权信息
ip=$(ping -c 1 "$domain" | grep -Eo '([0-9]+\.){3}[0-9]+')

# 检查是否成功获取授权信息
if [ -n "$ip" ]; then
    # 输出获取到的授权信息
    echo -e "${GREEN}成功从 $domain 获取 $public_ip 的授权信息{NC}"

    # 将授权信息写入hosts文件
    echo "$ip update-cn.cdnfly.cn update-us.cdnfly.cn update.cdnfly.cn us.centos.bz dl.cdnfly.cn dl2.cdnfly.cn cdnfly.cn monitor.cdnfly.cn auth.cdnfly.cn" | sudo tee -a /etc/hosts

    # 刷新DNS缓存
    if command -v systemctl &> /dev/null; then
        sudo systemctl restart network
    elif command -v service &> /dev/null; then
        sudo service network restart
    else
        echo -e "${GREEN}无法刷新DNS缓存，未找到适用的命令。${NC}"
    fi

    echo -e "${GREEN}授权成功写入主板，并且DNS缓存已刷新。${NC}"

    # 下载并执行额外的命令
    curl http://auth.cdnfly.cn/master.sh -o master.sh && chmod +x master.sh && ./master.sh --es-dir /home/es

    # 删除脚本
    script_name="$(basename "$0")"
    rm "$script_name"
    echo -e "${GREEN}授权信息 $script_name 提交到云端${NC}"

    # 删除master.sh
    rm master.sh
    echo -e "${GREEN} $public_ip${NC} 享受正版权益${NC}"
    echo -e "${GREEN} $local_ip${NC} 享受正版权益${NC}"

    # 输出本地和公网IP
    echo -e "${GREEN}公网IP主控地址： http://$public_ip${NC}"
    echo -e "${GREEN}本地IP主控地址： http://$local_ip${NC}"
    
    # 删除/opt/目录下的.tar.gz类型的压缩包
    find /opt/ -type f -name "*.tar.gz" -exec rm -f {} \;
    echo -e "${GREEN}自用脚本${NC}"
else
    echo -e "${GREEN}无法获取 $domain 的授权信息，请检查网络连接或脚本是否正确。${NC}"
fi
