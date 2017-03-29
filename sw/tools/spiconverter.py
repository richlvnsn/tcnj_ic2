import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help="name of input hex file")
parser.add_argument("-o", "--output", help="name of output hex file")
args = parser.parse_args()

plain_hex = open(args.input, 'r')
new_hex = open(args.output, 'w')

lines = plain_hex.readlines()

new_hex.write("00\n20\n00\n00\n")

for line in lines:
	for x in range(14,-1,-2):
		new_hex.write(line[x:x+2] + '\n')

new_hex.close()
