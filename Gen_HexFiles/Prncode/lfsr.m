function code_table=lfsr(code_length,samples_per_ms)


code_table=zeros(1,samples_per_ms);

G1=ones(1,9);        %init G1


outs1=9;     %Output TAPS from G2

taps1=[1 5 9];     %Feedback TAPS from G1


code=zeros(1,code_length);
for i= 1:code_length
a=mod(sum(G1(taps1)),2);    %Feedback G1
code(i)=mod(sum(G1(outs1)),2); 
G1=[a G1(1:9)];         %Shift
end
%SAMPLING
codeValueIndex = ceil((1:samples_per_ms)*code_length/samples_per_ms);
code_table(SATno,:)=code(codeValueIndex);
% BiPolar
code_table(code_table==0)=-1;
end

