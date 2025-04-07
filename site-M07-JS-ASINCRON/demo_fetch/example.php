<?php
$n1 = $_GET['n1'];
$n2 = $_GET['n2'];
$resultat = $n1 + $n2;
echo json_encode(["resultat" => $resultat]);
?>
