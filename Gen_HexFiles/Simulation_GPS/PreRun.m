function PreRun(I,Q,filename)
Data_i_in=downsample(I,4);
Data_q_in=downsample(Q,4);
dataIN=Data_i_in+1i*Data_q_in;
save(filename,'dataIN');
end