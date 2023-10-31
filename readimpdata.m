function [Data_hydrogel, Data_gel] = readimpdata(date,filename)
%READIMPDATA Summary of this function goes here
%   Detailed explanation goes here
% Load the channel location file
load('chanloc_hydrogel.mat');
load('chanloc_gel.mat');
channel_num = 33;  % 32 working + GND
addpath(date);
D = readlines(filename);
D = D(length(D)-channel_num:length(D)-1);
%%
Data_hydrogel = [];
Data_gel = [];
hg_label = 'hydrogel';
for i = 1:length(D)
    if contains(D(i),hg_label)
        handle = convertStringsToChars(D(i));
        handle = handle(end-2:end);
        d_imp = str2double(handle);
        Data_hydrogel = [Data_hydrogel d_imp];  
    else
        if contains(D(i),'Gnd')
            handle = convertStringsToChars(D(i));
            handle = handle(end-2:end);
            d_imp = str2double(handle);
            Data_hydrogel = [Data_hydrogel d_imp]; 
        else
            handle = convertStringsToChars(D(i));
            handle = handle(end-2:end);
            d_imp = str2double(handle);
            Data_gel = [Data_gel d_imp];
        end
        
    end
end
Data_gel(isnan(Data_gel)) = 999;
Data_hydrogel(isnan(Data_hydrogel)) = 999;

end

