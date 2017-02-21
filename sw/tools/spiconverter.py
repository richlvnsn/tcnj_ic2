"""
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help="name of input hex file")
parser.add_argument("-o", "--output", help="name of output hex file")
args = parser.parse_args()

plain_hex = open(args.input, 'r')
new_hex = open(args.output, 'w')"""

#plain_hex = open("constant.hex", 'r')
new_hex = open("GPIO_SPI.hex", 'w')


with open('GPIO.hex') as h:
    lines = h.readlines()

new_hex.write("00\n20\n00\n00\n")

for line in lines:
	for x in range(14,-1,-2):
		new_hex.write(line[x:x+2] + '\n')
"""
for line in lines:
	for x in range(6,-1,-2):
		new_hex.write(line[x:x+2] + '\n')
	for x in range(14,7,-2):
		new_hex.write(line[x:x+2] + '\n')
"""
new_hex.close()
