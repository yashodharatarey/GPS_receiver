%https://natronics.github.io/blag/2014/gps-prn/

function genhex_G1G2(num_shifts,samples_per_ms,G1_init,G2_init)
addpath ../InSignal
taps1=[3 10];           %Feedback Taps
taps2=[2 3 6 8 9 10];   %Feedback Taps

G1_file=[]; %Characters to be printed in file
G2_file=[]; %Characters to be printed in file
cp_file=[]; %Characters to be printed in file


G1=G1_init;
G2=G2_init;

code_length=1023;

%Phase per sample in 32 bit format
phase_per_sample=(code_length/samples_per_ms);

cp=phase_per_sample;shift=0;    %initial phase and shift

shifts=zeros(1,num_shifts); %Stores all shifts 
    
cp32=zeros(1,code_length);
cp32(1)=fix(phase_per_sample*2^32);  %Stores all Code phase (after scaling of 2^32)

for i= 1:num_shifts
cp_floor=floor(cp);

if(i>1)
    cp32(i)=mod((cp32(i-1)+cp32(1)),2^32);
end

if(shift)
a=mod(sum(G1(taps1)),2);    %FEEDBACK
b=mod(sum(G2(taps2)),2);    %FEEDBACK
G1=[a G1(1:9)]; %SHIFT
G2=[b G2(1:9)]; %SHIFT
end

%Calculation of Next Phase and Shift
cp=cp+phase_per_sample;
shift=(cp_floor~=floor(cp));

shifts(i)=shift;

chr1G1=retchar(G1(7:10));chr2G1=retchar(G1(3:6));chr3G1=retchar([0 0 G1(1:2)]);
chr1G2=retchar(G2(7:10));chr2G2=retchar(G2(3:6));chr3G2=retchar([0 0 G2(1:2)]);

G1_file=[G1_file chr3G1 chr2G1 chr1G1 char(10)];
G2_file=[G2_file chr3G2 chr2G2 chr1G2 char(10)];
cp_file=[cp_file rethex(cp32(i),32) char(10) ];
end

shftchr=[];
for i=1:num_shifts-7
    chrshft1=retchar(shifts(i:i+3));
    chrshft2=retchar(shifts(i+4:i+7));
    shftchr=[shftchr chrshft1 chrshft2 char(10)];
end

fileID = fopen('GA.hex','w');
fwrite(fileID,G1_file);
fclose(fileID);
fileID = fopen('GB.hex','w');
fwrite(fileID,G2_file);
fclose(fileID);
fileID = fopen('shifts.hex','w');
fwrite(fileID,shftchr);
fclose(fileID);
fileID = fopen('cp.hex','w');
fwrite(fileID,cp_file);
fclose(fileID);
end
% %% 

function out=retchar(in)
 kkk=sum(in.*([8 4 2 1]));
 if(kkk>9)
     kkk=kkk+55;
 else
     kkk=kkk+48;
 end
 out=char(kkk);
end
