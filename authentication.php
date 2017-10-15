# shellcode
<?php
	if(!isset($_POST['username']) || !isset($_POST['password']) || !isset($_POST['database'])){
		echo 'null';
		exit();
	}
	$username = $_POST['username'];
	$password = $_POST['password'];
	$database = $_POST['database'];
	if(empty($username) || empty($password) || empty($database)){
		echo 'null';
		exit();
	}
	if(1!=preg_match('/[a-zA-Z]\d+/', $username)){
		echo 'fault';
		exit();
	}
	$ldapConnect = ldap_connect('lggad03-dc.huawei.com','389');
	$bind = @ldap_bind($ldapConnect, 'CHINA\\' . $username, $password);
	if($bind){
		session_start();
		$_SESSION['username'] = $username;
		$_SESSION['database'] = $database;
		
		$con = mysql_connect("localhost:3306","root","Huawei12#$");
		if (!$con)
		{
			die('Could not connect: ' . mysql_error());
		}
		mysql_select_db($_SESSION['database'], $con);
		mysql_query('insert into Log values (NULL, NULL, NULL, "login", "' . $_SERVER['REMOTE_ADDR'] . '", "' . $username . '", "' . date_format(date_create(), "Y-m-d H:i:s") . '")');
		mysql_close($con);
		
		echo 'ok';
	}else{
		echo 'failed';
	}
	ldap_close($ldapConnect);
?>
