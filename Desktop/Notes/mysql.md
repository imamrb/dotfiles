## Login 
mysql -u root -p

## CREATE A NEW ROOT USER

sudo mysql / mysql -u root

USE mysql;
CREATE USER 'user'@'localhost' IDENTIFIED BY 'P@ssW0rd';
GRANT ALL ON *.* TO 'user'@'localhost';
FLUSH PRIVILEGES;

-- Grant user permissions to all tables in my_database from localhost --
GRANT ALL ON my_database.* TO 'user'@'localhost';

-- Grant user permissions to my_table in my_database from localhost --
GRANT ALL ON my_database.my_table TO 'user'@'localhost';

-- Grant user permissions to all tables and databases from all hosts --
GRANT ALL ON *.* TO 'user'@'*';

## Change Password
ALTER USER 'user-name'@'localhost' IDENTIFIED BY 'NEW_USER_PASSWORD';
FLUSH PRIVILEGES;

