Start=0;
num_steps=0:29;
Mem_size=2^14;
Time_for_iter=500;
Num_iter=16;
Num_chunks=2;
CC_for_freq=Num_chunks*Num_iter*Time_for_iter;
Num_freq=13;

Time_taken=Num_freq*CC_for_freq;
Speedup=25;
STEP=Time_taken/Speedup;
start_rd=mod(num_steps*8000,Mem_size);
end_rd=mod(start_rd+7999,Mem_size);

start_ptr=repmat(start_rd,STEP,1);
end_ptr=repmat(end_rd,STEP,1);

start_ptr=start_ptr(:);
end_ptr=end_ptr(:);



