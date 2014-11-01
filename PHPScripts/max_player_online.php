<?php
    require_once ('config.php');

    mysql_connect($host, $username, $password) or die ("Can't connect with $host");
    mysql_select_db($realmd) or die('Select DB failed: ' . mysql_error());

    $max_online = mysql_query ("select max(`maxplayers`) from uptime");     
    $max_online = mysql_result ($max_online,0);

    echo "Max Player Online: $max_online";
?>