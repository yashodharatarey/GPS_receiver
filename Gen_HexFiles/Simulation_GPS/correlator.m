addpath ../Prncode/
clear all
samplesPerMs=4000;
PRNtable=prntable(32,4000,1);

freq=-5e3:(10e3/208):5e3-(10e3/208);
PRN=6;

load('data_ila_27_2.mat');
%dataIN=double(dataIN.');

numMs=1;numsamples=numMs*samplesPerMs;start=0;

sig1=dataIN(20001:24000);
sig2=dataIN(24001:28000);
Ts=(1e-3)/samplesPerMs;
t=(0:Ts:(4000-1)*Ts)';
satphase=zeros(1,length(PRN));
satmetric=zeros(1,length(PRN));
satfreq=zeros(1,length(PRN));
code_in=ones(samplesPerMs);
for prn=PRN
    fprintf('Acquiring Satellite No: %d\n',prn);
    satphase(prn)=0;
    satmetric(prn)=0;
    satfreq(prn)=0;
    results = zeros(length(freq),samplesPerMs);
    parts   = zeros(1,length(freq));

    code=PRNtable(prn,:);
    
    for shft = 0:samplesPerMs-1
        code_in(shft+1,:)=[code(shft+1 : end) code(1:shft)];
    end
    codematrix=[code_in];    
    for frqBinIndex=1:length(freq)
%     fprintf('Freq: %d\n',f);
        f=freq(frqBinIndex);
        sig1_rot=sig1.*exp(-2*1i*pi*f*t);
        sig2_rot=sig2.*exp(-2*1i*pi*f*t);       
        corrsum1=codematrix*sig1_rot;
        corrsum2=codematrix*sig2_rot;
        corrsum1=(abs(corrsum1)).^2;
        corrsum2=(abs(corrsum2)).^2;
        
        [firstPeak1,codePhase1]=max(corrsum1);%runner1=0;index1=0;
        [firstPeak2,codePhase2]=max(corrsum2);%runner2=0;index2=0;
        [~,parts(frqBinIndex)] = max([max(corrsum1),max(corrsum2)]);
        results(frqBinIndex,:) = eval(strcat('corrsum',num2str(parts(frqBinIndex))));  %Stores that result which has the highest correlation   
    end
    [peakSize,frequencyBinIndex] = max(max(results,[],2));
    [peakSize,codePhase] = max(results(frequencyBinIndex,:));
    
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
    secondPeakSize = max(results(frequencyBinIndex, codePhaseRange));
    
    % Signal strength of a given satellite PRN
    acqResults.peakMetric(prn) = peakSize/secondPeakSize;
    fprintf('Metric : %f \n',peakSize/secondPeakSize);
    acqResults.codePhase(prn)  = codePhase;
    acqResults.Status(prn)     = acqResults.peakMetric(prn) > 2; %Status of Satellite: 1-Present 0-Absent 
    acqResults.carrFreqAcq(prn)= freq(frequencyBinIndex); 
    acqResults.carrFreqFFT(prn)= acqResults.carrFreqAcq(prn);
    acqResults.part(prn)       = parts(frequencyBinIndex);
    
end
                
               
            
            
        
        