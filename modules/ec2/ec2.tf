resource "aws_instance" "wordpress" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true


  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2 php php-mysql mariadb-server wget unzip

    systemctl enable --now apache2
    systemctl enable --now mariadb

    mysql -u root <<SQL
    CREATE DATABASE wordpress;
    CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'wp-pass';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
    FLUSH PRIVILEGES;
    SQL

    cd /tmp
    wget https://wordpress.org/latest.zip
    unzip latest.zip
    rm -rf /var/www/html/*
    cp -r wordpress/* /var/www/html/

    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php
    sed -i 's/username_here/wpuser/' /var/www/html/wp-config.php
    sed -i 's/password_here/wp-pass/' /var/www/html/wp-config.php

    chown -R www-data:www-data /var/www/html
    systemctl restart apache2
  EOF

  tags = {
    Name = "wordpress-ec2"
  }
}
