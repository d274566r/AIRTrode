function [data_psd,f] = psdcal(lowf,step,highf,sampling_rate,data)
%PSDCAL Summary of this function goes here
%   Detailed explanation goes here
f = (lowf:step:highf);
fs = sampling_rate;
[data_psd] = pwelch(data,fs/2,fs/5,f,fs);
end

