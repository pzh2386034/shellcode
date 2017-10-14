# shellcode
<?php
session_start();
if(!isset($_SESSION['username'])){
	Header('Location:\\login.php');
}

$name=$_GET['name'];
$blade=$_GET['blade'];
$table=$_GET['table'];

if(strlen($name)>0)
{
	$con = mysql_connect("localhost:3306","root","Huawei12#$");

	if (!$con)
	{
		die('Could not connect: ' . mysql_error());
	}

	mysql_select_db($_SESSION['database'], $con);
	
	if($blade=='21'){
		$current_name_sql = mysql_query('SELECT user FROM ' . $table . ' WHERE component="smm1"');
	}else if(intval($blade)>=17){
		$current_name_sql = mysql_query('SELECT user FROM ' . $table . ' WHERE component="swi' . (intval($blade)-16) . '"');
	}else{
		$current_name_sql = mysql_query('SELECT user FROM ' . $table . ' WHERE component="blade'. $blade .'"');
	}
	$row = mysql_fetch_array($current_name_sql);
	$current_name = $row['user'];
	$behavior = '';
	if($current_name==$name)
	{
		if($blade=='21'){
			mysql_query('update ' . $table . ' set user=NULL where component="smm1"');
		}else if(intval($blade)>=17){
			mysql_query('update ' . $table . ' set user=NULL where component="swi' . (intval($blade)-16) . '"');
		}else{
			mysql_query('update ' . $table . ' set user=NULL where component="blade' . $blade . '"');
		}
		$behavior = 'cancel';
	}else{
		if($blade=='21'){
			mysql_query('update ' . $table . ' set user="' . $name . '" where component="smm1"');
		}else if(intval($blade)>=17){
			mysql_query('update ' . $table . ' set user="' . $name . '" where component="swi' . (intval($blade)-16) . '"');
		}else{
			mysql_query('update ' . $table . ' set user="' . $name . '" where component="blade' . $blade . '"');
		}
		if(empty($current_name)){
			$behavior = 'book';
		}else{
			$behavior = 'rob';
		}
	}
	
	$date=date_create();
	if($blade=='21'){
		mysql_query('insert into Log values ("' . $table . '", "HMM",  "' . $name . '", "' . $behavior . '", "' . $_SERVER['REMOTE_ADDR'] . '", "' . $_SESSION['username'] . '", "' . date_format($date, "Y-m-d H:i:s") . '")');
	}else if(intval($blade)>=17){
		mysql_query('insert into Log values ("' . $table . '", "swi' . (intval($blade)-16) . '",  "' . $name . '", "' . $behavior . '", "' . $_SERVER['REMOTE_ADDR'] . '", "' . $_SESSION['username'] . '", "' . date_format($date, "Y-m-d H:i:s") . '")');
	}else{
		mysql_query('insert into Log values ("' . $table . '", "blade' . $blade . '",  "' . $name . '", "' . $behavior . '", "' . $_SERVER['REMOTE_ADDR'] . '", "' . $_SESSION['username'] . '", "' . date_format($date, "Y-m-d H:i:s") . '")');
	}
	
	mysql_close($con);
}
echo "Success";

?>
