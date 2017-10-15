# shellcode
<?php
	session_start();
	if(!isset($_SESSION['username'])){
		Header('Location:\\login.php');
	}
	
	$table = $_GET['table'];
	$alter_type = $_GET['alter_type'];
	if($table!='Log' && $table!='Info_alter_log') return;
	
	$con = mysql_connect("localhost:3306","root","Huawei12#$");

	if (!$con)
	{
		die('Could not connect: ' . mysql_error());
	}

	mysql_select_db($_SESSION['database'], $con);
	
	if(empty($alter_type)){
		$result = mysql_query("SELECT * FROM " . $table);
	}else{
		$result = mysql_query("SELECT * FROM " . $table . ' where alter_type = "' . $alter_type . '"');
	}
	
	echo '<table border="1">';
	
	while($row = mysql_fetch_array($result))
	{
		if($table=='Log'){
			echo '<tr><td>' . $row['ip_table'] . '</td><td>' . $row['component'] . '</td><td>' . $row['name'] . '</td><td>' . $row['behavior'] . '</td><td>' . $row['ip'] . '</td><td>' . $row['account'] . '</td><td>' . $row['time'] . '</td></tr>';
		}else if($table=='Info_alter_log'){
			echo '<tr><td>' . $row['time'] . '</td><td>' . $row['ip_table'] . '</td><td>' . $row['component'] . '</td><td>' . $row['alter_type'] . '</td><td>' . $row['pre_info'] . '</td><td>' . $row['sub_info'] . '</td></tr>';
		}
	}
	
	echo '</table>'
	
?>
