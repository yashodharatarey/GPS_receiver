function str_out=rethex(num_in,No_of_bits_per_sample)

No_of_nibbles_per_sample=ceil(No_of_bits_per_sample/4);

% Two's complement for negative numbers
if(num_in < 0)
	num_in = 2^No_of_bits_per_sample +num_in;
end

%Pre Allocation
str_out=repmat(char(0),1,No_of_nibbles_per_sample); 

%Conversion of Radix from 10 to 16
for ii = 1:No_of_nibbles_per_sample
char_temp=mod(num_in,16);
    if(char_temp>9)
		char_temp=char_temp+55;
    else
		char_temp=char_temp+48;
    end
str_out(No_of_nibbles_per_sample-ii+1)=char(char_temp);
num_in = floor(num_in/16);
end

end