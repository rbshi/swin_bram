% This script is used to evalute the remaineder situations

% # pixel per line
dividend = 321;

% N_in
divisor = 16;

extra_group_tab = cell(16,1);

for ii = 0:15
    
    dividend = 20*divisor+ii;


    remainder_group = [];

    extra_group = [];

    while mod(dividend, divisor)

        remainder_group = [remainder_group; mod(dividend, divisor)];

        extra_group = [extra_group; divisor - mod(dividend, divisor)];

        dividend = dividend - (divisor - mod(dividend, divisor));

    end
   
    extra_group_tab{ii+1} = extra_group;
    
end

