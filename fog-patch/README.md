Fog の create_subnet.rb へのパッチ
====

目的
----

Fog 1.25 (執筆時点最新版) では OpenStack Neutron 上でサブネットを作成する際にゲートウェイ無しサブネットを作成出来ない不具合がある。よって、本ディレクトリにパッチを収める。

パッチ内容
----

```diff
--- /usr/lib64/ruby/gems/2.1.0/gems/fog-1.25.0/lib/fog/openstack/requests/network/create_subnet.rb.org  2014-11-24 13:13:21.003002011 +0000
+++ /usr/lib64/ruby/gems/2.1.0/gems/fog-1.25.0/lib/fog/openstack/requests/network/create_subnet.rb      2014-11-24 13:12:09.965001030 +0000
@@ -15,7 +15,12 @@
                              :dns_nameservers, :host_routes, :enable_dhcp,
                              :tenant_id]
           vanilla_options.reject{ |o| options[o].nil? }.each do |key|
-            data['subnet'][key] = options[key]
+            if  options[:gateway_ip] == 'None' then
+              data['subnet'][key] = options[key]
+              data['subnet'][:gateway_ip] = nil
+            else
+              data['subnet'][key] = options[key]
+            end
           end

           request(
```

パッチ方法
----

```bash
# wget https://github.com/jedipunkz/chapter12/raw/master/fog-patch/patch-to-create-subnet.patch
# patch -u  /usr/lib64/ruby/gems/2.1.0/gems/fog-1.25.0/lib/fog/openstack/requests/network/create_subnet.rb < patch
```
