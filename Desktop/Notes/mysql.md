# MySQL Commands


1. Login 

```sql
 mysql -u root -p
```

2. CREATE A NEW ROOT USER

```SQL
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
```

3. Change Password

```SQL
	ALTER USER 'user-name'@'localhost' IDENTIFIED BY 'NEW_USER_PASSWORD';
	FLUSH PRIVILEGES;
```

4. Show current users

 ```sql
  select user();
 ```

5. Show status: `status`
6. Find Port: `show variables like "%port%";`

7. Show Databases: `SHOW Databases;`
8. Show all users; `select host, user from mysql.user limit 2;`