% Bit_length=32;
% Doppler_freq=-5e3:50:5e3;
% Sampling_freq=2e6;
% filename='Angles.hex'
function AnglesHex(Doppler_freq,Sampling_freq,Bit_length,filename)
Phase_per_sample=2*pi*(Doppler_freq/Sampling_freq);
Ph_frac_pi=Phase_per_sample/pi;
Ph_Scaled=floor(Ph_frac_pi*2^(Bit_length-1));
No_of_samples_per_line=1;
string_=[];
for i=1:length(Doppler_freq)
    temp=Ph_Scaled(i);
    if(temp<0)
        temp=(2^Bit_length)+temp;
    end
    
        str_=[];
   for ii = 1:ceil(Bit_length/4)

		char_=mod(temp,16);
        if(char_>9)
			char_=char_+55;
        else
			char_=char_+48;
        end        
        str_=[char(char_) str_];
		temp = floor(temp/16);
   end
	string_=[string_ str_];
    if(mod(i,No_of_samples_per_line)==0  && i<length(Doppler_freq))
	string_=[string_ char(10)];
    end
end
fileID=fopen(filename,'w');
fwrite(fileID,string_);
fclose(fileID);
end
