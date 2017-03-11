% This script is used to generate random test data for the sdp ram module
clear;clc;
close all;

stream_len = 512;

% the word width of each memory element is 8x8bits
scale = 2^8;
stream_data = floor(rand(stream_len,8)*scale);


% It's used to keep the same demension of the char matrix
for ii = 1:stream_len
    for jj = 1:8
        if(stream_data(ii,jj)<16);
            stream_data(ii,jj) = stream_data(ii,jj) + 16;
        end
    end
end

hex_mat = [];

for ii = 1:stream_len
    hex_str = [];
    for jj = 1:8
        hex_str = strcat(hex_str,dec2hex(stream_data(ii,jj)));
    end
    hex_mat = [hex_mat; hex_str];
end

% Temp part of mif_gen
mif_file_name = '../testdata/ram_init.mif'

xilinx_mif_gen(mif_file_name, hex_mat, 64);