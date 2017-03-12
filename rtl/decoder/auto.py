#!/usr/bin/env python
from sys import argv
import sys
import math

if __name__ == '__main__':

    if len(argv) < 3:
        print 'Example: \'auto.py case.txt 16\' output file name: case.txt'
        sys.exit(0)
    else:
        filename_output = argv[1]
        length = int(argv[2])

    f_out = open(filename_output, 'w')

    print 'Generating...'

    for line_num in range(0, length):
        f_out.write('%d: reg_wr_data_s0 <= { %d\'b0, pix_data_in_d1[8*16-1:8*%d] };\n' %(line_num, (16-line_num)*8 ,(16-line_num)))

    f_out.close()
