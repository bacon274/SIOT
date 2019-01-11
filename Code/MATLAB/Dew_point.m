channelID = 656272;
readAPIKey = 'EYMUGIDZHNGXNHSC';
writeAPIKey = 'MAR58J5NR12RNUZ7';

[data,timestamps,channelInfo]  = thingSpeakRead(channelID,'numPoints', 10,'ReadKey',readAPIKey);
T = data(:,1); 
H = data(:,2); 

[T_clean,TF] = rmmissing(T);
[H_clean,HF] = rmmissing(H);

T_timestamps = timestamps(~TF);
H_timestamps = timestamps(~HF);

time = H_timestamps(length(H_timestamps));
b = 17.62;
c = 243.5;
humidity = H_clean(length(H_clean));
tempC = T_clean(length(T_clean));

gamma = log(humidity/100) + b*tempC./(c+tempC);
dewPointC = c*gamma./(b-gamma)

thingSpeakWrite(channelID,dewPointC,'Fields',[3] ,'Writekey',writeAPIKey);