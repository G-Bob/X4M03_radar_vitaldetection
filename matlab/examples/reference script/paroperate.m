clc;
clear;
addpath 'C:\Users\2288980g\Desktop\radar_driver\XeThru\matlab\examples'
addpath 'C:\Users\2288980g\Desktop\radar_driver\XeThru\matlab\examples\addition'
addpath('../../../matlab/');
addpath('../../../include/');
addpath('../../../lib64/');


%[respiration_rate,heartbeat_rate,timeIndex] = X4_realtime_withdata(300,'test','P01NB1R1','COM5');
[~,~,timeIndex] = X4_realtime_withdata_waveform(200,'test','P01NB1R1','COM5');
