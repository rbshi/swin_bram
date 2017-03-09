% This script is used to generate the paraemters of the proposed
% line-buffering scheme.
frame_width = 1280;     % N_x
frame_height = 720;

% batch_size of the pixel input
N_in = 16;

% Output window size
N_win = 3;

% word_width, multiple width/depth combinations could be configured for a
% RAM36, we use the 512x72 config to fully ultilize the RAM resource.
N_wd = 8;

% We only consider the situation that N_in > N_wd and all BRAM are
% configured as 512x72. N_bram_perline is the minimal BRAM banks needed to
% do the write processing.
N_bram_perline = ceil(N_in/N_wd)+1;

% We set standalone BRAMs group for each image line. The group number
% equals to the window size. All the line group structures are the same.

% BRAM number
N_bram = N_bram_perline*N_win;