import os
targ_dir = "g"
f_list = os.listdir(targ_dir)
for f in f_list:
	full_path = os.path.join(targ_dir, f)
	
	with open(full_path) as file_:
	    lines = file_.readlines();
	    for i in range(0, len(lines)):
	    	lines[i] = lines[i].rstrip() 

	if len(lines) > 0:
		with open(full_path, 'w') as writer:
			for l in lines:
				writer.write(l)
				writer.write("\n")
	        