#!/bin/bash
sudo su -
apt update
apt-get install apache2 -y
systemctl start apache2
systemctl enable apache2
cat >> /etc/apache2/sites-available/000-default.conf << EOF
ProxyRequests Off
    <Proxy *>
        Order deny,allow
        Allow from all
    </Proxy>
ProxyPass / http://ldy-nlb-27008839cc185868.elb.ap-northeast-2.amazonaws.com/
ProxyPassReverse / http://ldy-nlb-27008839cc185868.elb.ap-northeast-2.amazonaws.com/
EOF
a2enmod proxy
a2enmod proxy_http
service apache2 restart