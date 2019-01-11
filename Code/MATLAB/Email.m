% Read the soil moisture channel data from the past two weeks.
% Send an email via the IFTTT service and tell the user to add water if the value
% is in the lowest 10 %.
%
% Before you begin:
%  Use the IFTTT tutorial at
%   https://www.mathworks.com/help/thingspeak/analyze-channel-data-to-send-email-notification-from-ifttt.html
%  to set up a webhooks applet and get an API key for that applet.

% Store the channel ID for the moisture sensor channel.
channelID = 656272;

% Enter the trigger url from IFTTT.  It will have the form:
%. https://www/maker/com/trigger/<path>/with/key/<ITFFF API key>
iftttURL = 'https://maker.ifttt.com/trigger/Humidity_level_dangerous/with/key/mu94Ev9oqUeqyiFSSj5qiHGg3MTDgCOB5bW5Yd-XN6D';

% Channel Read API Key (if you are using your own moisture channel)
% If your channel is private, then enter the read API Key between the '' below:
readAPIKey = 'EYMUGIDZHNGXNHSC';

% Read the last two weeks of moisture data from ThingSpeak.
[data, timestamps] = thingSpeakRead(channelID,'NumPoints',24,'Fields',[2,4],'ReadKey',readAPIKey);
H = data(:,1);
S = data(:,2);

[H_clean,TF] = rmmissing(H);
[S_clean,HF] = rmmissing(S);

H_timestamps = timestamps(~TF);
S_timestamps = timestamps(~HF);

length(H_timestamps);
length(S_timestamps);

Humid = 0;
Condensation = 0;

for i = 1: length(H_timestamps)
    if H_clean(i) > 55
        Humid = 1;
    end
end

for i = 1: length(S_timestamps)
    if S_clean(i) == 0
        Condensation = 1;
    end
end

if Humid ==1 && Condensation == 1
        Message = 'Humidity levels HIGH, Risk of condensation forming'
        webwrite(iftttURL,'value1',Message)
elseif Humid ==1
        Message = 'Humidity levels HIGH';
        webwrite(iftttURL,'value1',Message);
elseif Condensation == 1
        Message = 'Risk of condensation forming'
        webwrite(iftttURL,'value1',Message);
end
        


%{
% Calculate the threshold from the recent data.
span=max(moistureData)-min(moistureData);
dryValue = 0.1*span+min(moistureData);

% Build the ThingSpeak URL.
thingSpeakURL = strcat('https://api.thingspeak.com/channels/',string(channelID),'/fields/1/last.txt');

% GET the data from ThingSpeak.
lastValue = str2double(webread(thingSpeakURL, 'api_key', readAPIKey));

if (lastValue<dryValue)
    plantMessage = ' I need water! ';
    webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
end

if (lastValue>dryValue)
    plantMessage = ' No Water Needed. ';
    webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
end

%}