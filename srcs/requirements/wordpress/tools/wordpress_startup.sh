echo "Creating WP Configuration"
cd /var/www/html
if [ ! -f wordpress.kk ]; then

	curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
	echo "Installing Wordpress"
	wp core download --allow-root
	wp core install --allow-root --url="$DOMAIN_NAME" --title="FT_INCEPTION" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_EMAIL"
	wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASS --role="administrator"
	wp media regenerate -y

	#REDIS
	wp plugin install redis-cache --allow-root
	wp plugin activate redis-cache --allow-root
	
	#STATIC WEBSITE
	mkdir myweb
	mv /var/www/index.html /var/www/html/myweb/

	touch wordpress.kk
else
	echo "Wordpress config already done"
fi

wp redis enable --allow-root

echo "Wordpress ready!"

php-fpm7.3 --nodaemonize
