<?php
// Permet peticions des d'altres dominis si cal
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Recuperem el nom (des de POST)
$nom = $_POST['nom'] ?? 'Anònim';

// Creem la resposta com un array
$resposta = [
  "nom" => $nom,
  "missatge" => "Hola, $nom!",
  "data" => date("Y-m-d H:i:s")
];

// L'enviem com a JSON
echo json_encode($resposta);
?>
