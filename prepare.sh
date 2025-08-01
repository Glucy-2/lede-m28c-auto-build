#!/bin/bash -x
id
df -h
free -h
cat /proc/cpuinfo

if [ -d "lede" ]; then
    echo "repo dir exists"
    cd lede
    git pull || { echo "git pull failed"; exit 1; }
else
    echo "repo dir not exists"
    git clone --depth=1 "https://github.com/coolsnowwolf/lede.git" || { echo "git clone failed"; exit 1; }
    cd lede
fi

#cat ../m28c.config > .config
cat feeds.conf.default > feeds.conf
sed -i 's#https://github.com/coolsnowwolf/luci.git;openwrt-23.05#https://github.com/coolsnowwolf/luci.git;openwrt-24.10#g' feeds.conf
echo -e "\nsrc-git qmodem https://github.com/FUjr/QModem.git;main" >> feeds.conf
rm -rf files
cp -r ../files .
