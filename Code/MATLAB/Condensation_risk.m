channelID = 656272; % my channel 
readAPIKey = 'EYMUGIDZHNGXNHSC';
writeAPIKey = 'MAR58J5NR12RNUZ7';
data1 = thingSpeakRead(25998)
Outside_T = data1(1)

[data,timestamps,channelInfo]  = thingSpeakRead(channelID,'numPoints', 10,'ReadKey',readAPIKey);
Dew_point = data(:,3); 
DP_clean = rmmissing(Dew_point); 
DP = DP_clean(length(DP_clean))


if Outside_T<DP
    Safe = 0
else
    Safe = 1
end

thingSpeakWrite(channelID,'Fields',[4,5], 'Values', [Safe,Outside_T] ,'Writekey',writeAPIKey);
%thingSpeakWrite(channelID,Safe,'Fields',[4] ,'Writekey',writeAPIKey);
%thingSpeakWrite(channelID,dewPointC,'Fields',[3] ,'Writekey',writeAPIKey);
%thingSpeakWrite(channelID,Outside_T,'Fields',[5] ,'Writekey',writeAPIKey);

