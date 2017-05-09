import sys

#Formatter is for converting .csv files into .tv files for proper verification

fileName = sys.argv[1]

with open("{}.csv".format(fileName)) as infile: 
	with open("{}.data".format(fileName), "w") as outfile:
		infile.next()
		for line in infile:
			outfile.write(line.replace(",", "_"))
