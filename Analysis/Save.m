load('Data2.mat','-mat','T_time');
load('Data2.mat','-mat','T');
load('Data2.mat','-mat','H');


varNames = {'Time','Temperature','Humidity'};
TT = table(T_time,T,H,'VariableNames',varNames)

writetable(TT,'Data_clean.csv')