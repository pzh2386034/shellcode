# shellcode
<!DOCTYPE html>
<?php
session_start();
if(!isset($_SESSION['username'])){
	Header('Location:login.php');
}
if(!isset($_SESSION['database'])){
	Header('Location:login.php');
}
?>
<html>
<head>
<script src="jquery-3.2.1.min.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>物料管理系统</title>
<script type="text/javascript">

$(document).ready(function(){
	$('body').load('refresh.php');
	var timer=self.setInterval("synchronize()", 120000);
	var current_time=self.setInterval("current_time_refresh()", 1000);
});

Date.prototype.Format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

function synchronize()
{
	search_box_content = $('#search_box_content').val();
	var isFocus = document.activeElement==document.getElementById('search_box_content');
	$('body').load('refresh.php', function(responseTxt,statusTxt,xhr){
		$('#search_box_content').val(search_box_content);
		search_content();
		if(isFocus)
			{document.getElementById('search_box_content').focus();}
	});
}
function current_time_refresh()
{
	var hidden_time = new Number(document.getElementById("hidden_content").innerHTML);
	hidden_time += 1000;
	document.getElementById("hidden_content").innerHTML = hidden_time;
	var current_date = new Date();
	current_date.setTime(hidden_time);
	document.getElementById("current_time").innerHTML = current_date.Format("yyyy-MM-dd hh:mm:ss");
}

function getCookie(c_name)
{
if (document.cookie.length>0)
	{
	c_start=document.cookie.indexOf(c_name + "=")
	if (c_start!=-1)
		{ 
		c_start=c_start + c_name.length+1 
		c_end=document.cookie.indexOf(";",c_start)
		if (c_end==-1) c_end=document.cookie.length
			return unescape(document.cookie.substring(c_start,c_end))
		} 
	}
return ""
}

function setCookie(c_name,value,expiredays)
{
	var exdate=new Date()
	exdate.setDate(exdate.getDate()+expiredays)
	document.cookie=c_name+ "=" +escape(value)+
	((expiredays==null) ? "" : ";expires="+exdate.toGMTString())
}

function checkCookie()
{
	username=getCookie('username')
	if (username!=null && username!="")
		{document.getElementById("username").innerHTML = username;}
	else 
	{
		username=prompt('请输入你的名字，该名字将用于物料使用登记（系统支持中文）：',"")
		if (username!=null && username!="" && username.length < 100)
		{
			setCookie('username',username,365);
			document.getElementById("username").innerHTML = username;
		}
	}
}

function pressEnter(e)
{
	var keynum
	if(window.event){
		keynum = e.keyCode
	}else if(e.which){
		keynum = e.which
	}
	if(keynum==13){
		search_content()
	}
}

function search_content()
{
	search_box_content = document.getElementById("search_box_content").value;
	var spanTag = document.getElementsByTagName("span");
	for(var i=0;i<spanTag.length;i++)
	{
		var element = spanTag[i];
		element.className = element.className.replace(/red/g,"");
	}
	if(search_box_content==null||search_box_content==""){return;}
	for(var i=0;i<spanTag.length;i++)
	{
		var element = spanTag[i];
		var title = element.getAttribute("title").replace(/\s+/g,"");
		var regex = new RegExp(search_box_content.replace(/\s+/g,""), 'i');
		var rs1 = title.search(regex);
		var rs2 = element.innerHTML.replace(/\s+/g,"").search(regex);
		if(rs1!==-1 || rs2!=-1){
			element.className += " red";
		}
	}
}

function reserve(blade_id, table, ip)
{
	var xmlhttp;
	str1 = getCookie('username');
	if(str1==''||str1==null){
		return;
	}
	if(blade_id==21){
		if(!confirm('确定要预约'+ip+'框HMM板么？')) return false;
	}else if(blade_id>=17){
		var swi_blade = {17:'1E',18:'2X',19:'3X',20:'4E'};
		if(!confirm('确定要预约'+ip+'框'+swi_blade[blade_id]+'交换板么？')) return false;
	}else{
		if(!confirm('确定要预约'+ip+'框'+blade_id+'槽么？')) return false;
	}
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
			alert(xmlhttp.responseText);
			location.reload(true);
		}
	}
	xmlhttp.open("GET","send_reserve.php?name="+str1+"&blade="+blade_id+"&table="+table,true);
	xmlhttp.send();
}
</script>
<style type="text/css">
<!--
body {font-family:Simsun;}
.current_time {float:left;}
.e9000 {font-size:14px; overflow:hidden; zoom:1;width:450px;float:left;}
.e9000_front {float:left;/*background-image:url(/php/cabinet_front.png);background-repeat:no-repeat;background-size:100% 100%;*/}
.e9000_back {float:left;}
.hmm {font-size:14px;}
.slot {height:32px; width:100px;}
.width_slot_left {height:32px; width:100px;text-align:left;}
.width_slot_right {height:32px; width:100px;text-align:right;}
.slot_id {border-style:none;width:12px;text-align:center;}
.slot_border {border-style:none;height:5px;}

.user_name {height:34px;width:85px;max-width:85px;text-overflow:ellipsis;overflow:hidden;}
.user_name_swi {width:59px;max-width:59px;text-overflow:ellipsis;overflow:hidden;text-align:center;}

.hidden_content {display:none;}
.header {}
.header_content {position:fixed;width:100%;overflow:hidden;background:#fff;border-bottom:1px solid rgba(30,35,42,.06);box-shadow:0 1px 3px 0 rgba(0,34,77,.05);background-clip:content-box;box-sizing:border-box;
z-index:100;top:0px;left:0px;text-align:right;}
.username {float:right;}
.logout {float:right;}
.search_box {float:left;}
.red {color:#ff0000;}

.board_slide {position:fixed;right:0px;top:40%;border:2px solid black;z-index:10;display:table;}
-->
</style>
</head>
<body>


</body>
</html>
