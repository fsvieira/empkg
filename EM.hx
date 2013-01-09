class Display{
	
	public static function print(s : String){
		#if js
			var d = js.Lib.document.getElementById("display"); 
			d.innerHTML += StringTools.replace(s, "\n", "<br>"); 
		#elseif cpp
			cpp.Lib.print(s); 
		#elseif java	
			java.lang.System.out.print(s); 
		#end
	}
	
}


class Node {
	var hits : Int; 
	var number : Int; 
	var left : Node; 
	var right: Node; 

	public function new(number, left, right){
		this.number = number; 
		this.left = left; 
		this.right = right; 
		hits = 0; 
	}
	
	public function create(max, i ) : Int {
		if(max > 1){
			left = new Node(0, null, null); 
			right = new Node(0, null, null); 
			
			var l_max = Math.floor(max/2); 
			var r_max = max - l_max;  
			
			number = left.create(l_max, i); 
			return right.create(r_max, number); 
		}else{
			number = i; 
			return i+1; 
		}
	}

	public function count(number, c){
		hits += c; 
		if(number >= this.number){
			if(right != null){
				right.count(number, c); 
			}
		}else{
			if(left != null){
				left.count(number, c); 
			}
		}
	}
	
	public function print(){
		Display.print(" node = ( hits=" + hits +", number=" + number +", left=");
		if(left != null){
			left.print(); 
		}else{
			Display.print("null"); 
		}
		Display.print(", right="); 
		if(right != null){
			right.print(); 
		}else{
			Display.print("null"); 
		}
		Display.print(" );\n\n"); 
	}
	
	
	public function getDigit() : Int {
		hits++; 
		if(left != null && right != null ){
			if(left.hits < right.hits){
				left.hits = right.hits; 
				return left.getDigit();	
			}else if(left.hits > right.hits){
				right.hits = left.hits; 
				return right.getDigit();	
			}else{
				var r = Std.random(2); 
				if(r==0){
					return left.getDigit();	
				}else{
					return right.getDigit();	
				}
			}
		}else{
			return number; 
		}
	}
	
}

class NumberStars{
	public var numbers : Array<Int>;
	public var stars:Array<Int>; 
}


class EM {
	
	static var numbers; 
	static var stars; 
	static var url = "http://fsvieira.com/empkg/em_keys.json"; 
	
    public static function main() {
		numbers = new Node(0, null, null); 
		numbers.create(50, 1); 
		stars = new Node(0, null, null); 
		stars.create(11, 1); 		
		populate(); 
		genRandomKey(100); 
    }
    
	public static function genKeys(max){
		var i; 
		for(i in 0...max){
			var keyNumbers = numberGen(5, numbers);
			var keyStars = numberGen(2, stars); 
			var i; 
			Display.print("numbers: "); 
			printKey(keyNumbers); 
			Display.print(", stars: ");
			printKey(keyStars);
			Display.print("\n"); 	
		}
	}

	public static function genRandomKey(max){
		var i = Std.random(max); 
		var keyNumbers, keyStars; 
		Display.print("iterations: " + i + ", "); 
		
		do{
			keyNumbers = numberGen(5, numbers);
			keyStars = numberGen(2, stars);  
			i--; 
		}while(i > 0);
		
		
		
		Display.print("numbers: "); 
		printKey(keyNumbers); 
		Display.print(", stars: ");
		printKey(keyStars);
		Display.print("\n"); 	
		
	}


	static function ord(a:Int, b:Int) : Int {
		return a - b; 
	}

	static function printKey(key : Array<Int> ){
		var random = 0.0; 
		key.sort(ord); 	
		for(i in key){
			Display.print(" "+ i); 
		}
	}

	#if java
		@:functionBody("
			try{
				java.net.URL link = new java.net.URL(url);
				java.net.URLConnection con = link.openConnection();
				java.io.InputStream in = con.getInputStream();
				java.lang.String encoding = con.getContentEncoding();
				encoding = encoding == null ? \"UTF-8\" : encoding;
				java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
				byte[] buf = new byte[8192];
				int len = 0;
				while ((len = in.read(buf)) != -1) {
					baos.write(buf, 0, len);
				}
				String body = new String(baos.toByteArray(), encoding);
				return body; 
			}catch(Exception e){
				return \"[]\"; 
			}
		")
    #end
    static public function getUrl(url) : String {
		#if !java
			return haxe.Http.requestUrl(url); 
		#else 
			return ""; 
		#end
		
	}
    
    static public function populate(){
		// TODO: if cant getUrl get a local file (C++/Java)
		var s = getUrl(url); 
		var em : Array<Dynamic> = haxe.Json.parse(s); 
		var i, n, s; 
			
		for(i in em){
		   for(n in 0...i.numbers.length){
				numbers.count(i.numbers[n], 1); 
		   }
			   
		   for(s in 0...i.stars.length){
				stars.count(i.stars[s], 1); 
		   }
		}

	}
    
    static public function isIn(a : Array<Int>, n : Int) : Bool {
		var i; 
		for(i in a){
			if(i == n){
				return true; 
			}
		}
		
		return false; 
	}
    
    static public function numberGen(max, numbers) : Array<Int> {
		var i; 
		var key = []; 
		var number; 
		for(i in 0...max){
			
			do{
				number = numbers.getDigit(); 
			}while(isIn(key, number)); 

			key[i] = number; 

		}
		
		return key; 
	}
    
    
}
