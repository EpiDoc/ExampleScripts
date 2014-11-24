<?php 

include 'accentLib.php';
loadGlobalValues();

$filenumber = "7a";

$pairfile = fopen("reg-orig" . $filenumber . ".csv", "r");

$pair = fgetcsv($pairfile, 1000, "\t");
$mapping = array();


//$convfile = fopen("reg-orig7-conv.csv", w);


while($pair !== false)
{
	//print_r($pair);
	
	//$new = rule1($pair[0], $pair[1]);
		
	//$new = rule1point5($pair[0], $pair[1]);
	
	$context = "<reg>" . $pair[0] . "</reg><orig>" . $pair[1] . "</orig>";

	$mapping[$context] = array(array($pair[0], "<reg>" . $pair[0] . "</reg>"), array($pair[1], "<orig>" . $pair[1] . "</orig>"));	
	
	//$new_mapping = $pair[0] . "\t" . $pair[1];

	//fwrite($convfile, $new_mapping);

	$pair = fgetcsv($pairfile, 1000, "\t");
	//$linecount++;
}

fclose($pairfile);
//fclose($convfile);

file_put_contents("reg-orig" . $filenumber . "-conv.csv", "");
$convfile = fopen("reg-orig" . $filenumber . "-conv.csv", "a");

//$results = convertFile($mapping, $convfile);
$results = convertFile($mapping);

fclose($convfile);	

?>
