# IPv6_ISATAP_BEHIND_NAT
#### 参考 https://ilazycat.com/posts/2017/04/openwrt-use-tsinghua-isatap-tunnel-access-ipv6.html
#### 该脚本主要为了解决在动态公网IP/NAT后（防火墙允许通过41号协议）的环境下OpenWRT更新ISATAP隧道的问题
#### 需要组件curl/ip6tables/6in4
#### IPv6 NAT后IPv6私网地址请按照实际需求进行调整
#### 感谢https://ip.sb 提供的IP地址获取api
#### 感谢Tsinghua University提供的隧道服务
