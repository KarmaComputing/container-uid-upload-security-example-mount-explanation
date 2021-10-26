<?php

echo "hello world";

$fp= fopen("/var/www/html/uploads/file.txt", "w") or die("Unable to open file!");
$txt = "John Smith\n";
fwrite($fp, $txt);
fclose($fp);
