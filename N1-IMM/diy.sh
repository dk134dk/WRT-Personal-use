#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Default IP
# sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate

# lucky
rm -rf feeds/packages/net/lucky
rm -rf feeds/luci/applications/luci-app-lucky
git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/lucky

# msd_lite用23.05自带
# rm -rf feeds/packages/net/msd_lite
# rm -rf feeds/luci/applications/luci-app-msd_lite
# git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite
# git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite

# golang版本修复
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# mosdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
sed -i 's/30/2/g' package/mosdns/luci-app-mosdns/root/usr/share/luci/menu.d/*.json

# qbittorrent-static
git clone --depth=1 https://github.com/teleostnacl/luci-app-qbittorrent-static package/qb
sed -i 's/services/nas/g' package/qb/luci-app-qbittorrent-static/root/usr/share/luci/menu.d/luci-app-qbittorrent.json

# 添加passwall
# rm -rf feeds/luci/applications/luci-app-passwall
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall

# nps
rm -rf feeds/packages/net/nps
rm -rf feeds/luci/applications/luci-app-nps
git clone --depth=1 https://github.com/djylb/nps-openwrt package/nps-openwrt

# Fix
git clone --depth=1 https://github.com/kenzok8/small-package package/small

# timecontrol
rm -rf feeds/luci/applications/luci-app-timecontrol
mv package/small/luci-app-timecontrol package/luci-app-timecontrol
sed -i 's/"admin", "control"/"admin", "network"/g' package/luci-app-timecontrol/luasrc/controller/*.lua
sed -i 's/firstchild(), "Control", 44/firstchild(), "Network", 44/g' package/luci-app-timecontrol/luasrc/controller/*.lua
sed -i 's/("Internet Time Control"), 10)/("Internet Time Control"), 90)/g' package/luci-app-timecontrol/luasrc/controller/*.lua

# openclash
rm -rf feeds/luci/applications/luci-app-openclash
mv package/small/luci-app-openclash package/luci-app-openclash
sed -i 's|("OpenClash"), 50)|("OpenClash"), 3)|g' package/luci-app-openclash/luasrc/controller/*.lua

# nikki最新版本
mv package/small/luci-app-nikki package/luci-app-nikki
mv package/small/nikki package/nikki
sed -i 's/"title": "Nikki",/&\n        "order": 1,/g' package/luci-app-nikki/root/usr/share/luci/menu.d/luci-app-nikki.json
# nikki - v1.22.4 版本
# git clone --depth=1 https://github.com/nikkinikki-org/OpenWrt-nikki -b v1.22.4 package/nikki

# momo
git clone --depth=1 https://github.com/nikkinikki-org/OpenWrt-momo package/momo
sed -i 's/"title": "Momo",/&\n        "order": 4,/g' package/momo/luci-app-momo/root/usr/share/luci/menu.d/luci-app-momo.json

# ttyd
sed -i 's/"title": "Terminal",/&\n        "order": 10,/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/msgstr "终端"/msgstr "TTYD终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po

# fileassistant
rm -rf feeds/luci/applications/luci-app-fileassistant
mv package/small/luci-app-fileassistant package/luci-app-fileassistant

# dockerman
# rm -rf feeds/luci/applications/luci-app-dockerman
# mv package/small/luci-app-dockerman package/luci-app-dockerman

# serverchan
# rm -rf feeds/luci/applications/luci-app-serverchan
# mv package/small/luci-app-wechatpush package/luci-app-wechatpush

# design主题
rm -rf feeds/luci/themes/luci-theme-design
# mv package/small/luci-theme-design package/luci-theme-design
git clone -b js https://github.com/0x676e67/luci-theme-design package/luci-theme-design
mv package/small/luci-app-design-config package/luci-app-design-config

# aria2 small无法启动
# rm -rf feeds/packages/net/aria2
# mv package/small/aria2 feeds/packages/net/aria2
#sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aria2/root/usr/share/luci/menu.d/*.json

sed -i 's/services/nas/g' feeds/luci/applications/luci-app-qbittorrent/root/usr/share/luci/menu.d/*.json

# netdata
# rm -rf feeds/packages/admin/netdata
# git clone --depth=1 https://github.com/sirpdboy/openwrt-netdata feeds/packages/admin/netdata
rm -rf feeds/luci/applications/luci-app-netdata
mv package/small/luci-app-netdata feeds/luci/applications/luci-app-netdata

# wrtbwmon
rm -rf feeds/luci/applications/luci-app-wrtbwmon
mv package/small/wrtbwmon package/wrtbwmon
mv package/small/luci-app-wrtbwmon package/luci-app-wrtbwmon

# iptvhelper
mv package/small/iptvhelper package/iptvhelper
mv package/small/luci-app-iptvhelper package/luci-app-iptvhelper

# cloudflarespeedtest
# mv package/small/cdnspeedtest package/cdnspeedtest
mv package/small/luci-app-cloudflarespeedtest package/luci-app-cloudflarespeedtest
sed -i 's|Cloudflare速度测试|CF速度测试|g' package/luci-app-cloudflarespeedtest/po/zh-cn/cloudflarespeedtest.po
sed -i 's|Cloudflare速度测试|CF速度测试|g' package/luci-app-cloudflarespeedtest/po/zh_Hans/cloudflarespeedtest.po

# dnsfilter
mv package/small/luci-app-dnsfilter package/luci-app-dnsfilter

# KMS
rm -rf feeds/packages/net/vlmcsd
rm -rf feeds/luci/applications/luci-app-vlmcsd
mv package/small/vlmcsd feeds/packages/net/vlmcsd
mv package/small/luci-app-vlmcsd feeds/luci/applications/luci-app-vlmcsd

mv package/small/luci-app-wolplus package/luci-app-wolplus
mv package/small/luci-app-poweroff package/luci-app-poweroff
mv package/small/luci-app-socat package/luci-app-socat

rm -rf package/small


# argon主题
rm -rf feeds/luci/themes/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# 晶晨宝盒
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic

# ddns-go
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo

# NetSpeedTest
#git clone --depth=1 https://github.com/sirpdboy/NetSpeedTest package/NetSpeedTest

# alist
# rm -rf feeds/packages/net/alist
# rm -rf feeds/luci/applications/luci-app-alist
# git clone --depth 1 https://github.com/sbwml/luci-app-alist package/alist
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/*.json

# openlist源自带版本低
#sed -i 's/services/nas/g' feeds/luci/applications/luci-app-openlist/root/usr/share/luci/menu.d/luci-app-openlist.json
#sed -i 's/"title": "OpenList",/&\n        "order": 0,/g' feeds/luci/applications/luci-app-openlist/root/usr/share/luci/menu.d/luci-app-openlist.json
# openlist官方源版本
rm -rf feeds/packages/net/openlist
rm -rf feeds/luci/applications/luci-app-openlist
git clone https://github.com/OpenListTeam/OpenList-OpenWRT package/openlist
sed -i 's/services/nas/g' package/openlist/luci-app-openlist/root/usr/share/luci/menu.d/luci-app-openlist.json
sed -i 's/"title": "OpenList",/&\n        "order": 0,/g' package/openlist/luci-app-openlist/root/usr/share/luci/menu.d/luci-app-openlist.json


# 启用frp, luci用自带, frp第三方更新版本
rm -rf feeds/packages/net/frp
rm -rf feeds/luci/applications/luci-app-frps
rm -rf feeds/luci/applications/luci-app-frpc
git clone https://github.com/kuoruan/openwrt-frp feeds/packages/net/frp
git clone --depth=1 https://github.com/superzjg/luci-app-frpc_frps package/luci-app-frpc_frps
# git clone https://github.com/kuoruan/openwrt-frp -b v0.53.2-1 feeds/packages/net/frp
# git clone https://github.com/user1121114685/frp.git feeds/packages/net/frp
# rm -rf feeds/luci/applications/luci-app-frps
# git clone https://github.com/user1121114685/luci-app-frps.git feeds/luci/applications/luci-app-frps

# Set DISTRIB_REVISION
# sed -i "s/R25.4.145 /Lein Build $(TZ=UTC-8 date "+%Y.%m.%d") For N1 /g" package/lean/default-settings/files/zzz-default-settings
sed -i 's#mount -t cifs#mount.cifs#g' feeds/luci/applications/luci-app-cifs-mount/root/etc/init.d/cifs
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template


# Default IP
#sed -i 's/192.168.1.1/192.168.6.101/g' package/base-files/files/bin/config_generate
#sed -i 's/ImmortalWrt/N11/g' package/base-files/files/bin/config_generate

sed -i 's/vpn/nas/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/*.json



#删除库中的插件，使用自定义源中的包。
rm -rf feeds/luci/applications/luci-app-wol
#rm -rf feeds/luci/applications/luci-app-ddns-go
#rm -rf feeds/packages/net/ddns-go
#rm -rf feeds/packages/net/alist
#rm -rf feeds/luci/applications/luci-app-alist
#rm -rf feeds/luci/applications/openwrt-passwall

# 替换luci-app-openvpn-server imm源的启动不了服务！
#rm -rf feeds/luci/applications/luci-app-openvpn-server
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-openvpn-server
# 调整 openvpn-server 到 VPN 菜单
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/controller/*.lua
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/model/cbi/openvpn-server/*.lua
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/view/openvpn/*.htm


#替换luci-app-socat为https://github.com/chenmozhijin/luci-app-socat
#rm -rf feeds/luci/applications/luci-app-socat
#git_sparse_clone main https://github.com/chenmozhijin/luci-app-socat luci-app-socat
