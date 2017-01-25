import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help="name of input hex file")
parser.add_argument("-o", "--output", help="name of output hex file")
args = parser.parse_args()

plain_hex = open(args.input, 'r')
new_hex = open(args.output, 'w')

hex_code = plain_hex.read()
hex_code = "".join(hex_code.split())

new_hex.write(hex_code.decode('hex'))

plain_hex.close()
new_hex.close()
