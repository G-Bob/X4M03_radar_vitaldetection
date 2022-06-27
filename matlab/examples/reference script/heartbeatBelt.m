clear
clc
clear global BLEDev

list = blelist('Timeout',5)

belt = ble("Polar H10 8B453225");
belt.Characteristics;
hr = characteristic(belt, "heart rate", "heart rate measurement");
% data = read(hr);

% flag = uint8(data(1));
% instantaneousSpeed = double(typecast(uint8(data(2:3)), 'uint16'))/256;
% instantaneousCadence = data(4);
% fprintf('Instantaneous speed: %.2f(m/s) and instantaneous cadence: %d(steps per minute)\n', instantaneousSpeed, instantaneousCadence);

% Get the first bit of the flag, which indicates the format of the heart rate value
% heartRateValueFormat = bitget(flag, 1);
% if heartRateValueFormat == 0
%     % Heart rate format is uint8
%     heartRate = data(2);
% else
%     % Heart rate format is uint16
%     heartRate = double(typecast(uint8(data(2:3)), 'uint16'));
% end
for loop = 1:30
data = read(hr);
flag = uint8(data(1));

% Get the first bit of the flag, which indicates the format of the heart rate value
heartRateValueFormat = bitget(flag, 1);
if heartRateValueFormat == 0
    % Heart rate format is uint8
    heartRate = data(2);
else
    % Heart rate format is uint16
    heartRate = double(typecast(uint8(data(:)), 'uint16'));
end
    fprintf('Heart rate measurement: %d(bpm)\n', heartRate);

end



% for loop = 1:30
%     % Get heart rate data
%     data = read(hr);
%     flag = uint8(data(1));
%     heartRateValueFormat = bitget(flag, 1);
%     if heartRateValueFormat == 0
%         heartRate = data(2);
%     else
%         heartRate = double(typecast(uint8(data(2:3)), 'uint16'));
%     end
%    % Update plot with new data
% %     addpoints(hSpeed, instantaneousSpeed, heartRate);
% %     addpoints(hCadence, instantaneousCadence, heartRate);
% %     drawnow;
% end
% 
% % Create a plot for running speed against heart rate
% axSpeed = axes('XLim', [0, 5], 'YLim', [60, 220]);
% xlabel(axSpeed, 'Running speed (m/s)');
% ylabel(axSpeed, 'Heart rate (bpm)');
% subplot(1, 2, 1, axSpeed);
% hSpeed = animatedline(axSpeed, 'Marker', 'o', 'MarkerFaceColor', 'green');
% % Create a plot for running cadence against heart rate
% axCadence = axes('XLim', [0, 200], 'YLim', [60 220]);
% xlabel(axCadence, 'Running cadence (steps per minute)');
% ylabel(axCadence, 'Heart rate (bpm)');
% subplot(1, 2, 2, axCadence);
% hCadence = animatedline(axCadence, 'Marker', 'o', 'MarkerFaceColor', 'blue');


