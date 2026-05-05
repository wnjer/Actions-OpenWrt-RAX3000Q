#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

sed -i '/CONFIG_PACKAGE_kmod-ipt-offload/d' .config
sed -i '/CONFIG_PACKAGE_iptables-mod-flow/d' .config
sed -i '/CONFIG_PACKAGE_kmod-nf-flow/d' .config

cat >> .config << 'EOF'
# NSS Hardware Flow Offload
CONFIG_PACKAGE_kmod-ipt-offload=y
CONFIG_PACKAGE_iptables-mod-flow=y
CONFIG_PACKAGE_kmod-nf-flow=y
EOF


sed -i '/CONFIG_NF_FLOW_TABLE/d' target/linux/ipq50xx/config-5.4
sed -i '/CONFIG_NF_FLOW_TABLE_INET/d' target/linux/ipq50xx/config-5.4
sed -i '/CONFIG_NETFILTER_XT_TARGET_FLOWOFFLOAD/d' target/linux/ipq50xx/config-5.4

cat >> target/linux/ipq50xx/config-5.4 << 'EOF'
CONFIG_NF_FLOW_TABLE=y
CONFIG_NF_FLOW_TABLE_INET=y
CONFIG_NETFILTER_XT_TARGET_FLOWOFFLOAD=y
EOF





echo "CONFIG_ECM_FRONT_END_NSS_ENABLE=y" >> target/linux/ipq50xx/config-5.4
echo "CONFIG_ECM_FRONT_END_SFE_ENABLE=n" >> target/linux/ipq50xx/config-5.4

echo "CONFIG_ATH11K_NSS_OFFLOAD=y" >> target/linux/ipq50xx/config-5.4

mkdir -p files/etc/modules.d
echo "options ath11k nss_offload=1" > files/etc/modules.d/ath11k-nss

