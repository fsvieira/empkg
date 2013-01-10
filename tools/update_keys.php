<?php
	// run: php update_keys.php 

	ini_set('display_errors', 'On');
	error_reporting(E_ALL);

	function toJson($numbers, $stars){
		return "{\"numbers\":[" . toString($numbers)
		     ."],\"stars\":[" . toString($stars) . "]}"; 
	}

	function toString($numbers){
		$first = True; 
		$s = ""; 
		foreach($numbers as $n){
			if(!$first){
				$s = $s . "," . $n ; 	
			}else{
				$first = False; 
				$s = $s . $n ; 	
			}
		}
		
		return $s; 
	}

	
	function getKey(){
	
		$url = "https://www.jogossantacasa.pt/web/SCRss/rssFeedCartRes"; 
		$xmlDoc = new DOMDocument();
		$xmlDoc->load($url);
		
		$items=$xmlDoc->getElementsByTagName("item");
		
		$item = $items->item(0); 
		
		$pubDate = $item->getElementsByTagName("pubDate")->item(0)->nodeValue; 
		$description = $item->getElementsByTagName("description")->item(0)->nodeValue; 
		
		
		$key = explode(":", $description); 
		$key = $key[1]; 
		$number = explode("+", $key); 
		
		
		$numbers = explode(" ", trim($number[0])); 
		$stars = explode(" ", trim($number[1])); 
		
		$myFile = "em_keys_". str_replace(" ", "_" , $pubDate) .".json";

		if(!file_exists($myFile)){
			$fh = fopen("em_keys.json", 'r+') or die("can't open file");
			fseek($fh, -1, SEEK_END); 
			$stringData = toJson($numbers, $stars);
		
			fwrite($fh, "," . $stringData . "]");
			fclose($fh);
			system("rm em_keys_* -rf && cp em_keys.json ". $myFile); 
			echo "Updated."; 
			
			// mk statistics 
			$fh = fopen("em_stats.json", 'w+') or die("can't open file");
			
			$string = file_get_contents("em_keys.json");
			$json_a=json_decode($string,true);
			
			$numbers = array(); 
			for($i=0; $i<50; $i++){
				$numbers[$i] =0; 
			}
			
			$stars = array(); 
			for($i=0; $i<11; $i++){
				$stars[$i] =0; 
			}
			
			foreach($json_a as $keys){
				foreach($keys as $key => $val){
					if($key == "numbers"){
						foreach($val as $n){
							$numbers[((int)$n)-1]++; 
						}		
					}else{
						foreach($val as $n){
							$stars[((int)$n)-1]++; 
						}
					}
					
				}
			}
			
			$stringData = "{\"numbers\":["; 
			for($i=0; $i<count($numbers);$i++){
				if($i!= 0){
					$stringData .= "," . $numbers[$i]; 
				}else{
					$stringData .= $numbers[$i]; 
				}
			}
			
			$stringData .= "],\"stars\":["; 
			for($i=0; $i<count($stars);$i++){
				if($i!= 0){
					$stringData .= "," . $stars[$i]; 
				}else{
					$stringData .= $stars[$i]; 
				}
			}
			
			$stringData .= "]}"; 
			
			
			fwrite($fh, $stringData);
			fclose($fh);
			
		}else{
			echo "Nothing to do.";
		}
	
		
	}
	
	getKey(); 
	
?>


