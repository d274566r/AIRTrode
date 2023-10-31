clear;
% close all;
clc;

% load data
load('TFdatasubject1set3.mat');
fs =500;


%% Time-Frequency Analysis: sTFT
% load a signal
filter = [1 30]; % band-pass condition
[b,a] = butter(3,filter/(fs/2));
dHg = filtfilt(b, a,TFdataHg(:));
dGel = filtfilt(b, a,TFdatagel(:));
x = cat(2,dHg,dGel)';
xlen = length(x(1,:));                   % signal length
t = (0:xlen-1)/fs;                  % time vector

% time-frequency analysis parameters
wlen = 1024;                        % window length (recommended to be power of 2)
nfft = 2*wlen;                      % number of fft points (recommended to be power of 2)
hop = wlen/4;                       % hop size (recommended to be 1/4 of the window length)

% perform STFT
w1 = blackman(wlen, 'periodic');
[~, fS1, tS1, PSD1] = spectrogram(x(1,:), w1, wlen-hop, nfft, fs);
Samp1 = 20*log10(sqrt(PSD1.*enbw(w1, fs))*sqrt(2));
[~, fS2, tS2, PSD2] = spectrogram(x(2,:), w1, wlen-hop, nfft, fs);
Samp2 = 20*log10(sqrt(PSD2.*enbw(w1, fs))*sqrt(2));

%--------------------------------------------------------------------------
% plot the spectrogram
figure('Position', [300, 300, 110*10, 27*10]);
surf(tS1, fS1(1:125), Samp1(1:125,:))
shading interp
axis tight
box on
set(gca, 'FontName', 'Arial', 'FontSize', 12)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Amplitude spectrogram of the hydrogel signal')
view(0, 90)
caxis([5 20])

% enable colorbar
hcol = colorbar(['EastOutside']);
set(hcol, 'FontName', 'Arial', 'FontSize', 12)
ylabel(hcol, 'Magnitude (dB)')


% -------------------------------------------------------------------------
figure('Position', [300, 300, 110*10, 27*10]);
surf(tS2, fS2(1:125), Samp2(1:125,:))
shading interp
axis tight
box on
set(gca, 'FontName', 'Arial', 'FontSize', 12)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Amplitude spectrogram of the gel signal')
view(0, 90)
caxis([5 20])

% enable colorbar
hcol = colorbar(['EastOutside']);
set(hcol, 'FontName', 'Arial', 'FontSize', 12)
ylabel(hcol, 'Magnitude (dB)')

