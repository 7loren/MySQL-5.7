# MySQL-5.7

## Contents

[TOC]

## Absract

* 环境介绍：**

### Installing MySQL on Centos 7 Using RPM Packages from Oracle

> 参考自官方文档：2.5.6 Installing MySQL on Linux Using Debian Packages from Oracle

* 准备基础包：

	```
	# wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.20-1.el7.x86_64.rpm-bundle.tar
	# tar -xvf mysql-5.7.20-1.el7.x86_64.rpm-bundle.tar
	# wget wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libaio-0.3.109-13.el7.x86_64.rpm
	```
	> *不推荐通过wget在线下载rpm包，时间会比较久！*
* 安装前卸载旧版本的Mariadb-lib：

	```
	# rpm -e --nodeps $(rpm -qa | grep mariadb)
	```

* 安装服务：

	```
	# rpm -ivh mysql-community-common-5.7.20-1.el7.x86_64.rpm
	# rpm -ivh mysql-community-libs-5.7.20-1.el7.x86_64.rpm
	# rpm -ivh mysql-community-client-5.7.20-1.el7.x86_64.rpm
	
	# rpm -ivh libaio-0.3.109-13.el7.x86_64.rpm  
	# yum -y yum install net-tools 
	# rpm -ivh mysql-community-server-5.7.20-1.el7.x86_64.rpm
	```
* 初始化数据库环境：

	```
	# mysqld --initialize
	```
	> 新版推荐使用此方法，执行后会在/var/log/mysqld.log生成随机密码；
	>
	>查看密码使用命令：`sed -n '/ A temporary password is generated for root@localhost:/p' /var/log/mysqld.log`;
	>
	>同时支持# mysql_install_db --datadir=/var/lib/mysql   //必须指定datadir,执行后会生成~/.mysql_secret密码文件;

* 修改root@localhost的密码：

	```
	mysqladmin -u root -p'初始随机密码'  password 'Your password'
	```
* Shell脚本自动部署
> 部署前，先准备好基础环境、相关安装包放置在一个可以访问的共享目录中；

	* 脚本：[auto_install.sh](https://github.com/RQ201027/MySQL-5.7/Scripts/auto_install.sh);
	* 执行前请先检查是否具有执行权限，如没有先赋予脚本执行权限：
	
	```
	chmod u+x auto_install.sh
	```
	* 执行脚本：

	```
	./auto_install.sh
	```
