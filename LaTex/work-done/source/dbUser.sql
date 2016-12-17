CREATE USER 'phpwebuser'@'localhost'
    IDENTIFIED BY 'secure_password'; -- Change password!
    
GRANT USAGE,SELECT,INSERT,UPDATE,DELETE 
	ON Records.* 
	TO 'phpwebuser'@localhost';
