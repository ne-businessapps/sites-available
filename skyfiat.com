server {

        listen 80 ;
        listen [::]:80 ;


        root /var/www/lmsauto-production/client/skyfiat;

        #root defines the path to project folder and location that run on server .

        # index shows the index file list .
        index index.html index.php  index.htm index.nginx-debian.html;

        # it defines server name .

        server_name skyfiat.com;

        location / {

                # as directory, then fall back to displaying a 404.
                #try_files $uri $uri/ =404;
                try_files $uri $uri/ /index.php;
                # try_files $uri $uri/ /office.php;
        }

         location /phpmyadmin {
         return 301 /error.html;
        }



 location ~ \.php$ {

        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        include fastcgi.conf;
	fastcgi_read_timeout 120;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        # Include the standard fastcgi_params file included with nginx
        fastcgi_param  PATH_INFO        $fastcgi_path_info;
        # Pass to upstream PHP-FPM; This must match whatever you name your upstream connection

    }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one

        location ~ /\.ht {
                deny all;
        }
}

