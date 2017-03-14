% This script is used to generate the swin input words.
% Format: 128'h

clear; clc;
close all;

stream_len = 512;

pix_num = stream_len * 16;

pix_data = mod([0:pix_num-1],256);

pix_data_2d = reshape(pix_data,16,stream_len)';

hex_mat = [];
for ii = 1:stream_len
    hex_str = [];
    for jj = 1:16
        hex_str = strcat(dec2hex(pix_data_2d(ii,jj),2), hex_str);
    end
    hex_mat = [hex_mat; hex_str];
end

mif_file_name = '../testdata/input_swin.txt'

xilinx_mif_gen(mif_file_name, hex_mat, 128);