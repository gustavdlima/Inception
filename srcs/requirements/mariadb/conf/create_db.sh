#!bin/sh

# Check if the directory /var/lib/mysql/mysql doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Set ownership of /var/lib/mysql directory to mysql user
    chown -R mysql:mysql /var/lib/mysql
    # Install MySQL database files
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
    # Create a temporary file
    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi
fi

# Check if the directory /var/lib/mysql/wordpress doesn't exist
if [ ! -d "/var/lib/mysql/wordpress" ]; then
    # Create a SQL script to set up the database
    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Run the SQL script with mysqld and bootstrap the server
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
    # Remove the temporary SQL script
    rm -f /tmp/create_db.sql
fi
