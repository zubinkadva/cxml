<?php

require_once 'database.php';
require_once 'password.php';

$hash=password_hash('Ab123456',PASSWORD_DEFAULT);

$dbh = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $password);
//$dbh->exec("truncate table users");
$dbh->exec("insert into users(username, password) values('sa','".$hash."')"); 

