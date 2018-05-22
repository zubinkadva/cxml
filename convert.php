<?php
ob_start();
session_start();
?>
<link rel="stylesheet" type="text/css" href="css/style.css" />
<?php

if(empty($_SESSION['islogged'])) {
    header("Location: index.php");
    ob_clean();
    flush();
}

echo '<form enctype="multipart/form-data" method="post">';
echo '<table class="box">';
echo '<tr><td>Logged in as: ' . $_SESSION['islogged'] . '</tr></td>';
echo '<tr><td><input type="file" name="file1" /></tr></td>';
echo '<input type="hidden" name="upload" value=1>';
echo '<tr><td><input type="submit" value="Convert!!" /></tr></td>';
echo '<tr><td><input type="submit" name="out" value="Logout" /></tr></td>';
echo '</form>';

/*
REQUIREMENTS:
perl -MCPAN -e shell
install Spreadsheet::ParseExcel Spreadsheet::XLSX 
install Spreadsheet::Read Archive::Zip
*/


if(isset($_REQUEST['out'])) {
    //print_r($_REQUEST);
    echo '****'.$_SESSION['islogged'] ;
    require_once 'config/database.php';
    $dbh = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $password);
    $dbh->exec("UPDATE users SET is_logged = 0 where username = '" . $_SESSION['islogged'] . "'");
    $dbh = null;
    session_destroy();
    header("Location: index.php");
    ob_clean();
    flush();
}

if(isset($_REQUEST['upload'])) {	
    //shell_exec('./parseExcel.pl test.xlsx'); die;
        
	$file_name =$_FILES['file1']['name'];	
	if(empty($file_name)) {
		echo '<div class="error">SELECT A FILE!!</div>';
		return;
	}
	//print_r($_FILES);
	move_uploaded_file($_FILES['file1']['tmp_name'],'xml/' . $file_name);
	
	shell_exec('./parseExcel.pl "xml/' . $file_name . '"');
	
	$zipName = 'xml.zip';
	
/*$content = file_get_contents('xml/' . $file_name);
ob_end_clean();
header("Expires: 0");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header("Content-type: application/vnd.ms-excel;charset:UTF-8");
header('Content-length: '.strlen($content));
header('Content-disposition: attachment; filename='.basename($file_name));
// output all contents
echo $content;
exit; 
*/
	header("Content-type: application/zip");
	header("Content-Disposition: attachment; filename=".$zipName."");
	header("Content-length: " . filesize($zipName));
	header("Pragma: no-cache"); 
	header("Expires: 0");
	
    ob_clean();
    flush();
	
	readfile($zipName);
	exit;
	
} 
?>