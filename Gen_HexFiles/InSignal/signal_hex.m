function signal_hex(ipfilename,varname,input_width,complex_,scale,decim,start,opfilenameI,opfilenameQ,No_of_samples_to_save,No_of_samples_per_line)
addpath matfiles/
load(ipfilename);
data=eval(varname);

switch nargin
    case 4
    scale=1;decim=1;start=1;opfilenameI='signalI.hex';opfilenameQ='signalQ.hex';No_of_samples_to_save=length(data);No_of_samples_per_line=1;
    case 5
    decim=1;start=1;opfilenameI='signalI.hex';opfilenameQ='signalQ.hex';No_of_samples_to_save=length(data);No_of_samples_per_line=1;
    case 6
    start=1;opfilenameI='signalI.hex';opfilenameQ='signalQ.hex';No_of_samples_to_save=length(data);No_of_samples_per_line=1;
    case 7
    opfilenameI='signalI.hex';opfilenameQ='signalQ.hex';No_of_samples_to_save=length(data); No_of_samples_per_line=1;
    case 8
    opfilenameQ='signalQ.hex';No_of_samples_to_save=length(data);No_of_samples_per_line=1;
    case 9
   No_of_samples_to_save=length(data);No_of_samples_per_line=1;
end



data=floor(data*2^scale);

string_real=[];string_imag=[];


        
    
    
%%%NAV DATA%%%%%

for num=start:decim:No_of_samples_to_save
    sample=data(num);    
    temp_r=real(sample);    
    str_real=rethex(temp_r,input_width);    
	string_real=[string_real str_real];
    
    if(mod(num,No_of_samples_per_line)==0)
	string_real=[string_real char(10)];
    end
    
    if(complex_)
        temp_i=imag(sample);
        str_imag=rethex(temp_i,input_width);
        string_imag=[string_imag str_imag];
        if(mod(num,No_of_samples_per_line)==0)
           string_imag=[string_imag char(10)];
        end
    end
end
fileID = fopen(opfilenameI,'w');
fwrite(fileID,string_real);
fclose(fileID);
if(complex_)
fileID = fopen(opfilenameQ,'w');
fwrite(fileID,string_imag);
fclose(fileID);
end
end

        
