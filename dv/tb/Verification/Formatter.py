import sys

#Formatter is for converting .csv files into .tv files for proper verification

fileName = sys.argv[1]

with open("fileName.csv") as infile, open("fileName.tv", "w") as outfile:
    for line in infile:
        outfile.write(line.replace(",", ""))