# Homestead-Like Setup

Because I face a lot of errors when running Laravel Homestead on my Windows machine,
and it seems not to be priority maintained anymore, I create a simple version of Laravel Homestead by myself.

> I just tested on Windows.

## Requirements

The host must have Virtual Box and Vagrant installed.

## Installation

On the host, run these commands.

```bash
# Clone the "confetticode/homestead" repository into the ~/Homestead directory.
git clone git@github.com:confetticode/homestead.git ~/Homestead

# Go to the ~/Homestead directory.
cd ~/Homestead

# Start building the Homestead.
vagrant up 

# Wait until the machine is ready. Then, SSH into it.
vagrant ssh
```

On the Homestead, run these commands.
```bash
# Start a root login session.
sudo su

# Go to the "/vagrant" directory.
cd /vagrant

# Run the provision.sh script.
./scripts/provision.sh
```

After installation, the Homestead runs Ubuntu 22.04 LTS and a LEMP stack including:
- Nginx
- PHP 8.3
- MySQL 8.0 (username: root, password: secret)

## Usage

On the Homestead, create a new Laravel application.

```bash
cd /vagrant

composer create-project --prefer-dist laravel/laravel laravel-demo
```

On the Homestead, create the `/etc/nginx/sites-available/laravel-demo.local.conf` file with the following content.

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

On the Homestead, create a symbolic link for `/etc/nginx/sites-available/laravel-demo.local.conf`.

```bash
sudo ln -s /etc/nginx/sites-available/laravel-demo.local.conf /etc/nginx/sites-enabled/laravel-demo.local.conf
```

On the Homestead, restart Nginx and PHP 8.3.

```bash
sudo systemctl restart nginx
sudo systemctl restart php8.3-fpm
```

On the host, modify the `hosts` file to contain this line.

```plain
192.168.33.10 laravel-demo.local
```

Visit http://laravel-demo.local to verify if it works.

Finally, open `~/Homestead/laravel-demo` with your favourite IDE and start coding.
