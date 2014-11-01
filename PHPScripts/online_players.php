<?php
    require_once ('config.php');

    $conn = mysql_connect($host, $username, $password) or die('Connection failed: ' . mysql_error());

    mysql_select_db($characters, $conn) or die('Select DB failed: ' . mysql_error());

    $sql = "SELECT Count(Online) FROM `characters` WHERE `online` = 1";
    $result = mysql_query($sql, $conn);
    $row = mysql_fetch_array($result);
    $online_player = $row["Count(Online)"];

    echo $online_player; 
?>