close all 
clear all 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Open Cleaned Data                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Data2.mat','-mat','T_time');
load('Data2.mat','-mat','T');
load('Data2.mat','-mat','H');
t = T_time;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Visualise Data                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
plot(t,T)
title('Air Temperature of room')
xlabel('Time')
ylabel('Temperature (*C)')

figure()
plot(t,H)
title('Air Humidity of room')
xlabel('Time')
ylabel('Humidity (%)')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Normalise Data                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_norm = zscore(T); 
H_norm = zscore(H); 

figure() 
plot(t, T_norm, t, H_norm)
title('Normalised Temperature and Humidity')
xlabel('Time')
ylabel('z-score')
legend('Temperature', 'Humidity') 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Seperate by Datatime                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varNames = {'Temperature','Humidity'};

%Table = table(t,T,H,'VariableNames',varNames);
TT = timetable(t,T,H,'VariableNames',varNames);
TR = timerange('2018-12-28 00:00:00','2018-12-29 00:00:00');
Day1 = TT(TR,:);
TR = timerange('2018-12-30 00:00:00','2018-12-31 00:00:00');
Day2 = TT(TR,:);
TR = timerange('2018-12-31 00:00:00','2019-01-01 00:00:00');
Day3 = TT(TR,:);
TR = timerange('2019-01-01 00:00:00','2019-01-02 00:00:00');
Day4 = TT(TR,:);
TR = timerange('2019-01-02 00:00:00','2019-01-03 00:00:00');
Day5 = TT(TR,:);
TR = timerange('2019-01-03 00:00:00','2019-01-04 00:00:00');
Day6 = TT(TR,:);
TR = timerange('2019-01-04 00:00:00','2019-01-05 00:00:00');
Day7 = TT(TR,:);

figure()
subplot(4,2,1)
plot(Day1.Time, zscore(Day1.Temperature), Day1.Time, zscore(Day1.Humidity))
subplot(4,2,2)
plot(Day2.Time, zscore(Day2.Temperature), Day2.Time, zscore(Day2.Humidity))
subplot(4,2,3)
plot(Day3.Time, zscore(Day3.Temperature), Day3.Time, zscore(Day3.Humidity))
subplot(4,2,4)
plot(Day4.Time, zscore(Day4.Temperature), Day4.Time, zscore(Day4.Humidity))
subplot(4,2,5)
plot(Day5.Time, zscore(Day5.Temperature), Day5.Time, zscore(Day5.Humidity))
subplot(4,2,6)
plot(Day6.Time, zscore(Day6.Temperature), Day6.Time, zscore(Day6.Humidity))
subplot(4,2,7)
plot(Day7.Time, zscore(Day7.Temperature), Day7.Time, zscore(Day7.Humidity))


%%

 