<?php
ob_start();
session_start();
?>
<link rel="stylesheet" type="text/css" href="css/style.css" />
<?php
if(!empty($_SESSION['islogged'])) {
    echo '<div class="error">IT APPEARS YOU ALREADY HAVE A SESSION RUNNING</div>';
    exit();
    /*
    header("Location: convert.php");
    ob_clean();
    flush();
    */
}
//echo '<div class="login">';
echo '<form method="POST" name="LoginForm">';

echo '<table class="box">';
echo '<th>LOGIN</th>';
echo '<tr><td><input type="text" name="username"></td></tr>';
echo '<tr><td><input type="password" name="password"></td></tr>';
echo '<tr><td align="center"><input type="submit" name="ok" value="Login"></td></tr>';

echo '</table>';
echo '</form>';
//echo '</div>';

if(isset($_REQUEST['ok'])) {
    require_once 'config/database.php';
    require_once 'config/password.php';

    $dbh = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $password);

    $typed = $_REQUEST['password'];
    $username = $_REQUEST['username'];
  
    $got = $dbh->query("select * from users where username = '". $username . "'")->fetchAll();       

    if (password_verify($typed, $got[0]['password'])) {
        if($got[0]['is_logged'] == 1) {
            echo '<div class="error">CANNOT LOG IN</div>';
            return;
        }
        $_SESSION['islogged'] = $username;
        $dbh->exec("UPDATE users SET is_logged = 1 where username = '" . $username . "'");
        //echo 'DONE';
        header("Location: convert.php");
        ob_clean();
        flush();
    }
    else {
        echo '<div class="error">INVALID</div>';
    }

    $dbh = null;
}
?>