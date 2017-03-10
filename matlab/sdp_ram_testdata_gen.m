% This script is used to generate random test data for the sdp ram module

stream_len = 512;

% the word width of each memory element is 8x8bits
scale = 2^8;
stream_data = floor(rand(stream_len,8)*scale);

fid = fopen('../testdata/input_sdp_ram.txt','w');

for ii = 1:stream_len
    for jj = 1:8
        % It's used to keep the same demension of the char matrix
        if(stream_data(ii,jj)<16);
            stream_data(ii,jj) = stream_data(ii,jj) + 16;
        end
        fprintf(fid, '%x', stream_data(ii,jj));
    end
    fprintf(fid, '\n');
end

fclose(fid);
