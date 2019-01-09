%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Time-Series Data Analysis                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all 
clear all 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Access and clean Data from API                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

channelID = 656272;
readAPIKey = 'EYMUGIDZHNGXNHSC';

[data,timestamps,channelInfo]  = thingSpeakRead(channelID,'numPoints', 8000,'ReadKey',readAPIKey);
T = data(:,1); 
H = data(:,2); 

[T_clean,TF] = rmmissing(T);
[H_clean,HF] = rmmissing(H);

T_timestamps = timestamps(~TF);
H_timestamps = timestamps(~HF);

% Need to now delete all the random repeated samples. This is becasue sometimes the arduino would
% get an error and repeat the upload whereas it had infact uploaded.


T_new = [];
T_time_new = [];
for i = 1:length(T_clean)-1
    if abs(T_timestamps(i) - T_timestamps(i+1)) > minutes(2)
        T_new = [T_new; T_clean(i);];
        T_time_new = [T_time_new; T_timestamps(i);];
    end
end

H_new = [];
H_time_new = [];
for i = 1:length(H_clean)-1
    if abs(H_timestamps(i) - H_timestamps(i+1)) > minutes(2)
        H_new = [H_new; H_clean(i);];
        H_time_new = [H_time_new; H_timestamps(i);];
    end
end

H = H_new; 
T = T_new; 
H_time = H_time_new; 
T_time = T_time_new; 

% now the datasets are the same size they can be compared more easily. 
%these are saved to Data.mat for easy access. 
% YOU SHOULD HAVE MOVED EVERYTHING BELOW TO ANALYSIS 2 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Visualise Data                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
plot(T_time,T)
title('Air Temperature of room')
xlabel('Time')
ylabel('Temperature (*C)')

figure()
plot(H_time,H)
title('Air Humidity of room')
xlabel('Time')
ylabel('Humidity (%)')

% will want to seperate out different time periods

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Normalise Data                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_norm = zscore(T_clean); 
H_norm = zscore(H_clean); 

figure() 
plot(T_timestamps, T_norm, H_timestamps, H_norm)
title('Normalised Temperature and Humidity')
xlabel('Time')
ylabel('z-score')
legend('Temperature', 'Humidity') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Autocorrelation                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
autocorr(T_norm);

figure()
autocorr(H_norm);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Cross-correlation                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[r, lags] = xcorr(T_norm,H_norm);

figure()
plot(lags,r)
title('cross correlation')
xlabel('Lags')
ylabel('Correlation')
% want to apply lag difference to compare 
H_time_lag = H_timestamps - minutes(0);
 
figure()
plot(H_time_lag, H_norm)
hold on 
plot(T_timestamps, T_norm)

figure()
plot(T_norm)
hold on
plot(H_norm(1:length(T_norm)))

rho = corr(T_norm(1:60),H_norm(1:60))

% the two time series data sets seem to be inversely correlated at times 
% and directly correlated strongly at other times

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Seasonaility                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Predictive Model                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Arma / Arima model to create a predictive model 