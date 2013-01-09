matrix = [[int(i) for i in line.split()] for line in open('number_stars.txt')]

s = "["; 
first = True;

for m in matrix:
	if not first:
		s += ",";
	
	first = False; 
		
	s += "{\"numbers\":[";
	for i in range(len(m)):	
		if i == 5:
			s += "],\"stars\":[";
		
		s += str(m[i]);
		
		if( (i != 4) and (i != 6) ):
			s +=","; 
		
		
	s += "]}"; 


s += "]\n"; 


print s; 
