% This script is used to genetrate the configuration mif file

clear; clc;
close all;

% Remainder Group
% # pixel per line
line_pix_num = 94;

% N_in
batch_size = 16;

extra_group = [];

% remainder evalution


% line_pix_num_tmp = line_pix_num;

remainder_tmp = ceil(line_pix_num/batch_size)*batch_size - line_pix_num;

while (remainder_tmp)
    
%     line_pix_num_tmp = line_pix_num + (batch_size - mod(line_pix_num_tmp, batch_size));

    extra_group = [extra_group; remainder_tmp];

    line_pix_num_tmp = line_pix_num - remainder_tmp;
    
    remainder_tmp = ceil(line_pix_num_tmp/batch_size)*batch_size - line_pix_num_tmp;
    
end

% Add the fist and last extra 0 to extra_group

extra_group = [0; extra_group; 0];

% configuration generate

% | split | ret  | cycle | order | offset |
% |-------+------+-------+-------+--------|
% | 4bit  | 1bit | 8bit  | 3bit  | 3bit   |

config_mat = [];

for ii = 1:size(extra_group, 1)-1
    
    % the offset is only counted in one BRAM, the whole offset is also
    % indicated by the line initial order (shuffle_flag)
    offset = mod(extra_group(ii), 8);
    
    if extra_group(ii) > 7
        order = 6; % 3'b110
    else
        order = 3 % 3'b011
    end
    
    % -1 coz the hardware logic is 0-based
    cycle = ceil((line_pix_num-extra_group(ii))/batch_size)-1;
    
    if(ii==size(extra_group, 1)-1)
        ret = 1;
    else
        ret = 0;
    end
    
    split = extra_group(ii+1);
    
    % Transformation
    conf_bin = strcat(dec2bin(split,4), dec2bin(ret,1), dec2bin(cycle,8), dec2bin(order,3), dec2bin(offset,3));
    conf_hex = dec2hex(bin2dec(conf_bin),5);
   
    config_mat = [config_mat; conf_hex];
    
end

% Dump to the mif file
mif_file_name = '../testdata/conf_file.mif'

xilinx_mif_gen(mif_file_name, config_mat, 20);


    
    
    


