addpath ../Prncode/
clear all;




code_out=prntable(32,4000,1);
code1=code_out(1,:);
navbit=repmat(code1,1,20);
message=[navbit -navbit];
Ts=1/(4e6);Ts_milli=1/(4e3);Ts_micro=1/4;
time=0:Ts:(40e-3)-Ts;

freq_in_khz=(-5 + 10*rand);
message_dop=message.*exp(-1i*2*pi*freq_in_khz*1e3*time);

start=randi(length(message));

tapped_chunk=message_dop(start:start+4000-1);
t_chunk=0:Ts_micro:1000-Ts_micro;t_chunk_exp=0:Ts:1e-3 - Ts ;
view_start=randi(4000);
t_view=0:Ts_micro:20-Ts_micro;


frequencies=-5e3:500:5e3;

hitfreq=freq_in_khz*1e3;
[~,hitbin]= min(abs(hitfreq-frequencies));
codephase_hit = mod(start,4000);
samplesPerCodeChip =  ceil(4000/1023);  %Accurate result obtained when samplesPercode=n*1023;


fig=figure;
% ha=subplot(4,2,4);pos = get(ha, 'position');
% dim = pos.*[1 1 0.5 0.5]+[pos(3) pos(4) 0 0];
% annot=annotation(fig, 'textbox', dim, 'String', sprintf('AR : %f',1), 'FitBoxToText','on',  'verticalalignment', 'bottom');
samplesPerMs=4000;
imcount=1;count_fig=0;

for frq_ind = 1:21
f=frequencies(frq_ind);    
tapped_chunk_rot = tapped_chunk .* exp(1i*2*pi*f*t_chunk_exp);
view_rx_msg=tapped_chunk_rot(view_start:view_start+4*20-1);
subplot(5,2,[9,10]);
codefig=plot(0,0);
xlim([0 samplesPerMs]);

corrsum=[];
for shft = 0:4000

shiftcode=[code1(shft+1 : end) code1(1:shft)];
code_view=shiftcode(view_start:view_start+4*20-1);
if(abs(shft-codephase_hit)<10)
    slow_down=1.5;
elseif(frq_ind==hitbin && abs(shft-codephase_hit)<10)
    slow_down=10;
else
    slow_down=1;
end
    
corrsum=[corrsum abs(sum(tapped_chunk_rot.*shiftcode))];

for rep=1:floor(slow_down)
count_fig=count_fig+1;

if((mod(count_fig,500)==0 && slow_down==1) || (slow_down~=1))
subplot(5,2,1);plot(t_chunk,real(tapped_chunk_rot));title(sprintf('Frequency : %.4f KHz',f/1000));legend('In Phase');
subplot(5,2,2);plot(t_chunk,imag(tapped_chunk_rot));legend('Quadrature');
subplot(5,2,7);plot(t_chunk,imag(tapped_chunk_rot.*shiftcode));title(sprintf('After stripping code',f/1000));
subplot(5,2,8);plot(t_chunk,real(tapped_chunk_rot.*shiftcode));
subplot(5,2,3);plot(t_view,real(view_rx_msg));subplot(5,2,4);plot(t_view,imag(view_rx_msg));
subplot(5,2,5);plot(t_view,code_view);title(sprintf('Shift : %d',shft), 'HorizontalAlignment', 'right');
subplot(5,2,6);plot(t_view,code_view);
set(codefig,'XData',1:length(corrsum));
set(codefig,'YData',corrsum);
filename = sprintf('./images/fig%d.jpg',imcount);
imcount=imcount+1;
saveas(fig,filename);
drawnow();
end

end

end

[peakSize,codePhase] = max(corrsum);
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
    secondPeakSize = max(corrsum(codePhaseRange));
    metric=peakSize/secondPeakSize;

end
