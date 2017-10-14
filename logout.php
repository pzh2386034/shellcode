# shellcode
<?php
session_start();
if(isset($_SESSION['username'])){
	unset($_SESSION['username']);
}
if(isset($_SESSION['database'])){
	unset($_SESSION['database']);
}
Header('Location:login.php');
?>
