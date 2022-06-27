clear;
clc;
blelist('Timeout',5)
% blelist("Name","GDX-RB 0K202063")
b = ble("GDX-RB 0K202063")
% c = characteristic(b,"Heart Rate","Heart Rate Measurement")
% d = descriptor(c,"Client Characteristic Configuration")
% data = read(d)
% subscribe(c,'notification');
% data = read(d)
b.Characteristics
 hr = characteristic(b,"8E6F0F58-5819-11E6-8B77-86F30CA893D3"  ,"248D6F39-5819-11E6-8B77-86F30CA893D3")
% hr = characteristic(b,"1800"," 2A01")
data = read(hr)
flag = uint8(data(1));
% Get the first bit of the flag, which indicates the format of the heart rate value
RepirationValueFormat = bitget(flag, 1);
Respirate = double(typecast(uint8(2.*(data(2:3)./30)), 'uint16'));ble(typecast(uint8(data()), 'uint16'));
fprintf('Respiration measurement: %d(bpm)\n', Respirate);