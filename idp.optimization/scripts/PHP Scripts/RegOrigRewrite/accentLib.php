<?php 
$output_file = "";

$accents = array();
$consonants = array();
$homophone_pairs = array();

$matched = array();
$not_matched = array();
$altered = array();

function convertFile($input_array, $output = "", $log = false)
{
	global $output_file, $matched, $not_matched, $altered;
	$output_file = $output;
	
	$print_pairs = false;
	$print_log = false;
	
	if($output_file != "")
	{
		if($log)
			$print_log = true;
		else
			$print_pairs = true;
	}
				
	
	$mapping = array();
	$output_array = array();
	
	
	//$convfile = fopen("reg-orig7-conv.csv", w);
	
	$append = array();
	
	foreach($input_array as $context => $pairs)
	{
		//print_r($pair);
		
		//$new = rule1($pair[0], $pair[1]);
			
		//$new = rule1point5($pair[0], $pair[1]);
		
		$pair1 = $pairs[0][0];
		$pair2 = $pairs[1][0];
		
		$context1 = $pairs[0][1];
		$context2 = $pairs[1][1];
	
		if(($pair2 != 'το' && $pair2 != 'τω' && $pair2 != 'τον' && $pair2 != 'των' && $pair2 != 'ο') && (deAccent($pair2) == $pair2))
		{
			$new = rule1($pair1, $pair2, $print_pairs);
			$output_array[$context] = array(array($pair1, $context1), array($new, $context2));	
		}
		else
		{
			print("Skipping " . $pair1 . ", " . $pair2 . "\n\n");
			$append[] = array($pair1, $pair2);
			$output_array[$context] = $pairs;	
		}
		
		
		$mapping[$pair[0]] = array($pair[1], $new);	
		
		//$new_mapping = $pair[0] . "\t" . $pair[1];
	
		//fwrite($convfile, $new_mapping);
		//$linecount++;
	}
	
	if($print_pairs)
	{
		print("Printing file! (" . $output . ")\n");
		
		foreach($append as $app_pairs)
		{
			$new_mapping = $app_pairs[0] . "\t" . $app_pairs[1] . "\n";
			fwrite($output_file, $new_mapping);
		}
	}	
		
	$matched_count = count($matched);
	$skipped = count($append);
	$changed = count($altered);
	$not_matched_count = count($not_matched);
	
	if($print_log)
	{
		print("Logging File Total: " . ($matched_count + $not_matched_count + $skipped + $changed) . ", of which " . $matched_count . " were matched, " . $skipped . " were skipped " . $changed . " where not matched but were altered in some way and " . $not_matched_count . " were not.\n");
		
		fwrite($output_file, "File Total: " . ($matched_count + $not_matched_count + $skipped + $changed) . ", of which " . $matched_count . " were matched, " . $skipped . " were skipped " . $changed . " where not matched but were altered in some way and " . $not_matched_count . " were not.\n");

	}
	else
		print("File Total: " . ($matched_count + $not_matched_count + $skipped + $changed) . ", of which " . $matched_count . " were matched, " . $skipped . " were skipped " . $changed . " where not matched but were altered in some way and " . $not_matched_count . " were not.\n");
	
	return $output_array;

}



function loadGlobalValues()
{

	global $accents, $consonants, $homophone_pairs;
			
	$accentList = fopen("idp-svn/scripts/vowel-combinations.txt", "r");
	$consList = fopen("idp-svn/scripts/consonants.txt", "r");
	$homophoneList = fopen("idp-svn/scripts/vowel_homophony.txt", "r");
	
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
	//print_r($accents);
	
	$cons = fgets($consList);	
	while(!feof($consList))
	{
		array_push($consonants, trim($cons));
		$cons = fgets($consList);
	}
	
	fclose($consList);
	
	//print_r($consonants);
	
	
	
	$homophones = fgets($homophoneList);	
	while(!feof($homophoneList))
	{
		
		if(mb_substr($homophones, 0, 2, 'UTF-8') != "//")
		{
			$pair = mb_split(",", $homophones);
			
			$h1 = trim($pair[0]);
			$h2 = trim($pair[1]);
			
			if(array_key_exists($h1, $homophone_pairs))
			{
				array_push($homophone_pairs[$h1], $h2);
			}
			elseif($h1 != "")
			{
				$homophone_pairs[$h1] = array($h1);
				array_push($homophone_pairs[$h1], $h2);
			}
		
			if(array_key_exists($h2, $homophone_pairs))
			{
				array_push($homophone_pairs[$h2], $h1);
			}
			elseif($h2 != "")
			{
				$homophone_pairs[$h2] = array($h2);
				array_push($homophone_pairs[$h2], $h1);
			}
		}	
		
		$homophones = fgets($homophoneList);
	}
	
	foreach($consonants as $consonant)
	{
		// if letter is in homophone array then add other consonants to array matches
		
		if(array_key_exists($consonant, $homophone_pairs))
		{
			foreach($consonants as $con_match)
			{
				if(!($consonant == 'ν' && $con_match == 'ς' || $consonant == 'ς' && $con_match == 'ν') && !in_array($con_match, $homophone_pairs[$consonant]))
				{
					//print("A. Adding " . $consonant . " to array key " . $con_match . "\n");
					array_push($homophone_pairs[$consonant], $con_match);
				}
			}
		}
		
		// if letter is not in homophone array but one of the keys starts with that consonant then add that consonant and its matches into the array
		foreach(array_keys($homophone_pairs) as $key)
		{
			if(mb_strlen($key, 'UTF-8') > 1)
			{
				//print("Checking against " . $key . "\n");
				if($consonant == mb_substr($key, 0, 1, 'UTF-8') && !array_key_exists($consonant, $homophone_pairs))
				{
					foreach($consonants as $con_match)
					{
						if(!($consonant == 'ν' && $con_match == 'ς' || $consonant == 'ς' && $con_match == 'ν') && !array_key_exists($consonant, $homophone_pairs))
						{
							$homophone_pairs[$consonant] = array($consonant);
							//print("B. Adding " . $consonant . " to array key " . $con_match . "\n");
							array_push($homophone_pairs[$consonant], $con_match);
						}
						elseif(!($consonant == 'ν' && $con_match == 'ς' || $consonant == 'ς' && $con_match == 'ν') && !in_array($con_match, $homophone_pairs[$consonant]))
						{
							//print("C. Adding " . $consonant . " to array key " . $con_match . "\n");
							array_push($homophone_pairs[$consonant], $con_match);
						}
					}			
				}
			}
		}
	}
	
	fclose($homophoneList);
	
	ksort($homophone_pairs);
	
	//print_r($homophone_pairs);	
}


function rule1point5($reg, $orig)
{
	//RULE 1.5 - if reg ends with a ' and orig doesn't then copy the ' across to orig
	$new_orig = $orig;
	
	$last_r = mb_substr($reg, -1, 1, 'UTF-8');
	$last_o = mb_substr($orig, -1, 1, 'UTF-8');
	
	if(($last_r == "ʼ" || $last_r == "'") && $last_r != $last_o)
	{
		$new_orig = $orig . $last_r;
		print("Rule 1.5: Apostrophe appended: " . $new_orig . "\n");
	}	
	
	return $new_orig;	
}



function rule1($reg, $orig, $print=false)
{
	global $matched, $not_matched, $altered, $output_file;

	print("Rule 1\n");
	$new_orig = $orig;
	$reg_original = $reg;
	$original = $orig;

	
	// Rule #1: when #reg and #orig differ by one or more of: 
		//spelling only by 1 or more const
		//pair of homophonous (see list)
		//duplication (or the reverse) of one letter
	// then copy the accent from $reg to $orig as per the vowel rules.
	
	print("Reg: '" . $reg . "' Orig: '" . $orig . "'\n");
	
	if(mb_substr($reg, -1, 1, 'UTF-8') == "ʼ")
		$reg = mb_substr($reg, 0, (mb_strlen($reg, 'UTF-8') - 1), 'UTF-8');


	$reg = mb_ereg_replace("\s*", "", $reg); 
	$orig = mb_ereg_replace("\s*", "", $orig); 
	
	//print(" -> Reg (no spaces): '" . $reg . "' Orig (no spaces): '" . $orig . "'\n");
	
	$reg_array = array();
	$token = "";
	
	for($r = 0; $r < mb_strlen($reg, 'UTF-8'); $r++)
	{
		array_push($reg_array, mb_substr($reg, $r, 1, 'UTF-8'));
	}

	
	//print_r($reg_array);
	
	$orig_array = array();
	$token = "";

	for($o = 0; $o < mb_strlen($orig, 'UTF-8'); $o++)
	{
		array_push($orig_array, mb_substr($orig, $o, 1, 'UTF-8'));
	}
	
	//print_r($orig_array);	
	
	
	$result = tokenise($reg_array, $orig_array);
	
	if($result != false)
	{
		$alt_r_array = $result[0];
		$alt_o_array = $result[1];
		$match = true;
	}
	else
		$match = false;
	
	
	if($print && $output_file != "")
		$convfile = $output_file;
	
	$new_mapping = $reg_original . "\t" . $original;
	
	$homophone_check = array();
	
	
	if($match)
	{
		$starred = false;
		print($reg_original . " and " . $original . " match!\n");
		print("Alt arrays: \n");
		print_r($alt_r_array);
		
		$alt_o_array = replaceSpaces($original, $alt_o_array);
		print_r($alt_o_array);
		
		$new_orig = "";
		
		// If reg has ς where orig has σ, change orig to ς.
		
		for($l = 0; $l < count($alt_o_array); $l++)
		{
			$r_letter = $alt_r_array[$l];
			$o_letter = $alt_o_array[$l];
			
			if($l == 0)
			{
				if(mb_strlen($o_letter, 'UTF-8') > 1)
				{
					$first_r_letter = mb_substr($r_letter, 0, 1, 'UTF-8');
					$first_o_letter = mb_substr($o_letter, 0, 1, 'UTF-8');
					
					if((mb_strtoupper($first_r_letter, 'UTF-8') == $first_r_letter) && (mb_strtoupper($first_o_letter, 'UTF-8') != $first_o_letter))
						$o_letter = mb_strtoupper($first_o_letter, 'UTF-8') . mb_substr($o_letter, 1, (mb_strlen($o_letter, 'UTF-8') - 1), 'UTF-8');				
				}
				else
				{
					if((mb_strtoupper($r_letter, 'UTF-8') == $r_letter) && (mb_strtoupper($o_letter, 'UTF-8') != $o_letter))
						$o_letter = mb_strtoupper($o_letter, 'UTF-8');
				}
			}
			
			//(mb_strtoupper($first_r_letter, 'UTF-8') !== mb_strtolower($first_r_letter, 'UTF-8'))
			
			if(count($homophone_check) > 0)
			{
				$star_match = 0;
				foreach($homophone_check as $starred_pair)
				{
					$pair = mb_split(",", $starred_pair);
		
					$h1 = trim($pair[0]);
					$h2 = trim($pair[1]);
					
					if((deAccent($r_letter) == $h1 && deAccent($o_letter) == $h2) || (deAccent($r_letter) == $h2 && deAccent($o_letter) == $h1))
						$star_match++;
				}
				
				if($star_match == count($homophone_check))
					$starred = true;
			}
			
			if((mb_strpos($r_letter, 'ς', 0, 'UTF-8') !== false) && (mb_strpos($o_letter, 'σ', 0, 'UTF-8') !== false))
			{
				//print("Replacing σ with ς in o_letter\n");
				$o_letter = mb_ereg_replace("σ", "ς", $o_letter); 
				$o_letter = mb_ereg_replace(mb_strtoupper("σ"), mb_strtoupper("ς"), $o_letter); 
			}
			
			$new_orig .= accentShift($r_letter, $o_letter);
			

			

		}
		
		$new_orig = rule1point5($reg_original, $new_orig);
		
		if($starred)
			$new_mapping .= "\t" . $new_orig . "\t*\n";
		else
			$new_mapping .= "\t" . $new_orig . "\n";
			
		$matched[] = array($reg_original, $orig, $new_orig);
		print("Altering orig from " . $orig . " (" . mb_strlen($orig, 'UTF-8') . ") -> " . $new_orig . " (" . mb_strlen($new_orig, 'UTF-8') . ")\n\n");
		
	}
	else
	{
		$starred = false;
		print($reg_original . " and " . $original . " don't match!\n");
		
		
		$first_r_letter = mb_substr($reg_original, 0, 1, 'UTF-8');
		$first_o_letter = mb_substr($original, 0, 1, 'UTF-8');
		
		//print("Breathing mark shift on first letter\n");
		if(vowelMatch($first_r_letter))
		{
			$go = true;
			$first_r_vowel_set = "";
			$max = mb_strlen($reg_original, 'UTF-8');
			
			if($max > 2) // Only want maximum 2 characters
				$max = 2;
			
			for($i = 0; $i < $max && $go; $i++)
			{
				$current_r = mb_substr($reg_original, $i, 1, 'UTF-8');
				
				if(vowelMatch($current_r))
					$first_r_vowel_set .= $current_r;
				else
					$go = false;
			}
			
			$first_o_vowel_set = "";
			$go = true;
			$max = mb_strlen($original, 'UTF-8');
			
			if($max > 2) // Only want maximum 2 characters
				$max = 2;
			
			for($i = 0; $i < $max && $go; $i++)
			{
				$current_o = mb_substr($original, $i, 1, 'UTF-8');
				
				if(vowelMatch($current_o))
					$first_o_vowel_set .= $current_o;
				else
					$go = false;				
			}			
			
			//print("Calling accentShift with third argument set to true\n");
			$first_o_letters = accentShift($first_r_vowel_set, $first_o_vowel_set, true);
		}
		
		$last_r_letter = mb_substr($reg, -1, 1, 'UTF-8');
		$last_o_letter = mb_substr($orig, -1, 1, 'UTF-8');
		
		
		$new_orig = exceptions($reg_original, $original);
		
		if($new_orig == $original && $first_o_letters != "")
		{
			print("Moving any breathing marks across first vowel/vowel pair (" . $first_o_letters . " from ". $first_r_vowel_set . "-" . $first_o_vowel_set . ")\n");
			$replacement_length = mb_strlen($first_o_letters, 'UTF-8');
			$new_orig = $first_o_letters . mb_substr($original, $replacement_length, (mb_strlen($original, 'UTF-8') - $replacement_length), 'UTF-8');
		}
		
		$first_r = mb_substr($reg_original, 0, 1, 'UTF-8');
		
		if($new_orig == $original)
			$first_o = mb_substr($original, 0, 1, 'UTF-8');
		else
			$first_o = mb_substr($new_orig, 0, 1, 'UTF-8');
					
		if(mb_strtoupper($first_r, 'UTF-8') == $first_r && mb_strtoupper($first_o, 'UTF-8') != $first_o  && (mb_strtoupper($first_r, 'UTF-8') != mb_strtolower($first_r, 'UTF-8')))
		{
			print("Capitalising First letter\n");
			//print("Orig: " . $orig . " New orig: " . $new_orig . "\n");
			
			if($new_orig == $original)
				$new_orig = mb_strtoupper($first_o, 'UTF-8') . mb_substr($original, 1, (mb_strlen($original, 'UTF-8') - 1), 'UTF-8');
			else
				$new_orig = mb_strtoupper($first_o, 'UTF-8') . mb_substr($new_orig, 1, (mb_strlen($new_orig, 'UTF-8') - 1), 'UTF-8');		
		}	
			
		if($last_r_letter == 'ς' && $last_o_letter == "σ")
		{
			print("Changing final letter from σ to ς\n");
			if($new_orig != "")
				$new_orig =  mb_substr($new_orig, 0, (mb_strlen($original, 'UTF-8') - 1), 'UTF-8') . $last_r_letter;
			else
				$new_orig =  mb_substr($original, 0, (mb_strlen($original, 'UTF-8') - 1), 'UTF-8') . $last_r_letter;
		}
		
		//print("Substring: " . mb_substr($reg_original, 0, 4, 'UTF-8') . "\n");
		
		if(deAccent(mb_substr($reg_original, 0, 4, 'UTF-8')) == "και ")
		{
			//print("Calling Kai Word function\n");
			
			//$starred = true;
			
			if($new_orig != $original)
			{
				$before = $new_orig;
				$new_orig = kaiwords($reg_original, $new_orig);
				
				if($before != $new_orig)
						print("Changed by kai word function\n");
			}
			else
			{
				$new_orig = kaiwords($reg_original, $original);
				
				if($original != $new_orig)
						print("Changed by kai word function\n");
			}
		}
		else
		{
			// Match strings from back to front and copy over any accents in the part which matches
			//print("Calling tail-end accent switch function\n");
			
			if($reg_original != deAccent($reg_original))
			{
				if($new_orig != $original)
				{
					$before = $new_orig;
					$new_orig = tailendAccentSwitch($reg_original, $new_orig);
					
					if($before != $new_orig)
						print("Changed by tail-end accent switch function\n");
				}
				else
				{
					$new_orig = tailendAccentSwitch($reg_original, $original);
					
					if($original != $new_orig)
						print("Changed by tail-end accent switch function\n");
				}
			}
		}
			
		if($new_orig != $original)
		{
			if($starred)
				$new_mapping .= "\t**\t" . $new_orig . "\n";
			else
				$new_mapping .= "\t\t" . $new_orig . "\n";
				
			print("Altering orig from " . $orig . " -> " . $new_orig . "\n\n");
			$altered[] = array($reg, $orig);
		}
		else
		{
			print("Orig not altered\n\n");
			$new_mapping .= "\n";
			$not_matched[] = array($reg, $orig);
		}
	}
		
	//print($new_mapping);
	if($print && $convfile != "")
		fwrite($convfile, $new_mapping);

	return $new_orig;
}


function tokenise($reg_array, $orig_array)
{
	$r_length = count($reg_array);
	$o_length = count($orig_array);
	$alt_r_array = array();
	$alt_o_array = array();
	
	//print("R_length: " . $r_length . " - O_length: " . $o_length . "\n");
	
	if($r_length == 0 || $o_length == 0)
		return false;
	
	if($r_length > $o_length)
		$length = $o_length;
	else
		$length = $r_length;
		
	$match = true;
	$o = 0;
	
	//print("Testing: " . $reg . " and " . $orig . "\n");
	
	for($r=0; $r < $r_length && $match; $r++)
	{
		//print("Testing " . $reg_array[$r] . " (" . $r . ") : " . $orig_array[$o] . " (" . $o . ")\n");
		//print("Current loop positions: R - " . $r . " (" . $reg . ") , O - " . $o . " (" . $orig . ") [length " . $length . "] \n");
		$offsets = matchTest($reg_array, $r, $orig_array, $o);
		
		//print("Offsets: \n");
		//print_r($offsets);
		
		if($offsets[0] < 1 && $offsets[1] < 1)
		{
			$match = false;
			//print("Match text returned empty array\n");
		}
		else
		{
			//print("R offset " . $offsets[0] . "\n");
			//print("O offset " . $offsets[1] . "\n");
			
			if($offsets[0] == 1)
				$alt_r_array[] = $reg_array[$r];
				
			if($offsets[0] > 1)
			{
				$token = "";
				//print("B. r offset: " . $offsets[0] . "\n");
				for($i=$r; $i < ($r + $offsets[0]); $i++)
				{
					$token .= $reg_array[$i];
					//print("B. Adding to token " . $reg_array[$i] . "\n");
				}
				$alt_r_array[] = $token;
				//print("B. Adding " . $token . " to alt_r_array\n");
			}
			
			if($offsets[0] > 1)
			{
				//print("Ofsetting R by " . ($offsets[0] - 1) . "\n");
				$r += ($offsets[0] - 1);	
			}
				
			//print("R offset " . $offsets[0] . "\n");
			//print("R is now " . $r . "\n");
							
			if($offsets[1] == 1)
			{
				$alt_o_array[] = $orig_array[$o];
				//print("A. Adding " . $orig_array[$o] . " to alt_o_array\n");
			}
				
			if($offsets[1] > 1)
			{
				$token = "";
				//print("B. o offset: " . $offsets[1] . "\n");
				for($i=$o; $i < ($o + $offsets[1]); $i++)
				{
					$token .= $orig_array[$i];
					//print("B. Adding to token " . $orig_array[$i] . "\n");
				}
				$alt_o_array[] = $token;
				//print("B. Adding " . $token . " to alt_o_array\n");
			}
			
			$o += $offsets[1];
			
			//print("Next loop positions: R - " . ($r+1) . " (" . $reg_array[($r+1)] . ") , O - " . ($o) . " (" . $orig_array[$o] . ") [length " . $length . "] \n");
		}
		
		
		if((($r+1) >= $r_length && $o_length >= $r_length)|| $o == $o_length)
		{
			//print("Checking for length mismatch...\n");
			//print("Next " . $reg_array[$r+1] . " (" . ($r+1) . "/" . $length . ") : " . $orig_array[$o] . " (" . $o . "/" . $o_length .  ")\n");
			$mismatch = false;
			
			if($o == $o_length)
			{
				//print("Testing remaining reg string\n");
				
				$remainder = "";
				
				for($s = $r+1; $s < $r_length; $s++)
				{
					$remainder .= $reg_array[$s];
				}
				
				if($remainder != "")
					$mismatch = true;
			}
			elseif(($r+1) >= $length)
			{
				//print("Testing remaining orig string\n");
				$remainder = "";
				
				for($s = $o; $s < $o_length; $s++)
				{
					$remainder .= $orig_array[$s];
				}
				
				if($remainder != "")
					$mismatch = true;
			}
			
			if($mismatch)
			{
				print("Current loop positions: R - " . $r . " , O - " . $o . "\n");
				print("Fail - String Length Doesn't Match!!\n");
				$match = false;
			}
		}
		
	}	
	
	if($match)
		return array($alt_r_array, $alt_o_array);
	else
		return false;
}


function matchTest($reg_array, $r, $orig_array, $o, $debug = false, $debug_2=false)
{
	global $accents;
	global $homophone_pairs;
	global $consonants;
	
	$current_r = deAccent($reg_array[$r]);
	$current_r = mb_strtolower($current_r, 'UTF-8');
	$next_r = deAccent($reg_array[$r+1]);
	$current_o = deAccent($orig_array[$o]);
	$current_o = mb_strtolower($current_o, 'UTF-8');
	$next_o = deAccent($orig_array[$o+1]);
	$expanding_r = $current_r . $next_r;
	$r_offset = 1;
	$o_offset = 1;
	
	$potential_homophone = false;
	
	//print("\nMT " . $current_r . " (" . $reg_array[$r] . ") : " . $current_o . " (" . $orig_array[$o] . ")\n");
	//print("MT (Next). " . $next_r . " (" . $reg_array[($r+1)] . ") : " . $next_o . " (" . $orig_array[($o+1)] . ")\n");
	
	if(homophoneMappingMatch($current_r))
		$potential_homophone = true;

	if(homophoneMappingMatch($expanding_r))
		$potential_homophone = true;
		
	if($current_r == "" || $current_o == "")
	{
		if($debug)
			print("0. Fail at " . $current_r . " - " . $current_o . "\n");
		
		return array("0", "0");
	}	

	
	if(($current_r == $current_o) && ($potential_homophone == false)) // letters are the same and not part of a homophone pair/group
	{
		if($debug_2)
			print("1 - ");
		
		if($next_r != "" && $next_o != "")
		{				
			if($debug_2)	
				$result = matchTest($reg_array, ($r + 1), $orig_array, ($o + 1), true);
			else
				$result = matchTest($reg_array, ($r + 1), $orig_array, ($o + 1));
				
			if($result[0] > 0 && $result[1] > 0)
				return array("1", "1");
			else
				return $result;				
		}
		else	
			return array("1", "1");
	}
	elseif(vowelMatch($current_o, $current_r) && ($potential_homophone == false)) // letters are both vowels and are the 'same'
	{
		if($debug_2)
			print("2 - ");
		
		if($next_r != "" && $next_o != "")
		{
			if($debug_2)	
				$result = matchTest($reg_array, ($r + 1), $orig_array, ($o + 1), true);
			else
				$result = matchTest($reg_array, ($r + 1), $orig_array, ($o + 1));
				
			if($result[0] > 0 && $result[1] > 0)
				return array("1", "1");
			else
				return $result;
		}
		else	
			return array("1", "1");
	}
	elseif(homophoneMappingMatch($current_r))
	{
		if($debug_2)
			print("4 -");
			
		$curr_matches = array();
		
		if($debug_2)
			print("Current loop positions: R - " . $r . " (" . $current_r . ") , O - " . $o . " (" . $current_o . ")\n");
		
		//if($debug)
		//	$curr_matches = homophoneMatches($current_r, $o, $orig_array, $curr_matches, true);
		//else
		//	$curr_matches = homophoneMatches($current_r, $o, $orig_array, $curr_matches);
		//print_r($curr_matches);

		if($debug_2)
			print("R: " . $r . " R+1: " . $r+1 . " r_length: " . count($reg_array) . "\n");
			
		$longest_pos_r = 1;	
		$longest_pos_o = 1;	
		foreach($homophone_pairs as $poss_match => $matches)
		{
			if(mb_substr($poss_match, 0, 1, 'UTF-8') == $current_r)
			{
				if(mb_strlen($poss_match, 'UTF-8') > $longest_pos_r)
					$longest_pos_r = mb_strlen($poss_match, 'UTF-8');
			}			
		}	


		
		//print("Longest possible r match starting at " . $r . " (" . $current_r . ") is " . $longest_pos_r . " ");
		
		if(($r + $longest_pos_r) > count($reg_array))
		{
			$longest_pos_r = count($reg_array) - $r;
		}		
		
		//print("and after string length check is " . $longest_pos_r . " (string length is " . count($reg_array) . ")\n");
		
		
		for($len = 0; $len < $longest_pos_r; $len++)
		{
			$expanding_r = "";
			
			for($i = 0; $i < ($len + 1); $i++)
			{
				$expanding_r .= deAccent($reg_array[($r+$i)]);
				
				//print("Adding " . deAccent($reg_array[($r+$i)]) . " to expanding_r\n");
			}
			
			if(homophoneMappingMatch($expanding_r))
			{	
				//print("Expanding_r: " . $expanding_r . "\n");
			
				if($debug_2)
					print("1. Expanding Reg: " . $expanding_r . " (" . $r . ") : " . $expanding_o . " (" . $o . ")\n");				
	
				if($debug)
						$curr_matches = homophoneMatches($expanding_r, $o, $orig_array, $curr_matches, true);
					else
						$curr_matches = homophoneMatches($expanding_r, $o, $orig_array, $curr_matches);	

			}
		}
		
		
		if($debug_2)
		{
			print("current matches array:\n");
			print_r($curr_matches);
		}
			

		
		
		if(count($curr_matches) > 0)
		{	
			$ui_array = array("ι", "υ");
			// If the current letter is a vowel other than ι and is followed by ι or υ then the vowel cannot match as a single unit
			
			//print("Current r: " . $current_r . " Next r: " . $next_r . " Current o: " . $current_o . " Next p: " . $next_o . "\n");
			
			if((vowelMatch($current_r) && $current_r != "ι" && in_array($next_r, $ui_array)) || (vowelMatch($current_o) && $current_o != "ι" && in_array($next_o, $ui_array)))	
			{			
				if($debug)
					print("MT - Vowel pair (removing disallowed matches)\n");
				
				$new_curr_matches = array();
				
				foreach($curr_matches as $reg_match => $orig_matches)
				{
					// if the reg is longer than one character or the next character is not ι or υ
					if(mb_strlen($reg_match, 'UTF-8') != 1 || !in_array($next_r, $ui_array))
					{	
						$new_orig_matches = array();	
										
						foreach($orig_matches as $orig_match)
						{
							// if the orig is longer than one character or the next character is not ι or υ
							if(mb_strlen($orig_match, 'UTF-8') != 1 || !in_array($next_o, $ui_array))
								$new_orig_matches[] = $orig_match;
								
						}
					
						if(count($new_orig_matches) > 0)
							$new_curr_matches[$reg_match] = $new_orig_matches;				
						
					}
	
					
				}
				
				
				if(count($curr_matches) > 1)// || (count($curr_matches) == 1 && !($current_r == "ι" && $current_0 == "ο") && !($current_r == "ο" && $current_0 == "ι")))
				{
					if($debug_2)
					{
						print("Old curr matches:\n");
						print_r($curr_matches);
					}
					
					$curr_matches = $new_curr_matches;
					
					if($debug_2)
					{
						print("New curr matches:\n");
						print_r($curr_matches);
					}
				}
				//else
				//	print("FFS!\n");
				
				
			}	
				
			$shortest_r_match = "";
			$r_offset = 5;
			$shortest_r_options = array();
			$o_offset = 5;
			$potential_double = false;
			$priority_level = 100;
			
			
			
			
			foreach($curr_matches as $r_match => $o_matchs)
			{
				if(mb_strlen($r_match, 'UTF-8') == "2" && (mb_substr($r_match, 0, 1, 'UTF-8') == mb_substr($r_match, 1, 1, 'UTF-8')))
					$potential_double = true;	
					
				if(mb_strlen($r_match, 'UTF-8') < $r_offset || ($r_offset == "1" && $potential_double))
				{
					$temp_r_offset = mb_strlen($r_match, 'UTF-8');
					
					$new_r = $r + $temp_r_offset;
					
					foreach($o_matchs as $o_match)
					{
						//print("\n\nChecking: " . $o_match . " o_offset = " . $o_offset . "\n");	
						$temp_o_offset = mb_strlen($o_match, 'UTF-8');
						$new_o = $o + $temp_o_offset;
								
						//print("Checking match for r = " . $new_r . " (" . $reg_array[$new_r] . "), o = " . $new_o . " (" . $orig_array[$new_o] . ")\n");
						
						if($new_r == count($reg_array) && $new_o == count($orig_array))
						{
							if($debug_2)
								print("Reached end of string with " . $new_r . " and " . $new_o . "...\n");		
								
							$get_next = array($temp_r_offset, $temp_o_offset);					
						}
						else
						{
							if($debug_2)
								print("Recursive call to matchtest with " . $new_r . " and " . $new_o . "...\n");
							
							if($debug_2)	
								$get_next = matchTest($reg_array, $new_r, $orig_array, $new_o, true);
							else
								$get_next = matchTest($reg_array, $new_r, $orig_array, $new_o);
							
							if($debug_2)
								print("...End recursive call to matchtest\n");
						}
						//print_r($get_next);
						
						if($get_next[0] < 1 && $get_next[1] < 1)
							$next = false;
						else
						{
							$next = true;	
							
							$priority = ($get_next[0] + $get_next[1]);
							
							if($debug_2)
								print($get_next[0] . ", " . $get_next[1] . " (" . $priority . ")\n");
								
							if($new_r == $new_o)
							{
								$priority = 1;
								//print("Letters match - priority to 1\n");
							}
								
							if($potential_double)
								$priority = 0;		
								
							if(($r + $get_next[0]) == count($reg_array) && ($o + $get_next[1]) == count($orig_array))
								$priority = 0;	
							
							if($debug_2)
							{
								print("R: " . $r . " R length: " . count($reg_array) . " potential next jump: " . $get_next[0] . " O: " . $o . " O length: " . count($orig_array) . " potential next jump: " . $get_next[1] . "\n");	
								//print("Match found (" . $r_match . "/" . $o_match . ") and setting priority to " . $priority . ". Current level is: " . $priority_level . "\n");
								//print("Current o_offset: " . $o_offset . " - Current o length " . mb_strlen($o_match, 'UTF-8') . "\n");
							}
						}
								
						if($debug_2)
						{
							print("Priority: " . $priority . " Priority Level: " . $priority_level);
						
							if($next)
								print(" Next is true\n");
							else
								print(" Next is false\n");
						}
							
						if(($priority < $priority_level) && $next)
						{	
							$o_offset = mb_strlen($o_match, 'UTF-8');
							$r_offset = mb_strlen($r_match, 'UTF-8');
							
							$priority_level = $priority;
							
							if($debug_2)
							{
								print("Priority Level is: " . $priority_level . "\n");
							
								print("Offset is now: " . $r_offset . " , " . $o_offset . "\n");
							}
						}			
					}

				}
			}
						


			
			if($o_offset == 5)
			{
				if($debug)
					print("2. Fail to find homophone match starting at " . $r .  " - " . $o. " where following letters match\n");
					
				return array("0", "0");
			}
			
				
			//print("Using offsets: r - " . $r_offset . " o - " . $o_offset . "\n");			
			return array($r_offset, $o_offset);
			
		}
		elseif((in_array($current_r, $consonants) && in_array($current_o, $consonants)) && !(($current_r == 'ν' && $current_o == 'ς') || ($current_o == 'ν' && $current_r == 'ς')))
		{			
			//print("2a. Matching " . $current_r . " - " . $current_o . " as consonants \n");
				
			return array("1", "1");
		}
		else
		{
			if($debug)
				print("3. Fail at " . $current_r . " - " . $current_o . "\n");
			
			return array("0", "0");
		}


		
	}
	elseif((in_array($current_r, $consonants) && in_array($current_o, $consonants)) && !(($current_r == 'ν' && $current_o == 'ς') || ($current_o == 'ν' && $current_r == 'ς')))
	{			
		if($debug_2)
			print("5 - ");
			
		if($next_r != "" && $next_o != "")
		{
			if($debug_2)	
				$result = matchTest($reg_array, ($r + 1), $orig_array, ($o + 1), true);
			else
				$result = matchTest($reg_array, ($r + 1), $orig_array, ($o + 1));
				
			if($result[0] > 0 && $result[1] > 0)
				return array("1", "1");
			else
				return $result;
		}
		else	
			return array("1", "1");
	}
	else
	{
		if($debug_2)
			print("6 - ");
		
		if($debug)
			print("4. Fail with " . $current_r . " (" . ($r + 1) . ") - " . $current_o . " (" . ($o + 1) . ") - not a known valid match\n");

		return array("0", "0");
	}

}

function deAccent($char1)
{
	global $accents;
	
	$new_char1 = "";
	
	for($c = 0; $c < mb_strlen($char1, 'UTF-8'); $c++)
	{
		$current_c = mb_substr($char1, $c, 1, 'UTF-8');
		$added = false;
		
		//print("Testing : " . $current_c . "\n");
			
		foreach($accents as $letter => $linked)
		{
			if($current_c == $letter || in_array($current_c, $linked[1]))
			{
				$new_char1 .= $letter;	
				$added = true;
			}
						
		}
		
		if(!$added)
			$new_char1 .= $current_c;
	}
	
	//print("Result : " . $new_char1 . "\n");
	
	if($new_char1 != "")
		return $new_char1;
	else
		return $char1;
}

function vowelMatch($char1, $char2 = "", $extended=false)
{
	//if given 1 arg checks if letter is in the vowel table
	//if given 2 args checks if two vowels are the same base letter whatever the accents
	//if given 3 args also checks if it is a 'sound-a-like' match or whether it is potentially a 'sound-a-like' vowel if no second argument is given
	
	global $accents;
	
	//print("Testing: " . $char1 . " - " . $char2 . "\n");
		
	foreach($accents as $letter => $linked)
	{
		//print("Letter: " . $letter . "\n");
		
		if($char2 == "")
		{
			if($char1 == $letter || in_array($char1, $linked[1]))
			{
				if($extended)
					return homophoneMappingMatch(mb_strtolower($letter, 'UTF-8')); //always send unaccented, lowercase version of letter
				else
					return true;
			}
			
		}
		else
		{
			if($char1 == $letter || in_array($char1, $linked[1]))
			{
				$matching = $accents[$linked[0]];
				//print_r($matching);
				
				$accented = $matching[1];
				//print_r($accented);

				// if char2 matches the unaccented version (same case) OR the unaccented version (alt case) OR is in the accented array (alt case) OR is in the accented array (same case) OR is the same letter
				if($char2 == $matching[0] || $char2 == $linked[0] || in_array($char2, $accented) || in_array($char2, $linked[1]) || $char1 == $char2)
				{	
					//print("Match!");
						return true;	
				}
				elseif($extended)
				{
					
					if(in_array($char2, $accented) || in_array($char2, $linked[1])) // in accented array - need to get unaccented version
					{
						//print("A. Testing extended vowels with " . $letter. " and " . $linked[0] . "\n");
						return homophoneMappingMatch($letter, $linked[0]); 
					}
					else
					{
						//print("B. Testing extended vowels with " . $letter . " and " . $char2 . "\n");
						return homophoneMappingMatch($letter, $char2); 
					}
				}
			}
		}
	}

	return false;
	
}

function homophoneMappingMatch($char1, $char2="")
{
	// Char1 and Char2 may be single characters or strings of characters!!
	
	$char1 = mb_strtolower($char1, 'UTF-8');
	$char2 = mb_strtolower($char2, 'UTF-8');
	
	//print("homophoneMappingMatch - Testing char1 " . $char1 . " - char2 " . $char2 . "\n");
	
	global $homophone_pairs;
	
	if($char2 == "")
	{
		if(array_key_exists($char1, $homophone_pairs))
			return true;
	}
	else
	{

		if(array_key_exists($char1, $homophone_pairs) && in_array($char2, $homophone_pairs[$char1]))
		{
			//char1 is one of the single letter array keys and char2 matches one of the letters in the associated array
			return true;
		}
		else
		{
			return false;
		}	
	}
}

function homophoneMatches($current_r, $o, $orig_array, $curr_matches, $debug=false)
{

	global $homophone_pairs;
	
	$exceptions = array("αι" => "η", "ηι" => "η", "ο" => "ω");
	
	$length = count($orig_array);
	
	$current_r = mb_strtolower($current_r, 'UTF-8');
	
	/*
	print("Before:\n");
	print("current_r: " . $current_r . "\n");
	print_r($curr_matches);
	*/
	$longest = 0;
	$poss_matches = $homophone_pairs[$current_r];
			
	foreach($poss_matches as $poss)
	{
		if(mb_strlen($poss, 'UTF-8') > $longest)
			$longest = mb_strlen($poss, 'UTF-8');
	}
	
	
	$expanding_o = "";
	//$len = 0;
	$allowed = true;
	

	
	for($i=0; $i < $longest; $i++)
	{				
		if($o + $i < $length)
		{
		
			$expanding_o .= deAccent($orig_array[($o + $i)]);
			$expanding_o = mb_strtolower($expanding_o, 'UTF-8');
			
			if($debug)
				print("current_o: " . $expanding_o . "\n");
			
			foreach($exceptions as $part1 => $part2)
			{
				if(($expanding_o == $part1 && $current_r == $part2) || ($expanding_o == $part2 && $current_r == $part1))
				{
					if(($o + $i) == ($length - 1))
					{
						$allowed = false;
						
						if($debug)
							print("Match between " . $current_r . " and " . $expanding_o . " not allowed at end of string\n");
					}
				}
			}
		
			if(homophoneMappingMatch($current_r, $expanding_o) && $allowed)
			{
				//$len = $i;
				
				if($debug)
					print($current_r . " - " . $expanding_o . " - Match\n");
				
				if(array_key_exists($current_r, $curr_matches))
					array_push($curr_matches[$current_r], $expanding_o);
				else
					$curr_matches[$current_r] = array($expanding_o);
					
				
			}
			/*else
			{
				print($current_r . " - " . $expanding_o . " - Didn't Match\n");
			}*/
		}
	}
	
	/*
	print("After:\n");
	print_r($curr_matches);
	*/	
	return $curr_matches;
				
}

function decode_2byte_utf8 ( $utf8_char )
{
       $val = ord($utf8_char[1]) & 63;
       $val2 = ord($utf8_char[0]) & 31;

       $valAll = ($val2 << 6) | $val;

       return(dechex($valAll));
}

function accentShift($char1, $char2, $limited=false, $inv=false)
{
	$accent = "";
	global $consonants;
	$breathing_marks = array(pack("C2", 0xCC, 0x93), pack("C2", 0xCC, 0x94));
	
	//cc92 = 312
	//cc93 = 313
	//cc94 = 314
	
	// If a vowel in orig already has diacritics, then don't add any more to it but do add breathing marks and vice versa
	// If the character in reg has u+0345 as part of it then do not transfer that part across if orig is ι and υ (but transfer the rest of the accent across)
	
	// accent should only be copied across onto vowel so last_letter has to be last letter in the string that is a vowel 
	// TO DO - If reg is more than one letter long and orig is more than two letters long and there are vowels in both halves then accents from the first letter in reg should go onto the last vowel in the first half of the orig and accents from the second letter in reg should go onto the last vowel in the second half of the orig

	//print("Accent Shift - Test: " . $char1 . " -> " . $char2 . "\n");

	if(mb_strlen($char1, 'UTF-8') > 1)
	{
		for($c = 0; $c < mb_strlen($char1, 'UTF-8'); $c++)
		{
			$decomped = Normalizer::normalize(mb_substr($char1, $c, 1, 'UTF-8') , Normalizer::FORM_D );
			if(mb_substr($decomped, 1, (mb_strlen($decomped, 'UTF-8') - 1), 'UTF-8') != "")
			{	
				if($limited) // if limited then only copy across breathing marks or everything but breathing marks if also $inv
				{
					//print("A. Limited Char 1: " . $char1 . " -> " . $decomped . "\n");
				
					for($a = 1; $a < mb_strlen($decomped, 'UTF-8'); $a++)
					{
						//print("A. Looking for limited accent - c: " . $c . " a: " . $a . "\n");
						
						//print("Accent: " . mb_substr($decomped, $a, 1, 'UTF-8') . " (" . decode_2byte_utf8(mb_substr($decomped, $a, 1, 'UTF-8')) . ")\n");
						//print_r($hex_array);
						
						if(in_array(mb_substr($decomped, $a, 1, 'UTF-8'), $breathing_marks))
						{
							//print("Accent is breathing mark\n");
							if(!$inv) // accent is a breathing mark and inverse is set to false
							{
								$accent .= mb_substr($decomped, $a, 1, 'UTF-8');
								//print("A. Limited Accent: " . $accent . "\n");	
							}	
						}
						else
						{
							//print("Accent is not breathing mark\n");
							
							if($inv) // accent is not a breathing mark and inverse is set to true
							{
								$accent .= mb_substr($decomped, $a, 1, 'UTF-8');
								//print("A. Inverse Limited Accent: " . $accent . "\n");	
							}
						}
						//else
						//	print("A. Limited Accent is not a breathing mark\n");	
					}						
				}
				else
				{
					$accent .= mb_substr($decomped, 1, (mb_strlen($decomped, 'UTF-8') - 1), 'UTF-8'); // get all accents
					//print("A. Accent: " . $accent . "\n");	
				}
			}		
		}
		
		$decomped = Normalizer::normalize( $char1, Normalizer::FORM_D );
	}
	else
	{
		$decomped = Normalizer::normalize( $char1, Normalizer::FORM_D );
		
		if($limited)
		{
			//print("B. Limited Char 1: " . $char1 . " -> " . $decomped . "\n");
			
			//print("String length: " . mb_strlen($decomped, 'UTF-8') . "\n");
			
			for($a = 1; $a < mb_strlen($decomped, 'UTF-8'); $a++)
			{
				//print("B. Looking for limited accent: " . $a . "\n");

				if(in_array(mb_substr($decomped, $a, 1, 'UTF-8'), $breathing_marks))
				{
					if(!$inv) // accent is a breathing mark and inverse is set to false
					{				
						$accent = mb_substr($decomped, $a, 1, 'UTF-8');
						//print("B. Limited Accent: " . $accent . "\n");
					}		
				}
				else
				{
					if($inv) // accent is not a breathing mark and inverse is set to true
					{
						$accent .= mb_substr($decomped, $a, 1, 'UTF-8');
						//print("B. Inverse Limited Accent: " . $accent . "\n");	
					}
				}				
				//else
				//	print("B. Limited Accent is not a breathing mark\n");	
			}
					
		}
		else
		{
			$accent = mb_substr($decomped, 1, (mb_strlen($decomped, 'UTF-8') - 1), 'UTF-8');
			//print("C. Accent: " . $accent . "\n");
		}
	}
	
	
	if(mb_strlen($char2, 'UTF-8') > 1)
	{
		//get last vowel
		$last_letter = "";
		//print("Strlen: " . mb_strlen($char2, 'UTF-8') . "\n");
		for($z = (mb_strlen($char2, 'UTF-8') - 1); $z > -1 && $last_letter == ""; $z--)
		{
			$current_letter = mb_substr($char2, $z, 1, 'UTF-8');
			//print("Z: " . $z . " (" . $current_letter . "/" . $char2 . ")\n");
			if(!in_array($current_letter, $consonants) && $current_letter != " ")
				$last_letter = $current_letter;
		}
	}
	else
		$last_letter = $char2;
		
	//print("Last letter: " . $last_letter . " and accent " . $accent . "\n");
	
	// if no accent or no last letter meaning there are no vowels then don't bother	
	
	if($accent != "" && $last_letter != "")
	{	
			
		//print("Last Letter: " . $last_letter . "\n");
	
		if(($last_letter == "ι" || $last_letter == "υ") && mb_strpos($accent, 'ͅ', 0, 'UTF-8') !== false) // don't copy u+0345 across if letter is ι or υ
		{
			$accent = mb_substr($accent, 0, mb_strpos($accent, 'ͅ', 0, 'UTF-8'), 'UTF-8');
			print("Not copying accent across as last letter is ι or υ and accent contains ͅ\n");
		}
		
		$decomped_orig = Normalizer::normalize($last_letter, Normalizer::FORM_D );	
		$orig_accent = mb_substr($decomped_orig, 1, (mb_strlen($decomped_orig, 'UTF-8') - 1), 'UTF-8');
		
		//print("Last letter: " . $last_letter . " decomped: " . $decomped_orig . "\n");
		
		$shift = false;
		
		if($orig_accent == "") // if orig doesn't already have an accent then copy accent across
			$shift = true;
		elseif(mb_strlen($orig_accent, 'UTF-8') == 1 && mb_strlen($accent, 'UTF-8') == 1)  // both reg and orig have one accent on
		{     
			// if reg accent is a breathing mark and orig accent is not a breathing mark
			if(in_array($accent, $breathing_marks) && !in_array($orig_accent, $breathing_marks))
				$shift = true;
			else
			{
				// if reg accent is not a breathing mark and orig accent is a breathing mark
				if(!in_array($accent, $breathing_marks) && in_array($orig_accent, $breathing_marks))
					$shift = true;
			}
		}
		elseif(mb_strlen($orig_accent, 'UTF-8') == 1) // orig has one accent already, reg is trying to copy more than one across. Only want to copy across the right one.
		{
			for($a = o; $a < mb_strlen($accent, 'UTF-8'); $a++)
			{
				$current_a = mb_substr($accent, $a, 1, 'UTF-8');
				
				if(in_array($current_a, $breathing_marks) && !in_array($orig_accent, $breathing_marks))
				{
					$accent = $current_a;
					$shift = true;
				}
				
				if(!in_array($current_a, $breathing_marks) && in_array($orig_accent, $breathing_marks))
				{
					$accent = $current_a;
					$shift = true;
				}
				
			}
		}

		
		// TO DO - if the second letter is i or u the breathing mark goes on that 
		// 			unless the first letter is w or n and the second letter is i, in which case it goes on the first letter as normal
			
		if($shift) //Don't add accent if it already has an accent (unless it is a breathing mark)
		{	
			//print($char2 . " accent shift\n");
			if(mb_strlen($char2, 'UTF-8') > 1)
			{	
				//print($char2 . " is longer than one character\n");
				
				//if($char1 == "ῶ" && $char2 == "ωι" || $char1 == "ῆ" && $char2 == "ηι")
				
				if((deAccent($char1) == "ω" || deAccent($char1) == "ωι") && ($char2 == "ωι" || $char2 == "οι"))
				{
					//accent goes on first letter
					//print("A - special case. Accent goes on first letter\n");
						
					$first_letter = mb_substr($char2, 0, 1, 'UTF-8');
					
					$accented_first_letter = Normalizer::normalize( $first_letter.$accent, Normalizer::FORM_C );
					$recomped = $accented_first_letter . mb_substr($char2, 1, (mb_strlen($char2, 'UTF-8') - 1), 'UTF-8');						
				}				
				elseif((deAccent($char1) == "ηι" || $char1 == "ῃ") && $char2 == "ει")
				{
					//accent goes on first letter
					//print("B - special case. Accent goes on first letter\n");
						
					$first_letter = mb_substr($char2, 0, 1, 'UTF-8');
					
					$accented_first_letter = Normalizer::normalize( $first_letter.$accent, Normalizer::FORM_C );
					$recomped = $accented_first_letter . mb_substr($char2, 1, (mb_strlen($char2, 'UTF-8') - 1), 'UTF-8');		
						
				}
				elseif((deAccent($char1) == "ηι" || deAccent($char1) == "η") && $char2 == "ηι")
				{
					//accent goes on first letter
					//print("B - special case. Accent goes on first letter\n");
						
					$first_letter = mb_substr($char2, 0, 1, 'UTF-8');
					
					$accented_first_letter = Normalizer::normalize( $first_letter.$accent, Normalizer::FORM_C );
					$recomped = $accented_first_letter . mb_substr($char2, 1, (mb_strlen($char2, 'UTF-8') - 1), 'UTF-8');					
				
				}
				elseif(mb_substr($char2, 1, 1, 'UTF-8') == "ι" || mb_substr($char2, 1, 1, 'UTF-8') == "υ")
				{
						//accent goes on second letter
						
						$accented_last_letter = Normalizer::normalize( $last_letter.$accent, Normalizer::FORM_C );
						
						$backwards = "";
						$recomped = "";
						$toSet = true;
						
						for($c = (mb_strlen($char2, 'UTF-8') - 1); $c > -1; $c--)
						{					
							$current_letter = mb_substr($char2, $c, 1, 'UTF-8');
							//print("C: " . $c . " (" . $current_letter . "/" . $char2 .  ")\n");
							
							if($current_letter == $last_letter && $toSet)
							{
								$backwards .= $accented_last_letter;
								$toSet = false;
							}
							else
								$backwards .= $current_letter;
						}
						
						//print("Backwards: " . $backwards . "\n");
						
						for($c = (mb_strlen($backwards, 'UTF-8') - 1); $c > -1; $c--)
						{
							$recomped .= mb_substr($backwards, $c, 1, 'UTF-8');
						}						
				}
				else
				{
					//accent goes on first letter 
						
					$first_letter = mb_substr($char2, 0, 1, 'UTF-8');
					
					$accented_first_letter = Normalizer::normalize( $first_letter.$accent, Normalizer::FORM_C );
					$recomped = $accented_first_letter . mb_substr($char2, 1, (mb_strlen($char2, 'UTF-8') - 1), 'UTF-8');						
				}	
				
				//print("Recomped: " . $recomped . "\n");
						
			}
			else
				$recomped = Normalizer::normalize($last_letter.$accent, Normalizer::FORM_C );
			
		}
		else
		{
			//print($char2 . " is one character\n");
			$recomped = mb_substr($char2, 0, (mb_strlen($char2, 'UTF-8') - 1), 'UTF-8') . $last_letter;		
		}
		
		if($char2 != $recomped)	
		{
			print("Char 1: " . $char1 . " -> " . $decomped . "\n");
			print("Accent: " . $accent);
			for($i = 0; $i < (mb_strlen($accent) - 1); $i++)
			{
				print (" (" . decode_2byte_utf8(mb_substr($accent, $i, 1, 'UTF-8')) . ")");
			}
			print("\n");
			print("Char 2: " . $char2 . " -> " . $recomped . "\n");
		}
		
		return $recomped;
		
	}
	else
		return $char2;	
	
} 

function replaceSpaces($original, $new_orig_array)
{
	
	$orig_split = mb_split("\s+", $original);
	
	//print_r($orig_split);
	
	$pos = -1;
	
	foreach($orig_split as $part_num => $part)
	{
		if(($part_num + 1) != count($orig_split))
		{
			$part_length = mb_strlen($part, 'UTF-8');
			
			$pos = $pos + $part_length;
			//print("Next space at " . $pos . "\n");
			$letter_count = 0;
	
			foreach($new_orig_array as $key => $letter_group)
			{
				//print($key . " - " . $letter_group . "\n");
				if(mb_strlen($letter_group, 'UTF-8') == 1)
				{			
					//print("A. Letter count: " . $letter_count . " (" . $letter_group . ")\n" );
					if($letter_count == $pos)
					{
						//print("A. Insert space after " . $letter_group . "\n");
						$new_orig_array[$key] = $letter_group . " ";
					}
						
					$letter_count++;
				}
				else
				{
				
					$new_string = "";
					for($i = 0; $i < mb_strlen($letter_group, 'UTF-8'); $i++)
					{
						if(mb_substr($letter_group, $i, 1, 'UTF-8') != " " && mb_substr($letter_group, $i, 1, 'UTF-8') != "'")
						{
							//print("B. Letter count: " . $letter_count . " (" . mb_substr($part, $i, 1, 'UTF-8'). ")\n");
							if($letter_count == $pos)
							{
								//print("B. Insert space after " . mb_substr($letter_group, $i, 1, 'UTF-8') . "\n");	
								$new_string .= mb_substr($letter_group, $i, 1, 'UTF-8') . " ";
							}
							else
								$new_string .= mb_substr($letter_group, $i, 1, 'UTF-8');				
							
							$letter_count++;
						}
						else
							$new_string .= mb_substr($letter_group, $i, 1, 'UTF-8');		
							
					}
					
					//print($key . " - " . $new_string . "\n");
					$new_orig_array[$key] = $new_string;						
				}
				
				if($letter_count > $pos)
					break;
			}					
		}
	}
	
	//print_r($new_orig_array);
	return $new_orig_array;	
}

function tailendAccentSwitch($reg, $orig)
{
	
	//print("Running tailAccentSwitch on " . $reg . "/" . $orig .  "\n");
	$locked_o_array = array();
	$locked_r_array = array();
	$match_array = array();
	
	$reg_array = array();
	
	for($r = 0; $r < mb_strlen($reg, 'UTF-8'); $r++)
	{
		array_push($reg_array, mb_substr($reg, $r, 1, 'UTF-8'));
	}

	
	//print_r($reg_array);
	
	$orig_array = array();

	for($o = 0; $o < mb_strlen($orig, 'UTF-8'); $o++)
	{
		array_push($orig_array, mb_substr($orig, $o, 1, 'UTF-8'));
	}
	
	//print_r($orig_array);
	
	
	/* Starting at the end of Reg
		get last letter
			check if last letter is the final letter in any homophone sets. Find the longest that the set could theoretically be.
		
		for incrementally expanding strings up to the length of the longest match 
			check if it matches against the incrementally expending final section of orig
				add matches to array
				if there is only one possible match then lock that and the matches leading up to it
				preceding letter is a vowel other than ι and current letter is ι or υ then the vowel cannot match as a single unit
				
		for each match in array 
			get the lengths of the reg and orig sections and use that as a starting point for the next section to check for matching
			
			repeat until there are no matches		
			
		When as long a string as possible has been locked in the array then do an accent shift on those matches sets of characters
			
	*/
	
	
	
	$r = mb_strlen($reg, 'UTF-8') - 1;
	$o = mb_strlen($orig, 'UTF-8') - 1;
	
	$continue = true;
	
	$paths = array();
	$level = 0;
	
	$poss_matches = array();
		
	//print("R: " . $r . " O:" . $o . "\n");
	
	//$lowest_match = getMatchArray($reg_array, $r, $orig_array, $o, array($r, $o));
	//$sub_reg_array = array_slice($reg_array, $lowest_match[0]);
	//$sub_orig_array = array_slice($orig_array, $lowest_match[1]);	
	
	for($i = 1; $i <= count($reg_array) && $i <= count($orig_array); $i++)
	{
		$r_position = count($reg_array) - $i;
		$current_r = $reg_array[$r_position];
		
		$o_position = count($orig_array) - $i;
		$current_o = $orig_array[$o_position];
		
		//print("Tail end match testing - r: " . $current_r . " (" . $r_position . "). o: " . $current_o . " (" . $r_position . ")\n");
			
		if(deAccent($current_o) == deAccent($current_r))
		{
			$lowest_match = array($r_position, $o_position);
			//print("Match\n");
		}
		else
		{
			//print("r: " . $current_r . " (" . $r_position . "). o: " . $current_o . " (" . $r_position . ") don't match\n");
			break;
		}
	}
	
	$sub_reg_array = array_slice($reg_array, $lowest_match[0]);
	$sub_orig_array = array_slice($orig_array, $lowest_match[1]);	
	
	//print("Results:");
	//print_r($lowest_match);
	
	$result = tokenise($sub_reg_array, $sub_orig_array);
	
	if($result != false)
	{
		$alt_r_array = $result[0];
		$alt_o_array = $result[1];
		$match = true;
		
		
		/*print("Match!\n");*/
		print("Alt Alt Array:\n");
		print_r($alt_r_array);
		print("Alt Alt Array:\n");
		print_r($alt_o_array);
		
		
		$new_orig = mb_substr($orig, 0, $lowest_match[1], 'UTF-8');
	
		for($l = 0; $l < count($alt_o_array); $l++)
		{
			$new_orig .= accentShift($alt_r_array[$l], $alt_o_array[$l], true, true);
		}	
		
		return $new_orig;	
		
	}
	else
	{
		$match = false;
		//print("No match!\n");
		return $orig;
	}
		
	

		
	//print("Ending tailendAccentSwitch function here\n");

}

function getMatchArray($reg_array, $r, $orig_array, $o, $path, $debug=false)
{
	global $homophone_pairs;	
	
	$current_r_string = $reg_array[$r];
	$current_o_string = $orig_array[$o];

	
	if($debug)
		print("Current R: " . $current_r_string . " current O: " . $current_o_string . "\n");
		
	$max_r_length = 1;
	$max_o_length = 1;
	$poss_matches = array();
	
	foreach($homophone_pairs as $key => $matches)
	{
		if(deAccent($current_r_string) == mb_substr($key, -1, 1, 'UTF-8'))
		{
			//print("Potentially matches " . $key . "\n");
			
			if(mb_strlen($key, 'UTF-8') > $max_r_length)
				$max_r_length = mb_strlen($key, 'UTF-8');
			
			foreach($matches as $match)
			{
				if(mb_strlen($match, 'UTF-8') > $max_o_length)
					$max_o_length = mb_strlen($match, 'UTF-8');
			}
		}
	}
	
	//print("Value of R: " . $r . " (" . $reg_array[$r] . ")\n");
	
	for($i = 0; $i < $max_r_length; $i++)
	{
		$ri = $r - $i;
		
		//print("Value of RI: " . $ri . " (" . $reg_array[$ri] . ")\n");
					
		for($j = 0; $j < $max_o_length; $j++)
		{
			$oj = $o - $j;
			
			if($ri > -1 && $oj > -1)
			{
				
				//print("Value of O: " . $o . " (" . $orig_array[$o] . ")\n");
				//print("Value of OJ: " . $oj . " (" . $orig_array[$oj] . ")\n");
				
				$current_r = $reg_array[$ri];
				$current_o = $orig_array[$oj];
				
				if($ri > 0)
					$preceding_r = $reg_array[($ri - 1)];
				else
					$preceding_r = "";
				
				if($oj > 0)	
					$preceding_o = $orig_array[($oj - 1)];
				else
					$preceding_o = "";
					
				//print("\nValue of R-pair ending " . $ri . ": " . $preceding_r . $current_r . "\n");	
				//print("Value of O-pair ending " . $oj . ": " . $preceding_o . $current_o . "\n");		
				
				//preceding letter is a vowel other than ι and current letter is ι or υ then the vowel cannot match as a single unit
				
				if((($current_r == "ι" || $current_r == "υ") && (vowelMatch($preceding_r) && $preceding_r != "ι")) || (($current_o == "ι" || $current_o == "υ") && (vowelMatch($preceding_o) && $preceding_o != "ι")) )	
				{
					if($debug)
						print("MA - Vowel pair - don't include " . $current_r . " (" . $ri . ") /" . $current_o . " (" . $oj . ")\n");
				}
				else
				{							
					//print("MA - Testing from " . $current_r . " (" . $ri . ") /" . $current_o . " (" . $oj . ")!!\n");
					
					$result = matchTest($reg_array, $ri, $orig_array, $oj);
						
					if($result[0] > 0 && $result[1] > 0)
					{
						/*
						print("Value of R: " . $r . "\n");
						print("Value of RI: " . $ri . "\n");
						print("Value of O: " . $o . "\n");
						print("Value of OJ: " . $oj . "\n");
						*/
						//print("Result: ");
						//print_r($result);
					
						if(array_key_exists($ri, $poss_matches))
							array_push($poss_matches[$ri], $oj);
						else
							$poss_matches[$ri] = array($oj);
					}
	
				}
			}	
		}
	}	
	
	//print_r($poss_matches);
	
	if(count($poss_matches) == 0)
	{
		if($debug)
			print("No matches\n");
			
		return false;
	}
	else
	{
		foreach($poss_matches as $new_r => $new_os)
		{	
			foreach($new_os as $new_o)
			{
				$next_r = $new_r - 1;
				$next_o = $new_o - 1;
				if($next_r > -1 && $next_o > -1)
				{
					if($debug)					
						print("Recursively calling function with " . $next_r . ", " . $next_o . " from " . $r . ", " . $o . " (lowest: " . $path[0] . "-" . $path[1] . ")...\n");
					
					$new_path = getMatchArray($reg_array, $next_r, $orig_array, $next_o, $path);
					
					if($debug)
						print("... End recursion\n");
					
					if($new_path == false)
					{
						$path[0] = $new_r;
						$path[1] = $new_o;
						
						if($debug)
							print("A. Setting path value to " . $path[0] . "-" . $path[1] . "\n");						
					}
					elseif($new_path[0] <= $path[0] && $new_path[1] <= $path[1])
					{
						$path[0] = $new_path[0];
						$path[1] = $new_path[1];
						
						if($debug)
							print("B. Setting path value to " . $path[0] . "-" . $path[1] . "\n");
					}
														
				}
				else
				{
					$path[0] = $new_r;
					$path[1] = $new_o;
					
					if($debug)
						print("C. Setting path value to " . $path[0] . "-" . $path[1] . "\n");	

				}
			}
		}
		
		if($debug)
			print("Returning path value: " . $path[0] . "-" . $path[1] . "\n");
			
		return $path;				
	}
	
}


function exceptions($reg, $orig)
{
	//print("Function exceptions\n");
	$recomped = $orig; 
	
	if(deAccent($reg) == 'αν' && $orig == 'εαν')
	{
		// move the breathing mark (1FBD) to the 'ε' and whatever else is there to the 'α'
		
		$decomped = Normalizer::normalize(mb_substr($reg, 0, 1, 'UTF-8'), Normalizer::FORM_D );
		$breathing_mark = mb_substr($decomped, 1, 1, 'UTF-8');
		$other_accent = mb_substr($decomped, 2, 1, 'UTF-8');
		
		$first_letter = mb_substr($orig, 0, 1, 'UTF-8');		
		$accented_first_letter = Normalizer::normalize( $first_letter.$breathing_mark, Normalizer::FORM_C );	
		
		$second_letter = mb_substr($orig, 1, 1, 'UTF-8');		
		$accented_second_letter = Normalizer::normalize( $second_letter.$other_accent, Normalizer::FORM_C );
		
		$recomped = $accented_first_letter . $accented_second_letter . mb_substr($orig, 2, 1, 'UTF-8');				
		
	}
	elseif(deAccent($reg) == 'εως' && $orig == 'ως')
	{
		// move the both accents from the 'ε' to the 'ω' 
		
		$decomped = Normalizer::normalize(mb_substr($reg, 0, 1, 'UTF-8') , Normalizer::FORM_D );
		
		if(mb_substr($decomped, 1, (mb_strlen($decomped, 'UTF-8') - 1), 'UTF-8') != "")
			$accent = mb_substr($decomped, 1, (mb_strlen($decomped, 'UTF-8') - 1), 'UTF-8');
			
		$first_letter = mb_substr($orig, 0, 1, 'UTF-8');
		
		$accented_first_letter = Normalizer::normalize( $first_letter.$accent, Normalizer::FORM_C );
		$recomped = $accented_first_letter . mb_substr($orig, 1, (mb_strlen($orig, 'UTF-8') - 1), 'UTF-8');		
	}
	
	if($orig != $recomped)	
	{
		print("Changed by exceptions function:\n");
		print("Char 1: " . $reg . " -> " . $decomped . "\n");
		print("Accent: " . $accent . $breathing_mark . $other_accent . "\n");
		print("Char 2: " . $orig . " -> " . $recomped . "\n");
	}
	
	return $recomped;	
}

function kaiwords($reg, $orig)
{
	/*
	και εγω
	και εμοι
	και εμον
	και εμου
	και εαν
	και αυτ[3]
	
	// TO DO - The breathing mark on the first letter/letter pair of the second word of the reg string should be copied to the first vowel/vowel pair of the orig string
	// TO DO - The accent on the last vowel in the reg string (wherever it is) should be copied across to the final vowel in the orig string (wherever it is)
	*/
	mb_regex_encoding("UTF-8");
	$kaiwords = mb_split("\s+", $reg);
	
	//print("Number of chunks: " . count($kaiwords) . "\n");
	
	if(count($kaiwords) > 2)
	{
		//print("Too many parts returning: " . $orig . "\n");
		return $orig;
	}
	
	//print("Reg: " . $reg . "\n");
	//print("Orig: " . $orig . "\n");
	//print_r($kaiwords);
	
	$word = $kaiwords[1];
	

	$first_r_vowel = "";
	$last_r_vowel = "";
	$last_used = "";
	
	//print("Word: " . $word . "\n");
	
	for($r = (mb_strlen($word, 'UTF-8') - 1); $r > -1; $r--)
	{
	
		$current_r = mb_substr($word, $r, 1, 'UTF-8');
		//print("Checking " . $current_r . "\n");
		
		if(vowelMatch($current_r))
		{
			//print("Is vowel\n");
			
			if($last_used == ($r + 1))
			{
				// part of vowel set

				if($first_r_vowel == "")
				{
					// Add to last vowel
					$last_r_vowel = $current_r . $last_r_vowel;
					$last_used = $r;
				}
				else
				{
					// Add to first vowel
					$first_r_vowel = $current_r . $first_r_vowel;
					$last_used = $r;
				}				
			
			}
			else
			{
				if($last_r_vowel == "")
				{
					// Set last vowel
					$last_r_vowel = $current_r;
					$last_used = $r;
				}
				else
				{
					// Sel first vowel
					$first_r_vowel = $current_r;
					$last_used = $r;
				}
			}
		}
	}
	
	//print("Reg - First vowel/vowel pair: " . $first_r_vowel . " Last vowel/vowel pair: " . $last_r_vowel . "\n");
		
	
	
	$first_o_vowel = "";
	$last_o_vowel = "";
	$last_used = "";
	
	$reverse_orig = "";
	$tempstring = "";
	$penaltimate = true;
	
	$first = "";
	
	for($c = 0; $c < mb_strlen($orig, 'UTF-8') && $first == ""; $c++)
	{
		$check = mb_substr($orig, $c, 1, 'UTF-8');
		
		if(vowelMatch($check))
			$first = $c;
	}
	
	for($o = (mb_strlen($orig, 'UTF-8') - 1); $o > -1; $o--)
	{
	
		$current_o = mb_substr($orig, $o, 1, 'UTF-8');
		//print("\nChecking " . $current_o . " (" .  $o. ")\n");
		
		if(vowelMatch($current_o))
		{
			//print($current_o . " is vowel\n");
			
			if($last_used == ($o + 1))
			{
				// part of vowel set

				if($first_o_vowel == "")
				{
					// Add to last vowel
					$last_o_vowel = $current_o . $last_o_vowel;
					
					//print("Z. Setting last vowel to " . $last_o_vowel . "\n");
					$last_used = $o;
				}
				else
				{
					// Add to first vowel
					$first_o_vowel = $current_o . $first_o_vowel;
					//print("A. Setting first vowel to " . $first_o_vowel . "\n");
					
					$last_used = $o;
										
					if($o == $first)
					{						
						$accented_first_letter = accentShift($first_r_vowel, $first_o_vowel, true);	
						
						//print("A. Shifting accents for first vowel set " . $first_r_vowel . " + " . $first_o_vowel . " -> ");
						
						$reversed_accented_first_letter = "";
						
						for($i = 1; $i < (mb_strlen($accented_first_letter, 'UTF-8') + 1); $i++)
						{
							$reversed_accented_first_letter .= mb_substr($accented_first_letter, -$i, 1, 'UTF-8');
						}	
						
						//print($reversed_accented_first_letter . "\n");
										
						$reverse_orig .= $reversed_accented_first_letter;
						//print("A. Adding " . $reversed_accented_first_letter . "\n");
						$tempstring = "";
						$penaltimate = false;
					}
					else
					{
						$tempstring .= $current_o;
					}
				}				
			
			}
			else
			{
				if($last_o_vowel == "")
				{
					// Set last vowel
					$last_o_vowel = $current_o;
					$last_used = $o;
					//print("B. Setting last vowel to " . $last_o_vowel . "\n");
				}
				else
				{
					// Sel first vowel
					$first_o_vowel = $current_o;
					$last_used = $o;
					//print("B. Setting first vowel to " . $first_o_vowel . "\n");
					
					if($o == $first)
					{	
						$accented_first_letter = accentShift($first_r_vowel, $first_o_vowel, true);	
						
						//print("B. Shifting accents for first vowel set " . $first_r_vowel . " + " . $first_o_vowel . " -> ");
						
						$reversed_accented_first_letter = "";
											
						for($i = 1; $i < (mb_strlen($accented_first_letter, 'UTF-8') + 1); $i++)
						{
							$reversed_accented_first_letter .= mb_substr($accented_first_letter, -$i, 1, 'UTF-8');
						}	
						
						//print($reversed_accented_first_letter . "\n");
										
						$reverse_orig .= $reversed_accented_first_letter;
						//print("B. Adding " . $reversed_accented_first_letter . "\n");
						$tempstring = "";
						$penaltimate = false;
					}
					else
					{
						$tempstring = $first_o_vowel;
					}					
				}
			}
		}
		else
		{
			if($last_used == ($o + 1))
			{
				if($first_o_vowel == "")
				{
					// Add converted last vowel(s)
					
					$accented_last_letter = accentShift($last_r_vowel, $last_o_vowel);	
					
					//print("C. Shifting accents for last vowel set " . $last_r_vowel . " + " . $last_o_vowel . " -> ");
					
					$reversed_accented_last_letter = "";
					
					for($i = 1; $i < (mb_strlen($accented_last_letter, 'UTF-8') + 1); $i++)
					{
						$reversed_accented_last_letter .= mb_substr($accented_last_letter, -$i, 1, 'UTF-8');
					}	
					
					//print($reversed_accented_last_letter . "\n");
																			
					$reverse_orig .= $reversed_accented_last_letter . $current_o; 
					//print("C. Adding " . $reversed_accented_last_letter . $current_o . "\n");
					
				}
				elseif($o == $first)
				{
					// Add converted first vowel(s)		
								
					$accented_first_letter = accentShift($first_r_vowel, $first_o_vowel, true);	
					
					//print("D. Shifting accents for first vowel set " . $first_r_vowel . " + " . $first_o_vowel . " -> ");
					
					$reversed_accented_first_letter = "";
										
					for($i = 1; $i < (mb_strlen($accented_first_letter, 'UTF-8') + 1); $i++)
					{
						$reversed_accented_first_letter .= mb_substr($accented_first_letter, -$i, 1, 'UTF-8');
					}	
					
					//print($reversed_accented_first_letter . "\n");
					
					$reverse_orig .= $reversed_accented_first_letter . $current_o; 
					//print("D. Adding " . $reversed_accented_first_letter . $current_o . "\n");
					$tempstring = "";
					$penaltimate = false;
				}
				else
				{
					
					
					if($penaltimate)
					{
						$accented_first_letter = accentShift($first_r_vowel, $first_o_vowel, true);	
						
						//print("EE. Shifting accents for penaltimate vowel set " . $first_r_vowel . " + " . $first_o_vowel . " -> ");
						
						$reversed_accented_first_letter = "";
											
						for($i = 1; $i < (mb_strlen($accented_first_letter, 'UTF-8') + 1); $i++)
						{
							$reversed_accented_first_letter .= mb_substr($accented_first_letter, -$i, 1, 'UTF-8');
						}	
						
						//print($reversed_accented_first_letter . "\n");
										
						$reverse_orig .= $reversed_accented_first_letter . $current_o; 
						//print("EE. Adding " . $reversed_accented_first_letter . $current_o . "\n");
						$tempstring = "";	
						$penaltimate = false;			
					
					}
					else
					{
						//print("E. Adding " . $tempstring . $current_o . "\n");
						$reverse_orig .= $tempstring . $current_o;
					}
						
					$tempstring = "";
				}
								
			}
			else
			{
				//print("F. Adding " . $current_o . "\n");
				$reverse_orig .= $current_o;
			}
		}
		
		/*
			print("Temp string is: " . $tempstring . "\n");
			if($penaltimate)
				print("Penultimate is true\n");
			else
				print("Penultimate is false\n");	
			print("Reverse orig is: " . $reverse_orig . "\n");
		
		*/
	}
	
	//print("Orig - First vowel/vowel pair: " . $first_o_vowel . " Last vowel/vowel pair: " . $last_o_vowel . "\n");
	
	//print("Reverse Orig: " . $reverse_orig . "\n");
	
	$new_orig = "";
	
	for($o = (mb_strlen($reverse_orig, 'UTF-8') - 1); $o > -1; $o--)
	{
		$new_orig .=  mb_substr($reverse_orig, $o, 1, 'UTF-8');
	}
	//print("Old Orig: " . $orig . "\n");
	//print("New Orig: " . $new_orig . "\n");
	
	return $new_orig;
}

?>
