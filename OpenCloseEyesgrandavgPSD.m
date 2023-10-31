% 
clear; clc;
close all;
addpath(genpath('eeglab2023.0'));
newset = 0;
subject = 1;   %sub= 1 2 3 4.... 
% subject==1 

set = 1;

if subject ==1
    starting = [11000 8000 11800 16500];
%     toplot = [1 3;5 7;15 16;18 17;26 25;30 29]; %F3 C3 O1 O2 C4 F4
end
%

if newset
    fprintf('enter "eeglab" in the command line');
else
    EEG = pop_loadset();
end
fs = 500; % Sampling rate
%
if subject == 1||2
    channelhydrogel = 18;
    channelgel = 19; 
else  % counterbalance
    channelhydrogel = 19;
    channelgel = 18;
end   

%%
TFdataHg = double(EEG.data(channelhydrogel,starting(set)/(1000/EEG.srate):(100000+starting(set))/(1000/EEG.srate)-1));
TFdatagel = double(EEG.data(channelgel,starting(set)/(1000/EEG.srate):(100000+starting(set))/(1000/EEG.srate)-1));
name = append('TFdata','subject',num2str(subject),'set',num2str(set));
save(name, 'TFdataHg','TFdatagel');
%%

if subject== 1 || 2
    hydro = [1,2,5,6,10,12,14,17,18,20,22,25,27,29,31];
else
    hydro = [3,4,7,8,9,11,13,15,16,19,21,23,24,26,28,30];
end


   %PSD
data = {};
m = 1;
n = 1;
for i = 1:10
    figure;
    title(num2str(i));
    if rem(i,2)
        data.open(:,:,m) = pop_spectopo(EEG, 1, [starting(set)+10000*(i-1)+1 starting(set)+10000*(i)], 'EEG' , 'freqrange',[1 30],'electrodes','off');
        m = m+1;
    else
        data.close(:,:,n) = pop_spectopo(EEG, 1, [starting(set)+10000*(i-1)+1 starting(set)+10000*(i)], 'EEG' , 'freqrange',[1 30],'electrodes','off');
        n = n+1;
    end
end




%%
% [maxEyeCORatio, IndexMax] = max(sum(data.close(1:31,8:13,:),2)./sum(data.open(1:31,8:13,:),2));
% EyeCORatio = sum(abs(data.close(1:31,8:13,:)),2)./sum(abs(data.open(1:31,8:13,:)),2);
%
% subdatanum = append('maxEyeCORatio','_',num2str(subject),'_',num2str(set));
% save(subdatanum,'maxEyeCORatio', 'IndexMax','EyeCORatio');
% subdatanum = append('eyeC','_',num2str(subject),'_',num2str(set));
% save(subdatanum,'EyeCloseSpectra');
%
% figure; plot(1:30,EyeCloseSpectra(18,1:30));hold on; plot(1:30,EyeOpenSpectra(18,1:30)); hold off; legend; ylim([-5 100]);
% figure; plot(1:30,EyeCloseSpectra(17,1:30));hold on; plot(1:30,EyeOpenSpectra(17,1:30)); hold off; legend; ylim([-5 100]);
% 

%%
% if subject == 1||2
%     channelhydrogel = 18;
%     channelgel = 19; 
% else
%     channelhydrogel = 19;
%     channelgel = 18;
% end

figure('Position', [300, 300, 110*10, 53*10]);
for i = 1:5
plot(1:1:30,data.open(channelhydrogel,1:30,i),'LineWidth', 1.5); title('hydrogel'); hold on; %ylim([-60 60]);
end
for i = 1:5
plot(1:1:30,data.close(channelhydrogel,1:30,i),'LineWidth', 1.5); title('hydrogel'); hold on; %ylim([-60 60]);
end
hold off;
title('hydrogel');

figure('Position', [300, 300, 110*10, 53*10]);
for i = 1:5
plot(1:1:30,data.open(channelgel,1:30,i),'LineWidth', 1.5); title('hydrogel'); hold on; %ylim([-60 60]);
end
for i = 1:5
plot(1:1:30,data.close(channelgel,1:30,i),'LineWidth', 1.5); title('hydrogel'); hold on; %ylim([-60 60]);
end
hold off;
title('gel');



%% time-series  (1-30 hz amplitude)

[d1] = bandpassfilter(1,30,EEG.srate,double(EEG.data(channelhydrogel,starting(set)/(1000/EEG.srate):(100000+starting(set))/(1000/EEG.srate)-1)));
[d2] = bandpassfilter(1,30,EEG.srate,double(EEG.data(channelgel,starting(set)/(1000/EEG.srate):(100000+starting(set))/(1000/EEG.srate)-1)));
figure('Position', [300, 300, 110*10, 27*10]);
plot(0:100/49999:100,d1,'LineWidth', 1.5); title('hydrogel'); ylim([-60 60]);
yticks([-60 -30 0 30 60]);
figure('Position', [300, 300, 110*10, 27*10]);
% hold on; 
plot(0:100/49999:100,d2,'LineWidth', 1.5); title('gel'); ylim([-60 60]);
yticks([-60 -30 0 30 60]);
% hold off; legend('hydrogel','gel');
rvalue = corrcoef(d1,d2);

%% time-series alpha power
% --------------------------------------------------------------------------
windowSize = 1*fs;
[d3] = bandpassfilter(8,13,EEG.srate,double(EEG.data(channelhydrogel,starting(set)/(1000/EEG.srate):(100000+starting(set))/(1000/EEG.srate)-1)));
[d4] = bandpassfilter(8,13,EEG.srate,double(EEG.data(channelgel,starting(set)/(1000/EEG.srate):(100000+starting(set))/(1000/EEG.srate)-1)));
d3 = movmean(d3.^2,1000);
d4 = movmean(d4.^2,1000);
Power_rvalue = corrcoef(d3,d4);
figure('Position', [300, 300, 110*10, 27*10]);
plot(0:100/49999:100,d3,'LineWidth', 1.5); hold on;
plot(0:100/49999:100,d4,'LineWidth', 1.5); hold off;

title('alpha power'); ylim([0 300]);
legend('hydrogel', 'gel');


%% PSD + SNR 
if subject == 1||2
    channelhydrogel = 18;
    channelgel = 19; 
else
    channelhydrogel = 19;
    channelgel = 18;
end
% convert Log PSD to PSD standard unit (µV^2/Hz); each element takes element = 10^(element/10)
PSDVL_HgClose = 10.^(data.close(channelhydrogel,1:30,:)./10);
PSDVL_HgOpen = 10.^(data.open(channelhydrogel,1:30,:)./10);
PSDVL_gelClose = 10.^(data.close(channelgel,1:30,:)./10);
PSDVL_gelOpen = 10.^(data.open(channelgel,1:30,:)./10);
% hydrogel
hgPsdOpenavg = mean(PSDVL_HgOpen(1,1:30,:),3);
hgPsdOpenstd = std(PSDVL_HgOpen(1,1:30,:),0,3);
hgPsdCloseavg = mean(PSDVL_HgClose(1,1:30,:),3);
hgPsdClosestd = std(PSDVL_HgClose(1,1:30,:),0,3);
PSD_anlysHydrogel = cat(1,hgPsdOpenavg,hgPsdOpenavg+hgPsdOpenstd,hgPsdOpenavg-hgPsdOpenstd,hgPsdCloseavg,hgPsdCloseavg + hgPsdClosestd,hgPsdCloseavg - hgPsdClosestd);
% 
% gel
gelPsdOpenavg = mean(PSDVL_gelOpen(1,1:30,:),3);
gelPsdOpenstd = std(PSDVL_gelOpen(1,1:30,:),0,3);
gelPsdCloseavg = mean(PSDVL_gelClose(1,1:30,:),3);
gelPsdClosestd = std(PSDVL_gelClose(1,1:30,:),0,3);
PSD_anlysgel = cat(1,gelPsdOpenavg,gelPsdOpenavg + gelPsdOpenstd,gelPsdOpenavg - gelPsdOpenstd, gelPsdCloseavg, gelPsdCloseavg + gelPsdClosestd, gelPsdCloseavg - gelPsdClosestd);


NoiseHgC = mean(reshape(cat(2,PSDVL_HgClose(:,5:7,:),PSDVL_HgClose(:,14:30,:)),[20 5]),1);
NoiseGelC = mean(reshape(cat(2,PSDVL_gelClose(:,5:7,:),PSDVL_gelClose(:,14:30,:)),[20 5]),1);
NoiseHgO = mean(reshape(cat(2,PSDVL_HgOpen(:,5:7,:),PSDVL_HgOpen(:,14:30,:)),[20 5]),1);
NoiseGelO = mean(reshape(cat(2,PSDVL_gelOpen(:,5:7,:),PSDVL_gelOpen(:,14:30,:)),[20 5]),1);
% SoI/Noise PSD 
HgSoIC = reshape(mean(PSDVL_HgClose(:,8:13,:),2),[1 5]);
HgSoIO = reshape(mean(PSDVL_HgOpen(:,8:13,:),2),[1 5]);
gelSoIC = reshape(mean(PSDVL_gelClose(:,8:13,:),2), [1 5]);
gelSoIO = reshape(mean(PSDVL_gelOpen(:,8:13,:),2),[1 5]);

% 
HgINRatioC = HgSoIC./NoiseHgC;
HgINRatioO = HgSoIO./NoiseHgO;
GelINRatioC = gelSoIC./NoiseGelC;
GelINRatioO = gelSoIO./NoiseGelO;
% gelCORatio = reshape(sum(PSDVL_gelClose(:,8:13,:),2)./sum(NoiseGel(:,:,:),2),[1 5]);

% SNR

SNR_HydrogelC = 10.*log(HgINRatioC);
SNR_gelC = 10.*log(GelINRatioC);
% SNR_HydrogelO = 20.*log(HgINRatioO);
% SNR_gelO = 20.*log(GelINRatioO);
    
name = append('sub',num2str(subject),'set',num2str(set),'PSD_SNR');

% save(name, 'PSDVL_HgClose','PSDVL_HgOpen',"PSDVL_gelClose","HgC","HgO","gelC","gelO","PSDVL_gelOpen","HgCORatio","gelCORatio",'SNR_Hydrogel','SNR_gel');
%%  Time-freqency analysis
if subject == 1||2
    channelhydrogel = 18;
    channelgel = 19; 
else
    channelhydrogel = 19;
    channelgel = 18;
end
% plotrange= [11000 111000]; %subject1set1
% plotrange= [11000 111000]; %subject1set3
% plotrange= [87500 190800]; %subject2set1
% plotrange= [20820 124200]; %subject2set3
% plotrange= [3700 107000]; %subject3set1
% plotrange= [3600 107000]; %subject3set3
plotrange= [3000 107000]; %subject4set1
% plotrange= [3600 107000]; %subject4set3
figure;
tfplothydrogel = pop_newtimef(EEG, 1, channelhydrogel, plotrange, [3        0.8] , 'baseline',[0], 'freqs', [5 30], 'erspmax', [15],'plotitc', 'off', 'padratio', 1);
figure;
tfplotgel = pop_newtimef(EEG, 1, channelgel, plotrange, [3        0.8] , 'baseline',[0], 'freqs', [5 30], 'erspmax', [15], 'plotitc', 'off', 'padratio', 1);



