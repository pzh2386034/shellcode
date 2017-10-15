# shellcode
<!DOCTYPE html>
<html>  
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>物料管理系统</title>
<script type="text/javascript">
function login()
{
	var usernamevalue = username.value;
	var passwordvalue = password.value;
	var databasevalue = database.value;
	password.value = "";
	if (window.XMLHttpRequest)
	{// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else
	{// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function()
	{
	  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			var returnvalue = xmlhttp.responseText;
			if(returnvalue=='ok'){
				window.location.href='system.php';
			}else if(returnvalue=='fault'){
				alert('请使用个人域账号登录');
			}else{
				alert('登录失败');
			}
		}
	}
	xmlhttp.open("POST","authentication.php",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send('username='+usernamevalue+'&password='+passwordvalue+'&database='+databasevalue);
}
</script>
</head>  
<body style="text-align:center;">
  <div style="margin:0 auto;width:300px;height:100px;">
	<form name="LoginForm" id="LoginForm">  
	<table>
	<tr><td colspan="2" style="font-size:18px;">物料管理系统</td></tr>
	<tr><td colspan="2" style="font-size:10px;text-align:left;">不支持IE浏览器，推荐使用Firefox或chrome</td></tr>
	<tr><td colspan="2" style="font-size:10px;text-align:left;">请使用域用户登录</td></tr>
	<tr><td colspan="2">
	<select name="database" id="database">
	<option value="gongxiang">gongxiang</option>
	<option value="gongxiang_auto">gongxiang_auto</option>
	<option value="tianling">tianling</option>
	</select>
	</td></tr>
	<tr><td>
	<label for="username" class="label">用户名：</label>  </td><td>
	<input id="username" name="username" type="text" class="input" />  
	</td></tr>
	<tr><td>
	<label for="password" class="label">密码：</label>  </td><td>
	<input id="password" name="password" type="password" class="input" />  
	</td></tr>
	<tr><td colspan="2" style="text-align:center;">
	<input type="button" name="submit" value="  确定  " class="left" onclick="login()"/> 
	</td></tr>
	</table>
	</form>  
  </div>
</body>
</html>  
