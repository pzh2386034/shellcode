# shellcode
<?php
session_start();
echo $_SESSION['username'];
echo '点击此处 <a href="test.php?action=logout">注销</a> 登录！<br />';  

if($_GET['action']=='logout'){
	unset($_SESSION['username']);
}
?>
