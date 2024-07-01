FROM alpine:3.17

# Define build arguments
ARG DB_NAME
ARG DB_USER
ARG DB_PASS

# Update and install MariaDB and client
RUN apk update && apk add --no-cache mariadb mariadb-client

# Create directory and set permissions for mysqld
# Configure mariadb
# Enable networking
RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf
      
# Install MariaDB
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Expose port 3306
EXPOSE 3306

# Copy and run create_db.sh script
COPY requirements/mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh

# Set user to mysql
USER mysql

# Set command to run mysqld
CMD ["/usr/bin/mysqld", "--skip-log-error"]
