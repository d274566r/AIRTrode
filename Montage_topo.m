clear;close all;
set(groot, 'defaultAxesFontName', 'Arial');
set(groot, 'defaultTextFontName', 'Arial');
addpath(genpath('eeglab2023.0'));
% Load the channel location file
load('chanloc_hydrogel.mat');
load('chanloc_gel.mat');
channel_num = 33;  % 32 working + GND
date = '0503';
%%
Data_hydrogel_night = [];
Data_hydrogel_morn = [];
Data_gel_night = [];
Data_gel_morn = [];
[Data_hydrogel_morn1,Data_gel_morn1] = readimpdata(date,'imp_morn1.vhdr');
[Data_hydrogel_morn2,Data_gel_morn2] = readimpdata(date,'imp_morn2.vhdr');
[Data_hydrogel_night1,Data_gel_night1] = readimpdata(date,'imp_night1.vhdr');
[Data_hydrogel_night2,Data_gel_night2] = readimpdata(date,'imp_night2.vhdr');
%
for i = 1:length(Data_hydrogel_night1)
    handle = min(Data_hydrogel_night1(i),Data_hydrogel_night2(i));
    Data_hydrogel_night = [Data_hydrogel_night handle];
    handle = min(Data_hydrogel_morn1(i),Data_hydrogel_morn2(i));
    Data_hydrogel_morn = [Data_hydrogel_morn handle];
end

for i = 1:length(Data_gel_night1)
    handle = min(Data_gel_night1(i),Data_gel_night2(i));
    Data_gel_night = [Data_gel_night handle];
    handle = min(Data_gel_morn1(i),Data_gel_morn2(i));
    Data_gel_morn = [Data_gel_morn handle];
end

%%

map_lim = [0 200];

figure;
topoplot(Data_hydrogel_night, chanloc_hydrogel, 'MapLimits',map_lim);
c = colorbar; c.TickLength=0;

figure;
topoplot(Data_hydrogel_morn, chanloc_hydrogel, 'MapLimits',map_lim);
c = colorbar; c.TickLength=0;
%%

figure;
topoplot(Data_gel_night, chanloc_gel, 'MapLimits',map_lim);
c = colorbar; c.TickLength=0;

figure;
topoplot(Data_gel_morn, chanloc_gel, 'MapLimits',map_lim);
c = colorbar; c.TickLength=0;
%%
% figure;
% subplot(2,2,1)
% topoplot(Data_hydrogel_night1, chanloc_hydrogel, 'MapLimits',[0 200]);
% title('hydrogel night1')
% c = colorbar; c.TickLength=0;
% 
% subplot(2,2,2)
% topoplot(Data_hydrogel_night2, chanloc_hydrogel, 'MapLimits',[0 200]);
% title('hydrogel night2')
% c = colorbar; c.TickLength=0;
% 
% subplot(2,2,3)
% topoplot(Data_gel_night1, chanloc_gel, 'MapLimits',[0 200]);
% title('gel night1')
% c = colorbar; c.TickLength=0;
% 
% subplot(2,2,4)
% topoplot(Data_gel_night2, chanloc_gel, 'MapLimits',[0 200]);
% title('gel night2')
% c = colorbar; c.TickLength=0;
% 
% figure;
% subplot(2,2,1)
% topoplot(Data_hydrogel_morn1, chanloc_hydrogel, 'MapLimits',[0 200]);
% title('hydrogel morning1')
% c = colorbar; c.TickLength=0;
% 
% subplot(2,2,2)
% topoplot(Data_hydrogel_morn2, chanloc_hydrogel, 'MapLimits',[0 200]);
% title('hydrogel morning2')
% c = colorbar; c.TickLength=0;
% 
% subplot(2,2,3)
% topoplot(Data_gel_morn1, chanloc_gel, 'MapLimits',[0 200]);
% title('gel morning1')
% c = colorbar; c.TickLength=0;
% 
% subplot(2,2,4)
% topoplot(Data_gel_morn2, chanloc_gel, 'MapLimits',[0 200]);
% title('gel morning2')
% c = colorbar; c.TickLength=0;
