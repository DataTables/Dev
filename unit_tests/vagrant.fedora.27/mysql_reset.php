<?php
$output = shell_exec('sh /vagrant/mysql_create_test_database.sh');
echo "<pre>$output</pre>";
?>
