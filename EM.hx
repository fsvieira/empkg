class Display{
	
	public static function print(s : String){
		#if js
			var d = js.Lib.document.getElementById("display"); 
			d.innerHTML += StringTools.replace(s, "\n", "<br>"); 
		#elseif cpp
			cpp.Lib.print(s); 
		#end
	}
	
}

class Info{
	public var number : Int; 
	public var random : Float;
	
	public function new(number, random){
		this.number = number; 
		this.random = random; 
	}
}

class Node {
	var hits : Int; 
	var number : Int; 
	var left : Node; 
	var right: Node; 
	var genHits : Int; 
	
	public function new(number, left, right){
		this.number = number; 
		this.left = left; 
		this.right = right; 
		hits = 0; 
		genHits = 0; 
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

	public function count(number){
		hits++; 
		if(number >= this.number){
			if(right != null){
				right.count(number); 
			}
		}else{
			if(left != null){
				left.count(number); 
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
	
	
	public function getDigit(key, count, random) : Info {
		genHits++; 
		if(left != null && right != null ){
			if( (left.hits < right.hits) && ((left.genHits < right.genHits) || (left.genHits == 0) ) ){
				return left.getDigit(key, count+1, random);	
			}else if( (left.hits > right.hits) && ((left.genHits > right.genHits) || (right.genHits == 0)) ){
				return right.getDigit(key, count+1, random);	
			}else if(left.genHits < right.genHits){
				return left.getDigit(key, count+1, random);		
			}else if(left.genHits > right.genHits){
				return right.getDigit(key, count+1, random);	
			}else{
				var r = Std.random(2); 
				if(r==0){
					return left.getDigit(key, count+1, random+1);	
				}else{
					return right.getDigit(key, count+1, random+1);	
				}
			}
		}else{
			return new Info(number, random/count); 
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
	
    public static function main() {
		numbers = new Node(0, null, null); 
		numbers.create(50, 1); 
		stars = new Node(0, null, null); 
		stars.create(11, 1); 
		populate(); 
		genKeys(5); 
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


	static function printKey(key : Array<Info> ){
		var random = 0.0; 	
		for(i in 0...key.length){
			random += key[i].random; 
			Display.print(" "+ key[i].number); 
		}
		
		Display.print(" (rand=" + Math.round((random/key.length)*100) + "%)"); 
		
	}
    
    
    
    static public function populate(){
		var em : Array<NumberStars>; 
		var s = haxe.Http.requestUrl("em_keys.json"); 
		em = haxe.Json.parse(s); 
		var i, n, s; 
		for(i in 0...em.length){
		   for(n in 0...em[i].numbers.length){
				numbers.count(em[i].numbers[n]); 
		   }
		   
		   for(s in 0...em[i].stars.length){
				stars.count(em[i].stars[s]); 
		   }
		}
	}
    
    static public function numberGen(max, numbers) : Array<Info> {
		var i; 
		var key = []; 
		for(i in 0...max){
			key[i] = numbers.getDigit(key, 0, 0); 
		}
		
		return key; 
	}
    
    
}
