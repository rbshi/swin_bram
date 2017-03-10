function [ ret ] = xilinx_mif_gen( mif_file_name, hex_mat, mem_width )
% generate the memory initialize file for Xilinx FPGA

assert(size(hex_mat,2)==mem_width/4, ...
    'The 2nd dinmension of variable ''hex_mat'' should be corresponding to mem_width');


mem_depth = size(hex_mat,1);
mem_width = size(hex_mat,2)*4; % width of binary

mif_fid = fopen(mif_file_name,'w');

% Note: Xilinx use the MIF file without any header information
% % DEPTH = 512;
% fprintf(mif_fid, 'DEPTH = %d;\r\n', mem_depth);
% 
% % WIDTH = 64;
% fprintf(mif_fid, 'WIDTH = %d;\n', mem_width);
% 
% % ADDRESS_RADIX = HEX;
% fprintf(mif_fid, 'ADDRESS_RADIX = HEX;\n');
% 
% % DATA_RADIX = HEX;
% fprintf(mif_fid, 'DATA_RADIX = HEX;\n');
% 
% % CONTENT
% % BEGIN
% fprintf(mif_fid, 'CONTENT\nBEGIN\n\n');
% 
% % ADDR    :    VALUE;
% for idx_addr = 1:mem_depth
%     fprintf(mif_fid, '%X\t:\t%s;\n', idx_addr-1, hex_mat(idx_addr,:));
% end
% fprintf(mif_fid, '\nEND;\n');

for idx_addr = 1:mem_depth
    fprintf(mif_fid, '%s\n', lower(hex_mat(idx_addr,:)));
end

fclose(mif_fid);

ret = 1;

end

