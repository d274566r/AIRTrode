clear;clc;close all;
addpath('eeglab2023.0');
addpath('Sleepscoring');
%%                       
EEG = pop_loadset();
%
EEG_hydro = EEG(1);
EEG_std = EEG(2);
%% 
events_hydro = [];
events_std = [];

% hydro SWS
for i = 1: length(EEG_hydro.event)
event = convertCharsToStrings(EEG_hydro.event(i).type);
events_hydro = [events_hydro event];
end

SWS_hydro = find(events_hydro == 'SWS');
n = 0;
max_hydro = 0;

for i = 1: length(SWS_hydro)-1    %find the longest SW stage
if SWS_hydro(i+1) == SWS_hydro(i) + 1
    n = n +1;
    if n > max_hydro
        max_hydro = n;
        k = SWS_hydro(i);
    end
else
    n = 0;
end
end


% std SWS
for i = 1: length(EEG_std.event)
event = convertCharsToStrings(EEG_std.event(i).type);
events_std = [events_std event];
end

SWS_std = find(events_std == 'SWS');
n = 0;
max_std = 0;

for i = 1: length(SWS_std)-1    %find the longest SW stage
if SWS_std(i+1) == SWS_std(i) + 1
    n = n +1;
    if n > max_std
        max_std = n;
        b = SWS_std(i);
    end
else
    n = 0;
end
end


%%
% extract SW stage data for visualization
if EEG_std.event(b).latency == EEG_hydro.event(k).latency
    SWS_data_hydro = double(EEG_hydro.data(:,EEG_hydro.event(k-min(max_std,max_hydro)).latency:EEG_hydro.event(k).latency-1));
    SWS_data_std = double(EEG_std.data(:,EEG_std.event(b-min(max_std,max_hydro)).latency:EEG_std.event(b).latency-1));
else
    fprintf('disagreement in longest SW stage endpoint')
end

%%
% get psd data
psd_SWS_data_hydro = [];
for i = 1:length(SWS_data_hydro(:,1))
[psd, ~] = psdcal(1,1,30,500,SWS_data_hydro(i,:));
psd_SWS_data_hydro = cat(1,psd_SWS_data_hydro,psd);
end

psd_SWS_data_std = [];
for i = 1:length(SWS_data_std(:,1))
[psd, ~] = psdcal(1,1,30,500,SWS_data_std(i,:));
psd_SWS_data_std = cat(1,psd_SWS_data_std,psd);
end


psd_SWS_data_hydro = psd_SWS_data_hydro(1:16,:); psd_SWS_data_hydro(12,:) = [] ; psd_SWS_data_hydro(5,:) = [];
psd_SWS_data_std = psd_SWS_data_std(1:15,:); psd_SWS_data_std(11,:) = [];
%% find REM events

% hydro REM
REM_hydro = find(events_hydro == 'REM');
n = 0;
max_hydro = 0;

for i = 1: length(REM_hydro)-1    %find the longest REM stage
if REM_hydro(i+1) == REM_hydro(i) + 1
    n = n +1;
    if n > max_hydro
        max_hydro = n;
        k_hydro = REM_hydro(i);
    end
else
    n = 0;
end
end

% std REM
REM_std = find(events_std == 'REM');
n = 0;
max_std = 0;

for i = 1: length(REM_std)-1    %find the longest REM stage
if REM_std(i+1) == REM_std(i) + 1
    n = n +1;
    if n > max_std
        max_std = n;
        k_std = REM_std(i);
    end
else
    n = 0;
end
end



%%
% extract REM stage data for visualization
K = max(k_hydro,k_std);
if EEG_std.event(K).latency == EEG_hydro.event(K).latency
    REM_data_hydro = double(EEG_hydro.data(:,EEG_hydro.event(K-min(max_std,max_hydro)).latency:EEG_hydro.event(K).latency-1));
    REM_data_std = double(EEG_std.data(:,EEG_std.event(K-min(max_std,max_hydro)).latency:EEG_std.event(K).latency-1));
else
    fprintf('disagreement in longest REM stage endpoint')
    % if 0510>> EEG_std.event(4) = []; and rerun this section
    % if 0410>> EEG_hydro.event(4) = []; and rerun this section
end

%%

% get psd data
psd_REM_data_hydro = [];
for i = 1:length(REM_data_hydro(:,1))
[psd, ~] = psdcal(1,1,30,500,REM_data_hydro(i,:));
psd_REM_data_hydro = cat(1,psd_REM_data_hydro,psd);
end

psd_REM_data_std = [];
for i = 1:length(REM_data_std(:,1))
[psd, ~] = psdcal(1,1,30,500,REM_data_std(i,:));
psd_REM_data_std = cat(1,psd_REM_data_std,psd);
end

psd_REM_data_hydro = psd_REM_data_hydro(1:16,:); psd_REM_data_hydro(12,:) = [] ; psd_REM_data_hydro(5,:) = [];
psd_REM_data_std = psd_REM_data_std(1:15,:); psd_REM_data_std(11,:) = [];

%% configurate chanlocs
% topo
load("chanloc_gel.mat");
chanlocs = chanloc_gel; clear chanloc_gel;
topo_chanlocs = cat(2,chanlocs(1:4),chanlocs(6:11)); topo_chanlocs = cat(2,topo_chanlocs,chanlocs(13:length(chanlocs)));

%% topoplots [1 4] Hz

%get avg [1 4] Hz psd

SWSmeanPSD_hydro = mean(psd_SWS_data_hydro(:,1:4),2);
SWSmeanPSD_std = mean(psd_SWS_data_std(:,1:4),2);
REMmeanPSD_hydro = mean(psd_REM_data_hydro(:,1:4),2);
REMmeanPSD_std = mean(psd_REM_data_std(:,1:4),2);


figure;

% maplim = [0 0];
subplot(2,2,1)
topoplot(SWSmeanPSD_hydro, topo_chanlocs,'MapLimits',[0 50],'emarker',{'.','k',18,1});
c = colorbar;
title('SWS AIRTrode');

subplot(2,2,2)
topoplot(SWSmeanPSD_std, topo_chanlocs,'MapLimits',[0 60],'emarker',{'.','k',18,1});
c = colorbar; %c.TickLength=0;
title('SWS standard gel');

subplot(2,2,3)
topoplot(REMmeanPSD_hydro, topo_chanlocs,'MapLimits',[0 50],'emarker',{'.','k',18,1});
c = colorbar; %c.TickLength=0;
title('REM AIRTrode');

subplot(2,2,4)
topoplot(REMmeanPSD_std, topo_chanlocs,'MapLimits',[0 60],'emarker',{'.','k',18,1});
c = colorbar; %c.TickLength=0;
title('REM standard gel');


%% topoplots [16 30] Hz
% 
% get avg [4 8] Hz psd
% range = 16:30;
% SWSmeanPSD_hydro = mean(psd_SWS_data_hydro(:,range),2);
% SWSmeanPSD_std = mean(psd_SWS_data_std(:,range),2);
% REMmeanPSD_hydro = mean(psd_REM_data_hydro(:,range),2);
% REMmeanPSD_std = mean(psd_REM_data_std(:,range),2);
% 
% topoplots
% figure;
% 
% maplim = [0 5];
% subplot(2,2,1)
% topoplot(SWSmeanPSD_hydro, topo_chanlocs,'MapLimits',maplim);
% c = colorbar;
% title('SWS hydro');
% 
% subplot(2,2,2)
% topoplot(SWSmeanPSD_std, topo_chanlocs,'MapLimits',maplim);
% c = colorbar; %c.TickLength=0;
% title('SWS std');
% 
% subplot(2,2,3)
% topoplot(REMmeanPSD_hydro, topo_chanlocs,'MapLimits',maplim);
% c = colorbar; %c.TickLength=0;
% title('REM hydro');
% 
% subplot(2,2,4)
% topoplot(REMmeanPSD_std, topo_chanlocs,'MapLimits',maplim);
% c = colorbar; %c.TickLength=0;
% title('REM std');
% 


