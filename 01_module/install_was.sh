#!/bin/bash
sudo su -
apt update
sudo apt install -y default-jdk
sudo mkdir /tomcat
cd /tomcat
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.27/bin/apache-tomcat-9.0.27.tar.gz 
tar xf /tomcat/apache-tomcat-9*.tar.gz
sudo cat > /etc/systemd/system/tomcat.service << EOD
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=root
Group=root

Environment="JAVA_HOME=/usr/lib/jvm/default-java"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

Environment="CATALINA_BASE=/tomcat/apache-tomcat-9.0.27"
Environment="CATALINA_HOME=/tomcat/apache-tomcat-9.0.27"
Environment="CATALINA_PID=/tomcat/apache-tomcat-9.0.27/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/tomcat/apache-tomcat-9.0.27/bin/startup.sh
ExecStop=/tomcat/apache-tomcat-9.0.27/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOD
sudo systemctl daemon-reload
systemctl start tomcat
sudo ufw allow 8080/tcp
cat > /tomcat/apache-tomcat-9.0.27/conf/tomcat-users.xml << EOG
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<role rolename="manager-script"/>
    <role rolename="manager-gui"/>
    <role rolename="manager-jmx"/>
    <role rolename="manager-status"/>
    <user username="tomcat" password="tomcat" roles="manager-gui,manager-script,manager-status,manager-jmx"/>
</tomcat-users>
EOG
systemctl start tomcat
systemctl enable tomcat
cd /
git clone https://github.com/SteveKimbespin/petclinic_btc.git 
cd petclinic_btc
sed -i "s/\[Change Me\]/petclinic.cd8yaap4uocm.ap-northeast-2.rds.amazonaws.com/g" /petclinic_btc/pom.xml
./mvnw tomcat7:deploy
apt-get install mysql-client
./mvnw tomcat7:redeploy -P MySQL
systemctl restart tomcat