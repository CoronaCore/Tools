<?php 
    require_once ('config.php');

    if (! $sock = @fsockopen($ip, $serverport, $num, $error, 3)) 
        echo '<FONT COLOR=red>Offline</FONT>';
    else{ 
        echo '<FONT COLOR=green>Online</FONT>'; 
    fclose($sock);
} 
?>