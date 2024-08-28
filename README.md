Homestead-Like Setup

> Because I face a lot of errors when running Laravel Homestead on my Windows machine and Laravel Homestead seems not to be priority maintained anymore, I create a simple version of Homestead-Like Setup by myself.

> I just tested on Windows.

## Requirements

Your host machine must have Virtual Box and Vagrant installed.

## Installation

On your host machine.

```bash
git clone git@github.com:confetticode/homestead.git ~/Homestead

cd ~/Homestead

# Start building the Homestead machine.
vagrant up 

# Wait until the machine is ready. Then, SSH into it.
vagrant ssh
```

On Homestead machine.
```bash
# Login as root.
vagrant@homestead:~$ sudo su

# Go to "/vagrant" directory.
root@homestead:/home/vagrant# cd /vagrant

# Run the provision.sh script.
root@homestead:/vagrant# ./provision.sh
```

After installation, your Homestead machine runs Ubuntu 22.04 and contains
- Nginx
- PHP 8.3
- MySQL 8.0 (username: root, password: secret)

## Usage

On Homestead machine, create a new Laravel application

```bash
vagrant@homestead:~$ cd /vagrant

composer create-project --prefer-dist laravel/laravel laravel-demo
```

On Homestead machine, create `/etc/nginx/sites-available/laravel-demo.local.conf` file with the following content.

```plain
server {
    root /vagrant/laravel-demo/public;

    index index.html index.htm index.php;

    server_name laravel-demo.local;

    charset utf-8;

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { log_not_found off; access_log off; }

    location / {
        try_files \$uri \$uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    error_page 404 /index.php;

    location ~ /\.ht {
        deny all;
    }
}
```

On Homestead machine, create a symbolic link for `/etc/nginx/sites-available/laravel-demo.local.conf`.

```bash
sudo ln -s /etc/nginx/sites-available/laravel-demo.local.conf /etc/nginx/sites-enabled/laravel-demo.local.conf
```

On Homestead machine, restart Nginx and PHP.

```bash
sudo systemctl restart nginx
sudo systemctl restart php8.3-fpm
```

On your host machine, modify the `hosts` file to contain this line.

```plain
192.168.33.10 laravel-demo.local
```

Visit http://laravel-demo.local to verify if it works.

Finally, open `~/Homestead/laravel-demo` with your favourite IDE and start coding.
