samplesPerMillisecond=2000;
reqdSATS=1:32;

taps1=[3 10];
taps2=[2 3 6 8 9 10];

outs1=10;
SVouts2=[
 2,6;
 3,7;
 4,8;
 5,9;
 1,9;
 2,10;
 1,8;
 2,9;
 3,10;
 2,3;
 3,4;
 5,6;
 6,7;
 7,8;
 8,9;
 9,10;
 1,4;
 2,5;
 3,6;
 4,7;
 5,8;
 6,9;
 1,3;
 4,6;
 5,7;
 6,8;
 7,9;
 8,10;
 1,6;
 2,7;
 3,8;
 4,9;
];

code_length=1023;
code_out=zeros(length(reqdSATS),samplesPerMillisecond);
len=10;
a_nl=[];
lengthreqd=500;prn_file=[];
for SATno =1
outs2=SVouts2(SATno,:);
G1=ones(1,10);
G2=ones(1,10);

code=zeros(1,code_length);
for i= 1:code_length
a=mod(sum(G1(taps1)),2);
b=mod(sum(G2(taps2)),2);
out1=mod(sum(G1(outs1)),2);
out2=mod(sum(G2(outs2)),2);
code(i)=mod((out1+out2),2);
G1=[a G1(1:len-1)];
G2=[b G2(1:len-1)];
end

%SAMPLING
codeValueIndex = ceil((1:samplesPerMillisecond)*1023/samplesPerMillisecond);
code_out(SATno,:)=code(codeValueIndex);
for i= 1:lengthreqd
    chr1=retchar(code_out(SATno,((i-1)*4+1):(4*i)));
    prn_file=[prn_file chr1 char(10)];
end
    
end
fileID = fopen('Codeall.hex','w');
fwrite(fileID,prn_file);
fclose(fileID);
function out=retchar(in)
 kkk=sum(in.*([8 4 2 1]));
 if(kkk>9)
     kkk=kkk+55;
 else
     kkk=kkk+48;
 end
 out=char(kkk);
end

