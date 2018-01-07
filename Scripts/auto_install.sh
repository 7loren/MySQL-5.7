#!/bin/bash
# 由于研究需要，可能会出现反复部署MySQL环境的情况；
# 此脚本用于自动化部署MySQL环境，版本：5.7.20；


# 部署所需的包已经全部放置在一台共享服务器中；
# 挂在共享目录到本地
mount -t cifs -o username='Shared username',password='Shared password'  //IP/Share_directory /mnt

# 新建一个目录用于临时存放部署文件
mkdir /tmp/mysql

# 复制部署包到本地
cd /mnt/0x05\ Other\ Software/00-DB/
cp mysql-5.7.20-1.el7.x86_64.rpm-bundle.tar \
      libaio-0.3.109-13.el7.x86_64.rpm \
      /tmp/mysql/

#  卸载旧版本的mariadb-lib
rpm -e --nodeps $(rpm -qa | grep mariadb)

# 安装MySQL程序包
cd /tmp/mysql
tar -xf mysql-5.7.20-1.el7.x86_64.rpm-bundle.tar
rpm -ivh mysql-community-common-5.7.20-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-5.7.20-1.el7.x86_64.rpm
rpm -ivh mysql-community-client-5.7.20-1.el7.x86_64.rpm


# MySQL5.7在Centos7依赖环境：libaio-0.3.109-13.el7.x86_64.rpm net-tools
rpm -ivh libaio-0.3.109-13.el7.x86_64.rpm  
yum -y install net-tools 
rpm -ivh mysql-community-server-5.7.20-1.el7.x86_64.rpm

# 初始化数据库环境
mysqld --initialize

# 给用户授权数据库目录权限
chown mysql:mysql -R /var/lib/mysql

# 启动服务并设置开机自启
systemctl start mysqld.service
systemctl enable mysqld.service

# 获取默认用户名密码并将其赋值给变量password

password_info=$(sed -n '/ A temporary password is generated for root@localhost:/p' /var/log/mysqld.log)
var=`echo $password_info | awk -F ',' '{print $0}' | sed "s/ ,/  /g"`
password=$(echo $var | awk '{print $11}')
# echo $password

# mysql -u* -h* -p* <<EOF  
#     Your SQL script.  
# EOF  

# 修改数据库本地登陆密码
#  将`your password`修改成自己想要的数据密码
mysqladmin -u root -p$password password 'your password'


# 授权远程特定用户远程权限

mysql -u root -h localhost -plife@12345 <<EOF
    grant all privileges on *.* to 'root'@'%' identified by 'your password' with grant option;
    flush privileges;
EOF
```
