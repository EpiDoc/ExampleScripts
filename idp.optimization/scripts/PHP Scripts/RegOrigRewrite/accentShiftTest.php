<?php

$accentList = fopen("idp-svn/scripts/vowel-combinations.txt", "r");

$accents = array();


$letterList = fgets($accentList);

while(!feof($accentList))
{
	$letter = mb_substr($letterList, 0, 1, 'UTF-8');
	
	if(mb_strtoupper($letter, 'UTF-8') == $letter)
		$match = mb_strtolower($letter, 'UTF-8');
	else
		$match = mb_strtoupper($letter, 'UTF-8');
	
	$accents[$letter] = array($match, array());
	
	// string (length - 2) because a. not including the first letter and b. want to stop one letter before the end as we are getting the next letter from the count point
	
	for($i = 1; $i < mb_strlen($letterList, 'UTF-8') - 2; $i++)
	{
		if (mb_substr($letterList, $i, 1, 'UTF-8') != "")
			array_push($accents[$letter][1], mb_substr($letterList, $i, 1, 'UTF-8'));
	}
	
	$letterList = fgets($accentList);
}

fclose($accentList);

if('ς' == 'σ')
	print("ς and σ match!\n");
else
	print("ς and σ don't match!\n");

$char1 = "ᾀ";
$char2 = "ιει";

print("1 - " . accentShift($char1, $char2) . "\n\n");

$char1 = "ᾀ";
$char2 = "ο";

print("2 - " . accentShift($char1, $char2) . "\n\n");

$char1 = "ᾀ";
$char2 = "εβ";

print("3 - " . accentShift($char1, $char2) . "\n\n");

$char1 = "ῷ";
$char2 = "υ";

print("4 - " . accentShift($char1, $char2) . "\n\n");

$char1 = "ᾀ";
$char2 = "ὀ";

print("5 - " . accentShift($char1, $char2) . "\n\n");

function vowelMatch($char1, $char2 = "")
{
	//if given 1 arg checks if letter is in the vowel table
	//if given 2 args checks if two vowels are the same base letter whatever the accents
	//if given 3 args also checks if it is a 'sound-a-like' match or whether it is potentially a 'sound-a-like' vowel if no second argument is given
	
	global $accents;
	
	print("Testing: " . $char1 . " - " . $char2 . "\n");
		
	foreach($accents as $letter => $linked)
	{
		//print("Letter: " . $letter . "\n");
		
		if($char2 == "")
		{
			if($char1 == $letter || in_array($char1, $linked[1]))
			{
				return true;
			}
			
		}
	}
}

function accentShift($char1, $char2)
{
	$accent = "";
	
	// If a vowel in orig already has diacritics, then don't add any more to it
	// If the character in reg has u+0345 as part of it then do not transfer that part across if orig is ι and υ (but transfer the rest of the accent across)
	

	if(mb_strlen($char1, 'UTF-8') > 1)
	{
		for($c = 0; $c < mb_strlen($char1, 'UTF-8'); $c++)
		{
			$decomped = Normalizer::normalize(mb_substr($char1, $c, 1, 'UTF-8') , Normalizer::FORM_D );
			if(mb_substr($decomped, 1, (mb_strlen($decomped, 'UTF-8') - 1), 'UTF-8') != "")
				$accent = mb_substr($decomped, 1, (mb_strlen($decomped, 'UTF-8') - 1), 'UTF-8');		
		}
		
		$decomped = Normalizer::normalize( $char1, Normalizer::FORM_D );
	}
	else
	{
		$decomped = Normalizer::normalize( $char1, Normalizer::FORM_D );
		$accent = mb_substr($decomped, 1, mb_strlen($decomped, 'UTF-8'), 'UTF-8');
	}
	
	
	$last_letter_pos = mb_strlen($char1, 'UTF-8');
	$last_letter = "";
	for($c = mb_strlen($char1, 'UTF-8'); $c > 0 || $last_letter != ""; $c--)
	{
		print("C: " . $c . "\n");
		if(vowelMatch(mb_substr($char2, ($c - 1), 1, 'UTF-8')))
		{
			$last_letter = mb_substr($char2, ($c - 1), 1, 'UTF-8');
			$last_letter_pos = ($c - 1);
		}
	}

	if(($last_letter == "ι" || $last_letter == "υ") && mb_strpos($accent, 'ͅ', 0, 'UTF-8') !== false) // don't copy u+0345 across if letter is ι or υ
	{
		print("alter accent 1\n");
		$accent = mb_substr($accent, 0, mb_strpos($accent, 'ͅ', 0, 'UTF-8'), 'UTF-8');
	}
	
	$decomped_orig = Normalizer::normalize($last_letter, Normalizer::FORM_D );	
		
	if(mb_strlen($decomped_orig, 'UTF-8') == 1) //Don't add accent it it already has an accent
	{	
		if(mb_strlen($char2, 'UTF-8') > 1)
		{	
			$accented_last_letter = Normalizer::normalize( $last_letter.$accent, Normalizer::FORM_C );
			$recomped = mb_substr($char2, 0, (mb_strlen($char2, 'UTF-8') - 1), 'UTF-8') . $accented_last_letter;			
		}
		else
			$recomped = Normalizer::normalize($last_letter.$accent, Normalizer::FORM_C );
		
	}
	else
		$recomped = mb_substr($char2, 0, (mb_strlen($char2, 'UTF-8') - 1), 'UTF-8') . $last_letter;		
	
	print("Char 1: " . $char1 . " -> " . $decomped . "\n");
	print("Accent: " . $accent . "\n");
	print("Char 2: " . $char2 . " -> " . $recomped . "\n");

	
	return $recomped;
}

?>
