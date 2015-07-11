# Readme
I found if I install nano on centos 6.5 this works better. Once you install nano create a .sh file DaRK.sh. Then chmod +x DaRK.sh. now will run this file and you will see your new server come about. run  command ./DaRK.sh. Once this script starts please watch it this can take about 10 mins total to complete. You will need to edit some files tese fil once this script is complete there are: phpmyadmin - SSL cert - fail2bin - iptables. That should be all but like i satyed watch yout server...

Below is what you will need to work on to complete your install

Make sure your are a ROOT user to make this all work..

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MySQL
SERVERS IN PRODUCTION USE! PLEASE READ EACH STEP CAREFULLY!

In order to log into MySQL to secure it, we'll need the current
password for the root user. If you've just installed MySQL, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MySQL
root user without the proper authorisation.

Set root password? [Y/n] <-- ENTER
New password: <-- yourrootsqlpassword
Re-enter new password: <-- yourrootsqlpassword
Password updated successfully!
Reloading privilege tables..
... Success!

By default, a MySQL installation has an anonymous user, allowing anyone
to log into MySQL without having to have a user account created for
them. This is intended only for testing, and to make the installation
go a bit smoother. You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] <-- ENTER
... Success!

Normally, root should only be allowed to connect from 'localhost'. This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] <-- ENTER
... Success!

By default, MySQL comes with a database named 'test' that anyone can
access. This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] <-- ENTER
- Dropping test database...
... Success!
- Removing privileges on test database...
... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] <-- ENTER
... Success!

Cleaning up...

 

All done! If you've completed all of the above steps, your MySQL
installation should now be secure.

Thanks for using MySQL!


phpMyAdmin

You will need to configure your phpmyadmin with the setup below


Now we configure phpMyAdmin. We change the Apache configuration so that phpMyAdmin allows connections not just from localhost 

nano /etc/httpd/conf.d/phpmyadmin.conf

#
#  Web application to manage MySQL
#

#<Directory "/usr/share/phpmyadmin">
#  Order Deny,Allow
#  Deny from all
#  Allow from 127.0.0.1
#</Directory>

Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin
Alias /mysqladmin /usr/share/phpmyadmin

Next we change the authentication in phpMyAdmin from cookie to http:

nano /usr/share/phpmyadmin/config.inc.php

[...]
/* Authentication type */
$cfg['Servers'][$i]['auth_type'] = 'http';
[...]

Restart Apache:

/etc/init.d/httpd restart

Afterwards, you can access phpMyAdmin under http://192.168.0.100/phpmyadmin/:

 Next 

Setting up an SSL secured Webserver with CentOS

1.if the script worked for you then you have the bulk of yor work done. You will just need to edit a few files now.

2. Generate a self-signed certificate

Using OpenSSL we will generate a self-signed certificate. If you are using this on a production server you are probably likely to want a key from a Trusted Certificate Authority, but if you are just using this on a personal site or for testing purposes a self-signed certificate is fine. To create the key you will need to be root so you can either su to root or use sudo in front of the commands

# Generate private key 
openssl genrsa -out ca.key 2048 

# Generate CSR 
openssl req -new -key ca.key -out ca.csr

# Generate Self Signed Key
openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt

# Copy the files to the correct locations
cp ca.crt /etc/pki/tls/certs
cp ca.key /etc/pki/tls/private/ca.key
cp ca.csr /etc/pki/tls/private/ca.csr

	

WARNING: Make sure that you copy the files and do not move them if you use SELinux. Apache will complain about missing certificate files otherwise, as it cannot read them because the certificate files do not have the right SELinux context.

If you have moved the files and not copied them, you can use the following command to correct the SELinux contexts on those files, as the correct context definitions for /etc/pki/* come with the bundled SELinux policy.

restorecon -RvF /etc/pki

Then we need to update the Apache SSL configuration file

nano +/SSLCertificateFile /etc/httpd/conf.d/ssl.conf

Change the paths to match where the Key file is stored. If you've used the method above it will be

SSLCertificateFile /etc/pki/tls/certs/ca.crt

Then set the correct path for the Certificate Key File a few lines below. If you've followed the instructions above it is:

SSLCertificateKeyFile /etc/pki/tls/private/ca.key

Quit and save the file and then restart Apache

/etc/init.d/httpd restart

All being well you should now be able to connect over https to your server and see a default Centos page. As the certificate is self signed browsers will generally ask you whether you want to accept the certificate. 


Configuring Default section for Fail2Ban

The master Fail2Ban configuration file is located under /etc/fail2ban/jail.conf. So, open it using VI editor or any editor that you feel comfortable.

nano /etc/fail2ban/jail.conf

Now, you will see default section with some basic rules that are followed by fail2ban itself. If you want to add some extra layer of protection to your server, then you can customize the each rule section as per your needs.

[DEFAULT]

# "ignoreip" can be an IP address, a CIDR mask or a DNS host. Fail2ban will not
# ban a host which matches an address in this list. Several addresses can be
# defined using space separator.
ignoreip = 127.0.0.1

# "bantime" is the number of seconds that a host is banned.
bantime = 600

# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime = 600

# "maxretry" is the number of failures before a host get banned.
maxretry = 3

Let me describe each rule section with their description and what purpose we use these rules.

    ignoreip : IgnoreIP section allows you to white list certain IP addresses from blocking. Here, you can specify list of IP addresses with space separated and make sure you include your address.
    bantime : The number of seconds that a host would be banned from the server. The default is set for 600 (600 seconds = 10 minutes), you may increase this to an hour or higher if you like.
    findtime : The amount of time that a host has to log in. The default is set to 10 minutes, it means that if a host attempts, and fails, to log in more than the maxretry number of times, they will be banned.
    maxretry : The number of failed login attempts before a host is blocked for the length of the ban time.

Configuring ssh-iptables section for Fail2Ban

The following section is the default ssh-iptables section and it is turned on by default. So, you don’t need to make any changes to this section,

[ssh-iptables]

enabled  = true
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           sendmail-whois[name=SSH, dest=root, sender=fail2ban@example.com]
logpath  = /var/log/secure
maxretry = 5

You can find the details of each rule described below.

    enabled : This section refers that SSH protection is on. You can turn it off by changing the word “true” to “false“.
    filter : This section by default set to sshd and refers the config file (/etc/fail2ban/filter.d/sshd.conf) containing the rules that fail2ban uses to find matches.
    action : This action tells the fail2ban to ban a matching IP address once a filter matches in the /etc/fail2ban/action.d/iptables.conf file. If your server have mail setup, you can add email address, where fail2ban sends you a email alerts whenever it bans an IP address. The sender section refers to file /etc/fail2ban/action.d/sendmail-whois.conf file.
    logpath : The log path is the location of logs where fail2ban will track.
    maxretry : The max retry section is the same definition as the default option that we discussed above.

Restarting Fail2Ban Service

Once you’ve made the changes to the fail2ban config file, then always make sure to restart Fail2Ban service.

# chkconfig --level 23 fail2ban on
# service fail2ban start
Starting fail2ban:                                         [  OK  ]

Verifying Fail2Ban iptables rules

Check the rules that fail2ban added in effect within the IP table section.

# iptables -L

I have made some failed login attempts from one of our server to the server where fail2ban installed and it works. You see the banned IP address of my server.

Message from syslogd@tecmint at Nov 23 13:57:53 ...
fail2ban.actions: WARNING [ssh-iptables] Ban 15.13.14.40
iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
fail2ban-SSH  tcp  --  anywhere             anywhere            tcp dpt:ssh
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED
ACCEPT     icmp --  anywhere             anywhere
ACCEPT     all  --  anywhere             anywhere
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:ssh
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:http
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp multiport dports 5901:5903,6001:6003
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain fail2ban-SSH (1 references)
target     prot opt source               destination
DROP all -- 15.13.14.40 anywhere
RETURN     all  --  anywhere             anywhere

Watch Failed SSH login attempts

To see the current ssh failed login attempts, run the following command it will display a list of failed attempts attempted by hosts.

# cat /var/log/secure | grep 'Failed password' |  sort | uniq -c

1 Nov 19 16:53:37 tecmint sshd[28185]: Failed password for root from 172.16.25.125 port 1302 ssh2
1 Nov 23 13:57:43 tecmint sshd[19079]: Failed password for root from 115.113.134.40 port 57599 ssh2
1 Nov 23 13:57:46 tecmint sshd[19079]: Failed password for root from 115.113.134.40 port 57599 ssh2
1 Nov 23 13:57:50 tecmint sshd[19079]: Failed password for root from 115.113.134.40 port 57599 ssh2
1 Oct 18 14:11:58 tecmint sshd[8711]: Failed password for root from 172.16.18.249 port 4763 ssh2
1 Oct 18 14:12:03 tecmint sshd[8711]: Failed password for root from 172.16.18.249 port 4763 ssh2
1 Oct 18 14:12:11 tecmint sshd[8711]: Failed password for root from 172.16.18.249 port 4763 ssh2
1 Oct 18 14:12:16 tecmint sshd[8711]: Failed password for root from 172.16.18.249 port 4763 ssh2
1 Oct 18 14:12:22 tecmint sshd[8711]: Failed password for root from 172.16.18.249 port 4763 ssh2
1 Oct 18 14:12:28 tecmint sshd[8711]: Failed password for root from 172.16.18.249 port 4763 ssh2
1 Oct 18 14:12:47 tecmint sshd[10719]: Failed password for root from 172.16.18.249 port 4774 ssh2

Remove IP Address from Fail2Ban

To remove the banned IP address from the fail2ban iptable rules. Run the following command.

# iptables -D fail2ban-ssh 1

For any additional information, please visit Fail2ban official page. 

REMEMBER 

 You will need to learn your how to secure your own phpmyadmin and fail2bin. If I write it here then everyone will know what you did.. 




