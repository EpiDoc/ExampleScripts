<?php 
	mb_internal_encoding("UTF-8");
	
	//print("Start PHP\n");
	
	$doAll = true;
		
	include 'accentLib.php';
	loadGlobalValues();
	
	
   	if(file_exists('kill.flg'))
   		unlink('kill.flg');	
   		
   		
	$cmd = "java -cp .:/Applications/oxygen/lib/saxon9he.jar TransformServer list-unique-reg-orig_expanded.xsl";
	exec($cmd . " > /dev/null &");

	//print("Java started\n");

   	if(file_exists('reg-orig.txt'))
   		unlink('reg-orig.txt');	
   		
		
	$log = fopen('log.txt', 'w');	
   				
	$paths = glob('DDB_EpiDoc_XML/bgu.4/*.xml');
	$output_path = "DDB_EpiDoc_XML2/run5/";
	
	$top = realpath('svn/DDB_EpiDoc_XML');
	
	$regOrigValues = array();
	
	if($doAll)
	{
		foreach (new RegexIterator(new RecursiveIteratorIterator(new RecursiveDirectoryIterator($top), RecursiveIteratorIterator::CHILD_FIRST), '/^.+\.xml$/i', RecursiveRegexIterator::GET_MATCH ) as $file) 
		{
			$path = $file[0];
		
			processFile($path, $log);
		}
   	}
   	else
   	{		   		
		foreach($paths as $path)
		{			
			//print("Processing " . $path . "\n");
			processFile($path, $log);			
		}
	}
	
	// write file kill.flg
	
	file_put_contents("kill.flg", "");
	
	fclose($log);	
	
	
function processFile($path, $log)
{
	global $output_path;
	
	print("File: " . $path . "\n");
	fwrite($log, "Processing " . $path . "\n");
			
	$path_sections = explode("/", $path);
	
	$internal_path = "";
	$dir_path = "";
	
	for($i = 0; $i < count($path_sections); $i++)
	{
		if($i > 0)
		{
			$internal_path .= $path_sections[$i];
			
			if($i < (count($path_sections) - 1))
			{
				$dir_path .= $path_sections[$i] . "/";
				$internal_path .= "/";
			}
		}
	}
	
	
	//if(substr($path, -6, 2) == ".3")
	//{
		$regOrigValues = getRegOrigValues($path, $log);
		$current_file = file_get_contents($path);
		
		$count = 1;
		
		if(count($regOrigValues) > 0)
		{
		
			//print_r($regOrigValues);
			
			$regOrigConverted = convertFile($regOrigValues, $log, true);
			
			//print_r($regOrigConverted);
								
			foreach($regOrigConverted as $string => $ROPairs)
			{
				$orig_values = $ROPairs[1];
				$reg_values = $ROPairs[0];
				$string = str_replace("@", "\n", $string); 
				
				$new_orig = tagReplace($orig_values[0], $orig_values[1], $log);
				
				//print_r($orig_values);
				//print($new_orig . "\n");
				
				$new_string = str_replace("@", "\n", $reg_values[1]) . $new_orig;
				
				$current_file = str_replace($string, $new_string, $current_file);
				
				fwrite($log, $count . ": " . str_replace("\n", " ", $string) . " -> " . str_replace("\n", " ", $new_string) . "\n");
				$count++;
				
			}
			
			fwrite($log, "Converted file written to: " . $output_path . $internal_path . "\n");
		}
		else
			fwrite($log, "Copying file to: " . $output_path . $internal_path . " (no reg/orig tags found)\n");
		
		//print("Directory path: " . $output_path . $dir_path . "\n\n");
		
		if(!file_exists($output_path . $dir_path))
			mkdir($output_path . $dir_path, 0777, true);
			
			
		file_put_contents($output_path . $internal_path, $current_file);
		
	//	break;
	//}
	
}	
	

function getRegOrigValues($path, $log)
{

	$print = false;
	
	if($print)
		$outcome = fopen('reg-orig.txt', 'a');	


	$list = array();	
	//fwrite($log, "Loaded " . $path . "\n");	
	
	// Need to write a file called sourcename.txt which contains $path
	
	file_put_contents("sourcename.txt", $path);
	
	// Create a file called process.flg
	
	file_put_contents("process.flg", "");
	
	// create loop while process.flg exists
	// output.txt will be created which is the new temp.txt
	
	//fwrite($outcome, $result);
	
	while(file_exists('process.flg'))
	{
		usleep(100000);
	}
	
	if(file_exists('output.txt'))
	{
	
		//$temp = fopen('temp.txt', 'r');
		//$result = fgets($temp);
		
		$temp = file_get_contents('output.txt');
		//print("Got output.txt\n");
		
		
		$lines = explode("@@", $temp);
		
		print_r($lines);
		
		foreach($lines as $result)
		{
			if(trim($result) != "")
			{
				//print("Result: " . $result . "\n");
			
				$current = explode("@", $result);
				
				$context1 = trim($current[2]);
				$context2 = trim($current[3]);
				$context1 = str_replace(' xmlns="http://www.tei-c.org/ns/1.0"', '', $context1);
				$context2 = str_replace(' xmlns="http://www.tei-c.org/ns/1.0"', '', $context2);
				$context1 = str_replace("\n", "@", $context1); 
				$context2 = str_replace("\n", "@", $context2); 
				$reg = array();
				$orig = array();
				
				//print("Context1: " . $context1 . "\n");
				//print("Context2: " . $context2 . "\n");
				
				if(substr($context1, 1, 3) == "reg")
				{
					$reg = array(trim($current[1]), $context1);
					$orig = array(trim($current[0]), $context2);
				}
				else
				{
					$reg = array(trim($current[1], $context2));
					$orig = array(trim($current[0], $context1));
				}
				
				//print_r($reg);
				//print_r($orig);
				
				$key = $context1.$context2;
				
				if(!array_key_exists($key, $list))
				{
					// Context => array(reg, orig) 
					$list[trim($key)] = array($reg, $orig);
					
					if($print)
						fwrite($outcome, trim($current[1]) . "\t" . trim($current[0]) . "\n");
				}
			}
		}
			
	}
	else
		print("XSLT processed output for " . $path . " not found\n");

	if($print)
		fclose($outcome);
	
	//print_r($list);
	
	return $list;
}

function tagReplace($string, $tagged_string, $log = "")
{
	$string_count = 0;
	$new_string = "";
	$in_tag = false;
	$multibyte = array("ο"=>array(ο͂,ο̂,οͅ,ο̂ͅ,ο̂ͅ,ὀ̂,ὀͅ,ὀ̂ͅ,ὀ̂ͅ,ὁ̂,ὁͅ,ὁ̂ͅ,ὁ̂ͅ), "ε"=>array(ε̂,εͅ,ε̂ͅ,ε̂ͅ,ἐ̂,ἐͅ,ἐ̂ͅ,ἐ̂ͅ,ἑ̂,ἑͅ,ἑ̂ͅ,ἑ̂ͅ));
	
	
	for($i = 0; $i < mb_strlen($tagged_string, 'UTF-8'); $i++)
	{
		
		
		$current_letter = mb_substr($tagged_string, $i, 1, 'UTF-8');
		/*
		print("Current Letter: " . $current_letter . "\n");
		
		if($in_tag)
			print("Currently in tag\n");
		else
			print("Not in tag\n");
		*/
		
		if($in_tag && $current_letter == ">")
		{
			//print("Setting in_tag to false\n");
			$new_string .= $current_letter;
			$in_tag = false;
		}
		elseif($current_letter == "<")
		{
			//print("Setting in_tag to true\n");
			$new_string .= $current_letter;
			$in_tag = true;
		}
		elseif($in_tag || trim($current_letter) == "" || $current_letter == "@")
		{
			// in a tag 
			//print("Adding current letter\n");
			$new_string .= $current_letter;
		}
		else
		{
			//print("Adding letter from untagged string\n");
			
			
			$seed = mb_substr($string, $string_count, 1, 'UTF-8');
			
			if(array_key_exists($seed, $multibyte))
			{
				$count = 1;
				$test = mb_substr($string, $string_count, (1 + $count), 'UTF-8');
				$replacement = mb_substr($string, $string_count, 1, 'UTF-8');
				
				//print("Test: " . $test . "\n");
				
				while(in_array($test, $multibyte[$seed]) && ($string_count + $count) < mb_strlen($string, 'UTF-8'))
				{
					//print("In multibyte array\n");
					$replacement = mb_substr($string, $string_count, (1 + $count), 'UTF-8');
					$count++;
					$test = mb_substr($string, $string_count, (1 + $count), 'UTF-8');
				}
				
				$string_count = $string_count + $count;
			}
			else
			{
				$string_count++;
				$replacement = $seed;
			}
			
			$new_string .= $replacement;
			
		}
		
		//print($i . ": " . $new_string . "\n");
		
		if($i == (mb_strlen($tagged_string, 'UTF-8') - 8) && $string_count != mb_strlen($string, 'UTF-8'))
		{
			if($log != "")
				fwrite($log, "WARNING: Tag replace found string length mismatch.\n");
				
			print("WARNING: Tag replace found string length mismatch.\n");
			
			$new_string .= mb_substr($string, $string_count, (mb_strlen($string, 'UTF-8') - ($string_count - 1)), 'UTF-8');
		}
		
			
	}
	
	return $new_string;

}	
	
?>
