##!/bin/bash
#OS:Centos 6.6 System:64Bit
#written July 11,2015 for CentOS 6,5 final by DaRK
#Once done you will have a running web server for your needs
echo -e '\e[12;41;71m LAmP iNSTALL SCRiPT by DaRK \e[0m'
echo -e '\e[12;41;71m Supports only centos 6.5\e[0m'
echo -e '\e[12;41;71m
    You will istall the following on your server
    Apache Web Server 2.0
    MySQL Database Server 5.0
    PHP Scripting Language 5.0
    phpMyAdmin - Web based MySQL Administration Tool
    Webmin - A free web based hosting control panel
    This will take a few minutes you where told!!!\e[3m'
echo""
echo -e '\e[12;41;71m ###### INSTALL UTILITIES THAT HELP MAKE THINGS EASIER FOR THE YOU ######   \e[0m'
echo""
    sleep 10s
yum -y update

yum -y upgrade

    sleep 10s
echo""
    for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo -e '\e[12;19;71m
INSTALLING THE FOLLOWING ON YOUR SERVER!!!
 nano
 httpd php
 mysql-server
 traceroute
 fail2bin ( good extra layer of secruity)
 boost-devel gcc-c++ mysql-devel subversion
 mlocate wget
 tree
 net-tools
 nmap
 bzip2 unzip bind-utils\e[3m'
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
    sleep 1m

yum -y istall nano
yum -y install -y httpd php
yum -y install traceroute
yum -y install boost-devel gcc-c++ mysql-devel subversion
yum -y install mod_ssl openssl
yum -y install mlocate wget
yum -y install tree
yum -y install net-tools
yum -y install nmap
yum -y install bzip2 unzip bind-utils
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
    sleep 30s
echo -e '\e[12;41;71m YOU WILL FIND A NOTE DOC ON HOW TO COMPLETE THIS INSTALL CHECK FOLDER\e[0m'
echo""
    sleep 10s
echo""
echo -e '\e[12;41;71m RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MySQL
SERVERS IN PRODUCTION USE! PLEASE READ EACH STEP CAREFULLY! \e[0m'
echo""

    sleep 20s
echo""
yum -y install mysql mysql-server

chkconfig mysql-server on
chkconfig httpd on

/etc/init.d/mysqld restart

while [[ "$mysqlPassword" = "" && "$mysqlPassword" != "$mysqlPasswordRetype" ]]; do
  echo -n "Please enter the desired mysql root password: "
  stty -echo
  read -r mysqlPassword
  echo
  echo -n "Retype password: "
  read -r mysqlPasswordRetype
  stty echo
  echo
  if [ "$mysqlPassword" != "$mysqlPasswordRetype" ]; then
    echo "Passwords do not match!"
  fi
done

/usr/bin/mysqladmin -u root password $mysqlPassword

mysql_secure_installation

echo""

    sleep 20s
echo""
/etc/init.d/mysqld restart
    sleep 10s
    echo; echo; echo; echo;
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""

    sleep 20s
echo""
# ALL MIRROS WILL BE FOUND IF IF YOU NEED THEM PLASE COMMENT OUT THE ONES YOU DO NOT NEED
wget http://mirrors.kernel.org/fedora-epel/6/x86_64/epel-release-6-7.noarch.rpm
rpm -Uvh epel-release-6-7.noarch.rpm
sleep 3

 echo""
 for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
 echo -e '\e[12;41;71m ############## INSTALLING MEMCACHED (CACHE SERVER FOR CENTOS 6.5) #############\e[0m'
 echo""

yum -y install memcached
echo""
        sleep 20s
sleep 30s
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
echo -e '\e[12;41;71m YOU WILL FIND A NOTE DOC ON HOW TO COMPLETE THIS INSTALL CHECK FOLDER\e[0m'
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
sleep 30s
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo -e '\e[12;41;71m ##############CHECKING IPTABLES TO SEE IF ITS RUNNING  REMEMBER YOU WILL NEED TO CONFIGURE ther rest of this from the note DoC #############\e[0m'
 echo""
iptables -L
echo""

  sleep 10s
echo""
echo -e '\e[12;41;71m Install PHP WITH ALL YOUR DEPENDENCY\e[0m'
echo""
echo""
yum -y install php php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-mssql php-snmp php-soap php-tidy curl curl-devel php-mysqlphp-pecl-memcache perl-Cache-Memcached  python-memcached \
php-fpm php-cli php-mysql php-gd php-ldap php-odbc php-pdo php-pear php-mbstring php-xml php-xmlrpc php-mbstring php-snmp php-soap php-devel
echo""
  sleep 10s
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo -e '\e[12;41;71m########## INSTALL APC or PHP CACHING #################\e[0m'
echo""
  sleep 10s
echo""

yum -y install php-pecl-apc
echo""
    sleep 10s
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo -e '\e[12;41;71m########## INSTALLING FAIL2BIN ################# \e[0m'
   sleep 10s
echo""
yum -y install fail2ban
echo""
        sleep 20s
sleep 30s
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
echo -e '\e[12;41;71m YOU WILL FIND A NOTE DOC ON HOW TO COMPLETE THIS INSTALL CHECK FOLDER\e[0m'
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
sleep 30s

echo -e '\e[12;41;71m########## RESTARTING YOUR SERVICES ################# \e[0m'
/etc/init.d/httpd start
/etc/init.d/mysqld restart
/etc/init.d/memcached start
service fail2ban start
 echo""
echo -e '\e[12;41;71m#################### ADDING LEVELS TO YOUR SYSTEM START ################### \e[0m'
chkconfig --levels 235 httpd on
chkconfig --levels 235 mysqld on
chkconfig --levels 235 memcached on
chkconfig --level 23 fail2ban on
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo -e '\e[12;41;71m########### SETTING UP PHPMYADMIN ######## \e[0m'
rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
yum -y install http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum -y install phpmyadmin
echo""
        sleep 20s
sleep 30s
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
echo -e '\e[12;41;71m YOU WILL FIND A NOTE DOC ON HOW TO COMPLETE THIS INSTALL CHECK FOLDER\e[0m'
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
sleep 30s
echo""
echo""

for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo""
sleep 30s
echo""
/etc/init.d/httpd restart
echo""
sleep 30s
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo




echo -e '\e[12;41;71m##############  MAKING SURE THE FIREWALL IS ON AND WILL SHOW THE STAUS #############\e[0m'
echo""
chkconfig iptables --list
echo""
echo"" sleep 10s

service iptables status
echo""
 sleep 10s
echo""
echo""for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo

 sleep 10s
echo""
echo""
yum clean all
echo""
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo "${CGREEN}================================= DONE =================================$CEND"
echo -e '\e[19;41;71m Thank you for usinng this script if you have any trouble google is your friend...  \e[0m'
echo "${CGREEN}================================= DONE =================================$CEND"
echo "${CGREEN}================================= DONE =================================$CEND"
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
for i in {59..21} {21..59} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
