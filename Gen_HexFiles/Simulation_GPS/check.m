addpath ../Prncode/
clear all
format long g
samplesPerMs=4000;
PRNtable=prntable(32,4000,1);
freq=-5e3:(10e3/208):5e3-(10e3/208);
% freq=-10e3:(20e3/400):10e3-(20e3/400);

load('data_ila_27_2.mat');
dataIN=double(dataIN);
sig1=dataIN(20001:24000);
sig2=dataIN(24001:28000);
Ts=(1e-3)/samplesPerMs;
t=(0:Ts:(4000-1)*Ts)';
codematrix=ones(samplesPerMs);
frqBinIndex=1:208;
% frqBinIndex=1:400;
%     fprintf('Freq: %d\n',f);
% sig1=sig1.';sig2=sig2.';
signal=[sig1 sig2];

fig=figure;
req_len=30;
%# create AVI object
nFrames = length(frqBinIndex);
vidObj = VideoWriter('myPeaks.avi');
vidObj.Quality = 100;
vidObj.FrameRate = ceil(nFrames/req_len);
open(vidObj);

ha=subplot(2,1,2);pos = get(ha, 'position');
dim = pos.*[1 1 0.5 0.5]+[pos(3)*0.7 pos(4)*0.7 0 0];

annot=annotation(fig, 'textbox', dim, 'String', sprintf('AR : %f',1), 'FitBoxToText','on',  'verticalalignment', 'bottom');




for prn =6
code=PRNtable(prn,:);
max1=0;    
for shft = 0:samplesPerMs-1
   codematrix(shft+1,:)=[code(shft+1 : end) code(1:shft)];%circshift(code,-shft);
end
for chunk=1
    in=signal(:,chunk);
for frq=159
f=freq(frq);
sig1_rot=in.*exp(-2*1i*pi*f*t)*(714/434);

subplot(2,2,1);
scatter(real(sig1),imag(sig1));title('Input');axis('square');
title(sprintf('Frequency %d', frq))

subplot(2,1,2);
scatter(real(sig1_rot),imag(sig1_rot));
annot.String= sprintf('AR : %f',AR(frq));
axis('square');

writeVideo(vidObj, getframe(fig));


for ind=1:samplesPerMs
matr=codematrix(ind,:).*(sig1_rot.');
corrsum1(ind)=sum(matr);

end

result=(abs(corrsum1)*(714/434)).^2;
[sorted,sort_ind]=sort(result,'descend');
if(sorted(1)>max1)
max1=sorted(1);    
hitfreq=freq(frq);freqnum=frq;
chunk_sel=chunk;
    [peakSize,codePhase] = max(result);
    
    % Find the range excluding 1 chip width around the correlation peak 
    samplesPerCodeChip =  ceil(samplesPerMs/1023);  %Accurate result obtained when samplesPercode=n*1023;
    excludeRangeIndex1 = codePhase - samplesPerCodeChip;
    excludeRangeIndex2 = codePhase + samplesPerCodeChip;
    
    % Correct C/A code phase exclude range if the range includes array
    %boundaries
    if excludeRangeIndex1 < 2
        codePhaseRange = excludeRangeIndex2 : (samplesPerMs + excludeRangeIndex1-1);
        
    elseif excludeRangeIndex2 >= samplesPerMs
        codePhaseRange = (excludeRangeIndex2 - samplesPerMs+1) : excludeRangeIndex1;        
        
    else
        codePhaseRange = [1:excludeRangeIndex1, excludeRangeIndex2 : samplesPerMs];
    end
    
    % Find the second highest correlation peak in the same freq. bin
    secondPeakSize = max(result(codePhaseRange));
    metric=peakSize/secondPeakSize;
end
end
end
fprintf('PRN:%d \n',prn);
fprintf('max1/max2 : %f \n',metric);
fprintf('maxfreq :%d \n',hitfreq);
fprintf('freq_id :%d \n',freqnum);
fprintf('codephase :%d \n',codePhase);

end
close(vidObj);
