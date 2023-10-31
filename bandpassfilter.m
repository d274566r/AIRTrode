function [d1] = bandpassfilter(highp,lowp,fs,rawdata)
%BANDPASSFILTER Summary of this function goes here
%   Detailed explanation goes here
filter = [highp lowp]; % band-pass condition
[b,a] = butter(4,filter/(fs/2));
d1 = filtfilt(b, a, rawdata(:,:));
end

