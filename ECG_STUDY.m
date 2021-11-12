%%%ECG FILTERING%%%

%%Files%%
load('ecg_stress_test.mat')

%%Constants%%
N = length(ecg_data);       %Number of points
t = 0:1:N-1;                %Plotting time vector
F_cut = 0.5;                %Cut-off frequency
F_sample = 250;             %Sampling frequency
f_cut = F_cut/F_sample;     %Normalized cutoff
omega_c = 2.*pi.*f_cut;     %Angular frequency
c = 40;                     %Low pass filter constant
d = 230;                    %Low pass filter constant
%%Filters%%
[b,a] = butter(5,f_cut,'high');             %High pass fitler
[b2,a2] = butter(4,c.*f_cut,'low');         %Low pass filter
[b3,a3] = butter(4,d.*f_cut,'low');       %Low pass filter

%Filtering%
ecg_ma = movmean(ecg_data,4);               %Moving average filter
ecg_filter = filtfilt(b,a,ecg_ma);          %High pass Butterworth filter 
ecg_filter_ma = movmean(ecg_filter,3);      %Moving average filter of the butterworth filtered data


%Derivative
decg = diff(ecg_filter_ma);                 %Calculate the derivative
[pks,locs] = findpeaks(decg);               %Find peaks
pks_filter = filtfilt(b3,a3,pks);           %Filter the peak data with a low pass filter
[up,lo] = envelope(pks_filter,100,'peak');  %Envelope the filtered peak data
[up2,lo2] = envelope(up,10,'peak');         %Envelope again


%THE PEAKS%
pks_qrs_est = zeros(1,length(pks_filter));          %Create an empty vector of the real peaks
pks_qrs_est_locs = zeros(1,length(pks_filter));     %Create an empty vector of the location of the peaks

for i = 1:length(pks)                               %Declate threshold using the envelope
    if pks(i) > up2(i)
        pks_qrs_est(i) = pks(i);
        pks_qrs_est_locs(i) = 1;
    end
end


pks_qrs_locs = pks_qrs_est_locs.*locs';             %Get the location of the estimated qrs peaks

pks_qrs_locs = pks_qrs_locs(pks_qrs_locs~=0);       %Remove the 0s from the vector

%ploting
plot(t,ecg_filter2)
hold on
for i = pks_qrs_locs
    plot(i,ecg_filter2(i),'o')
end


