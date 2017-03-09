% This script is used to analysis the latency of the proposed
% line-buffering scheme and the origianl video frame-buffering scheme. Some
% related parameters (BRAM number, etc.)have been calculated as well.

clc; clear;
close all;


frame_width = 341;     % N_x
frame_height = 123;

% batch_size of the pixel input
N_in = 16;

% word_width, multiple width/depth combinations could be configured for a
% RAM36, we use the 512x72 config to fully ultilize the RAM resource.
N_wd = 8;

% output window size
N_win = 3;

% latency of line_buffering
d_line_buffering = ceil(frame_width * (N_win-1) / N_in);
% latency of frame_buffering
d_frame_buffering = ceil(frame_width * frame_height / N_in);

% BRAM number
n_bram_line_buffering = (ceil(N_in/N_wd)+1)*N_win;
% doubled for the Ping-Pong frame buffer
n_bram_frame_buffering = (ceil(N_in/N_wd)+1)*N_win*frame_height*2;



