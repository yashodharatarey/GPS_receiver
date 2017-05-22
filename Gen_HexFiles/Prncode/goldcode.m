%Reference https://natronics.github.io/blag/2014/gps-prn/
function code_table=goldcode(code_length,numsats,samples_per_ms,SVtaps1,SVtaps2,SVouts1,SVouts2,G1_init,G2_init);

reqdSATS=1:numsats; %For all Sats

code_table=zeros(numsats,samples_per_ms);
for SATno =reqdSATS

G1=G1_init(SATno,:);        %init G1
G2=G2_init(SATno,:);        %init G2

outs2=SVouts2(SATno,:);     %Output TAPS from G1

outs1=SVouts1;     %Output TAPS from G2

taps1=SVtaps1;     %Feedback TAPS from G1
taps2=SVtaps2;     %Feedback TAPS from G2


code=zeros(1,code_length);
for i= 1:code_length
a=mod(sum(G1(taps1)),2);    %Feedback G1
b=mod(sum(G2(taps2)),2);    %Feedback G2
out1=mod(sum(G1(outs1)),2); 
out2=mod(sum(G2(outs2)),2);
code(i)=mod((out1+out2),2);
G1=[a G1(1:9)];         %Shift
G2=[b G2(1:9)];         %Shift
end
%SAMPLING
codeValueIndex = ceil((1:samples_per_ms)*code_length/samples_per_ms);
code_table(SATno,:)=code(codeValueIndex);
% BiPolar
code_table(code_table==0)=-1;
end
end

