<?php
	error_reporting(E_ALL);
	ini_set('display_errors', '1');
	$conn = OCILogon ("user", "password", "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=test)(SERVER=DEDICATED)))","utf8");