%%%ECG PROCCESSING%%%

%%Files%%
load('ecg_stress_test.mat')

%%Constants%%
N = length(ecg_data);       %Number of points
F_cut = 0.5;                %Cut-off frequency
F_sample = 250;             %Sampling frequency
f_cut = F_cut/F_sample;     %Normalized cutoff
omega_c = 2.*pi.*f_cut;     %Angular frequency

%%Filters%%

%Filtering%
ecg_ma = movmean(ecg_data,4);   %Moving average filter
%Derivative
decg = diff(ecg_ma_sqr);
[pks,locs] = findpeaks(decg);
[b3,a3] = butter(4,230.*f_cut,'low');
pks_filter = filtfilt(b3,a3,pks);
[up,lo] = envelope(pks_filter,100,'peak');
[up2,lo2] = envelope(up,10,'peak');
pks_realpeak = pks-pks_filter;
plot(pks_filter,'x')
hold on
plot(pks,'o')


