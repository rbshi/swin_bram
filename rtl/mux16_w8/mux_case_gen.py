#!/usr/bin/env python
from sys import argv
import sys
import math

if __name__ == '__main__':

    if len(argv) < 3:
        print 'Example: \'mux_case_gen.py case.txt 16\' for 16 to 1 pixel-wide Multiplexer, output file name: case.txt'
        sys.exit(0)
    else:
        filename_output = argv[1]
        mux_len = int(argv[2])

    f_out = open(filename_output, 'w')

    print 'Generating...'

    for line_num in range(0, mux_len):
        f_out.write('%d: data_out <= data_in[8*%d-1:8*%d];\n' %(line_num, line_num+1, line_num))

    f_out.close()
