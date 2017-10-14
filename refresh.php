# shellcode
<?php

session_start();
if(!isset($_SESSION['username'])){
	Header('Location:login.php');
}
?>

<div class="header_content">
<div class="search_box">请输入搜索内容：<input id="search_box_content" onkeypress="pressEnter(event)" /></div>
当前用户：<div id="logout" class="logout">&nbsp;<a href="logout.php">注销</a></div><div id="username" class="username">&nbsp;</div>
</div>
<div class="header">
&nbsp;
</div>

<div class="board_slide">
	<a href="log.php?table=Log">Log</a>
</div>

<?php

ini_set('date.timezone','Asia/Shanghai');

function to_href($ip){
	$result = '<a href="https://' . $ip . '" target="_blank">' . $ip . '</a>';
	return $result;
}

function echo_hmm_table($ip, $content){
	
	echo '<div class="hmm">';
	echo '<table border="0">';
	echo '<tr><td class="user_name width_slot_right" style="height:20px;" title="' . $content[20][5] . '">' . $content[20][5] . '</td><td>';
	
	echo '<span title="';
	echo 'HMM(Active):' . $content[20][6] . '&#10;&nbsp;&#10;HMM(Standby):' . $content[21][6];
	echo '" onclick="reserve(21, \'IP' . str_replace('.','',$ip) . '\', \'' . $ip . '\')">HMM IP: </span>' . to_href($ip) . "<br />";
	
	echo '</td></tr></table>';
	echo '</div>';
	
}

function echo_username_table($content, $x, $y, $class_name){
	
	echo '<div class="e9000_front">';
	echo '<table border="0">';
	echo '<tr><td class="slot_border"></td></tr>';
	
	for($i=$x;$i>=$y;$i--)
	{
		echo '<tr><td class="user_name ' . $class_name . '" title="' . $content[$i][5] . '">' . $content[$i][5] . '</td></tr>';
	}
	
	echo '<tr><td class="slot_border"></td></tr>';
	echo '</table>';
	echo '</div>';
	
}

function echo_e9000_back_table($content, $ip){
	
	echo '<div class="e9000_back">';
	echo '<table border="0">';
	echo '<tr><td style="width:85px;">&nbsp;</td>';
	for ($i=16;$i<20;$i++)
	{
		echo '<td style="text-align:center;border:1px solid #000000;width:57px;" title="Base IP:&#10;' . $content[$i][3] . '&#10;Fabric IP:&#10;' . $content[$i][4] . '" onclick="reserve(' . ($i+1) . ',\'IP' . str_replace('.','',$ip) . '\', \'' . $ip . '\')">';
		echo $content[$i][2];
		echo "</td>";
	}
	echo '</tr><tr><td style="width:85px;">&nbsp;</td>';
	for ($i=16;$i<20;$i++)
	{
		echo '<td class="user_name_swi" title="' . $content[$i][5] . '">' . $content[$i][5] . '</td>';
	}
	echo '</tr></table>';
	echo '</div>';
	
}

function read_table($ip){
	$result = mysql_query("SELECT * FROM IP" . str_replace('.','',$ip));
	$content = array();
	while($row = mysql_fetch_array($result))
	{
		$content[] = array($row['component'], $row['bmc_ip'], $row['product_name'], $row['base_ip'], $row['fabric_ip'], $row['user'], $row['info']);
	}
	
	echo '<div class="e9000" name="e9000">';
	
	echo_hmm_table($ip, $content);
	
	echo_username_table($content,7,0,'width_slot_right');
	
	echo '<div class="e9000_front">';
	echo '<table border="1">';
	echo '<tr><td class="slot_border"></td></tr>';
	
	for($i=0;$i<16;$i++)
	{
		if($content[$i][1]!='pointer'&&$content[$i][1]!='None'&&$content[$i][1]!='Unrecognized'&&$content[$i][1]!='0.0.0.0')
		{
			$content[$i][1] = to_href($content[$i][1]);
		}
	}
	for($i=0;$i<16;$i++)
	{
		if($content[$i][2]=='pointer')
		{
			$content[$i][2] = '&nbsp;';
		}
		if($content[$i][1]=='pointer')
		{
			$content[$i][1] = '&nbsp;';
		}
	}
	for($i=7;$i>=0;$i--)
	{
		echo '<tr>';
		echo '<td class="slot_id" onclick="reserve(' . str_replace('blade','',$content[$i][0]) . ',\'IP' . str_replace('.','',$ip) . '\', \'' . $ip . '\')">' . str_replace('blade','',$content[$i][0]) . '</td>';
		if($content[$i][2]!='&nbsp;'&&$content[$i+8][2]!='&nbsp;'){
			echo '<td class="slot width_slot_left"><span title="' . $content[$i][6] . '">' . $content[$i][2];
			if($content[$i][2]!='None'&&$content[$i][2]!='Unrecognized')
			{
				echo "</span><br />" . $content[$i][1];
			}
			echo "</td>";
			echo '<td class="slot width_slot_right"><span title="' . $content[$i+8][6] . '">' . $content[$i+8][2];
			if($content[$i+8][2]!='None'&&$content[$i+8][2]!='Unrecognized')
			{
				echo "</span><br />" . $content[$i+8][1];
			}
			echo '</td>';
		}else{
			echo '<td colspan="2" class="';
			if ($content[$i][2]=='&nbsp;'){
				echo 'width_slot_right';
				echo '"><span title="' . $content[$i+8][6] .'">';
			}else{
				echo 'width_slot_left';
				echo '"><span title="' . $content[$i][6] .'">';
			}
			echo  $content[$i][2] . $content[$i+8][2];
			echo "</span><br />" . $content[$i][1] . $content[$i+8][1];
			echo "</td>";
		}
		echo '<td class="slot_id" onclick="reserve(' . str_replace('blade','',$content[$i+8][0]) . ',\'IP' . str_replace('.','',$ip) . '\', \'' . $ip . '\')">' . str_replace('blade','',$content[$i+8][0]) . "</td>";
		echo "</tr>";
	}
	echo '<tr><td class="slot_border"></td></tr>';
	echo '</table>';
	echo '</div>';
	
	echo_username_table($content, 15, 8, 'width_slot_left');
	
	echo_e9000_back_table($content, $ip);
	
	echo '</div>';
}

echo '<div><div class="current_time" id="current_time_name">Server&nbsp;Time:&nbsp;</div><div id="current_time" class="current_time">';
$date=date_create();
echo date_format($date, "Y-m-d H:i:s");
echo "</div></div>";
echo '<div id="hidden_content" class="hidden_content">';
echo (time()*1000);
echo '</div><br />';

echo ("<div>Refresh Time:&nbsp;");
$con = mysql_connect("localhost:3306","root","Huawei12#$");

if (!$con)
{
	echo "333";
	die('Could not connect: ' . mysql_error());
}

mysql_select_db($_SESSION['database'], $con);

$result = mysql_query("SELECT * FROM Time");

while($row = mysql_fetch_array($result))
{
	echo "" . $row['time'];
	echo "</div>";
}

$result = mysql_query("SELECT * FROM Tables");
$e9000 = array();
while($row = mysql_fetch_array($result))
{
	array_push($e9000, $row['ip']);
}

foreach ($e9000 as $ipe){
	read_table($ipe);
}

mysql_close($con);
?>

<script type="text/javascript">
	checkCookie();
</script>
