% X4record1(15,'umer','P01NB1R1','COM5') - run this code for data acquisition
% This example demonstrates the use of ModuleConnector to configure the
% radar chip using XEP and read raw baseband data through the data float
% message.
%
% To complete the following example you need:
% - An X4M200/X4M300/X4M03 module
% - The ModuleConnector library
% - MATLAB

%X4record(10,'AT','01');
%record_person='corner_reflector'; 
%record_activity='fortyfive';

%X1record1(10,’P1’,’A01’,’COM10’)  % function needs the record time, person identifier, activity identifier and com port.



function X4record1(record_duration,record_person,record_activity,COMPORT)


%add paths
addpath('../../matlab/');
addpath('../../include/');
addpath('../../lib64/');
addpath('addition/');

% or addpath('../../lib32/');


clc
clearvars -except record_duration record_person TimeStamp record_activity COMPORT
% Device com-port
%COMPORT = 'COM10';


% Whether to record data or not, set to 0 if you don't want to record.
enable_recording = 1;
[~, user_name] = system('echo %USERNAME%');
 
% Output directory for recorded data.
% output_dir = strcat('C:\Users\',user_name,'\Desktop\XeThru Recordings','\',record_person,'\');
session_id=strcat(record_person,'_',record_activity);

 if exist(output_dir,'dir')~=7 
     mkdir(output_dir)
 end




% Load the library
Lib = ModuleConnector.Library;
% Display the functions available in the library
Lib.libfunctions;

% Create ModuleConnector object
mc = ModuleConnector.ModuleConnector(COMPORT,0);

% Get XEP interface
xep = mc.get_xep();

FWID = xep.get_system_info(2);



% Display system info
disp(['FirmWareID = ' FWID]);
disp(['Version = ' xep.get_system_info(3)]);
disp(['Build = ' xep.get_system_info(4)]);
disp(['SerialNumber = ' xep.get_system_info(6)]);
disp(['VersionList = ' xep.get_system_info(7)]);
FPS = 25;
%% Preparation

% Need to do some preparation if the connected module is a X4M300 or X4M200

% 
% switch FWID
%     case {'Annapurna','X4M300'}
%         % Running X4M300 or X4M200 module. Need to set manual (XEP) mode.
%         app = mc.get_x4m300();
%         % Usually sensor autostarts, so first set sensor mode stop
%         app.set_sensor_mode('stop');
%         % Set manual mode.
%         app.set_sensor_mode('XEP');
%     case 'XEP'
%         % Do nothing
%     otherwise
%         error(['Unknown device connected. Returns FirmWareID ' FWID]);
% end
% 
% 
% % Clear message buffers
% while xep.peek_message_data_float > 0
%     xep.read_message_data_float();
% end
% 


%% Configure radar chip with x4driver through XEP interface

% First initialize chip
xep.x4driver_init();

% Set downconversion -> receive baseband data.
xep.x4driver_set_downconversion(1);

% Set X4 chip parameters

% Important! Changing the chip parameters below changes the time the chip
% uses to build a single frame (the sweep time). This must correspond to
% the frame rate (FPS) so that frames are not attempted read before the
% chip has finished the sweep. This will cause uncertain behavior.
%
% The configuration below is tuned for a duty
% cycle of approximately 80% at 17 FPS, which is the same as used in the
% predefined XeThru profiles. Before changing these parameters, it's
% recommended to aquire an understanding of how the sampling works on the
% X4 chip.

xep.x4driver_set_iterations(16);
xep.x4driver_set_pulsesperstep(10);
xep.x4driver_set_dac_min(949);
xep.x4driver_set_dac_max(1100);


% Set frame area offset
% This is a HW dependent constant needed to adjust for the propagation of
% the signal from the X4 chip through the antenna feed and out in the air.
% The value given here is the value found for the HW platforms in this
% example, but a different platform might have a different offset, meaning
% the actual range of objects will appear at an offset.
xep.x4driver_set_frame_area_offset(0.18);

% Set frame area
xep.x4driver_set_frame_area(0.4, 5.0);

% Read back actual frame area
[frame_start,frame_stop] = xep.x4driver_get_frame_area();

if enable_recording

    %% DataRecorder configuration

    % Get DataRecorder
    recorder = mc.get_data_recorder();

    % Set session id.
    recorder.set_session_id(session_id);

    % Set file split duration 10 min (600 seconds)
    recorder.set_file_split_duration(600);


    % Specify data type for recording
    baseband_ap_type = ModuleConnector.DataRecorderInterface.DataType_FloatDataType;

    % Start recording.
    
    recorder.start_recording(baseband_ap_type,strcat(output_dir));

end

%% Run

% Start streaming data by setting FPS
xep.x4driver_set_fps(FPS);


%% Visualize data

% Most of the code in this section is to handle visualization of the data
% float message data from the module. Reading the data float message from
% the module is done with the command xep.read_message_data_float().

% Read and plot data from module. Close figure to stop.
fh = figure(1);
clf(1);

% Create handles for update of plots.
subplot(2,1,1);
ph_amp = plot(NaN,NaN);
th_amp = title('');
ax_amp = gca;
ylim([0 0.03]);
grid on;
xlabel('Range [m]');
subplot(2,1,2);
ph_phase = plot(NaN,NaN);
th_phase = title('');
ax_phase = gca;
ylim([-3*pi/2 3*pi/2]);
grid on;
xlabel('Range [m]');

% % Generate range vector
bin_length = 8 * 1.5e8/23.328e9; % range_decimation_factor * (c/2) / fs.
range_vector = (frame_start-1e-5):bin_length:(frame_stop+1e-5); % +-1e-5 to account for float precision.

ph_amp.XData = range_vector;
ph_phase.XData = range_vector;
ph_count.XData = range_vector;
% Loop as long as figure is open.
Infocache = [];
tStart = tic;
while ishandle(fh)
    [contentID,data_length,info,data] = xep.read_message_data_float();
    if ~mod(info,1000)
        % Every 1000th frame, output queue to give indication if plotting
        % is lagging behind.
        disp(['Number of data float messages in queue: ' num2str(xep.peek_message_data_float())]);
    end
    
    % Generate IQ vector.
    i_vec = data(1:data_length/2);
    q_vec = data(data_length/2+1:data_length);
    iq_vec = i_vec + 1i*q_vec;
    % Update data in handles for plotting.
    ph_amp.YData = abs(iq_vec);
    ylim(ax_amp,[0 max([0.03 max(abs(iq_vec)) + 0.01])]);
    th_amp.String = ['Baseband amplitude - frameCounter = ' num2str(info)];
    ph_phase.YData = atan2(q_vec,i_vec);
    th_phase.String = ['Baseband phase - frameCounter = ' num2str(info)];
    
    drawnow;
    threshold = 5; % setting recognition gap
    [Infocache,output] = Signalupdate(iq_vec, Infocache, 90, threshold, FPS);
    
    if size(output,1) >= 1
        resp_detect(output,FPS);
    end

    % toc(tStart) % Record the stored time
    size(Infocache,2)
    if toc(tStart) > record_duration
        break; % Stop the real-time detection with setting threshold
    end
end

%tic;
%fprintf('Ready!')
%pause(0.5) ;

Callout=fprintf('GO!');

%pause(record_duration); 
%toc
if enable_recording
    
    % Stop recording.
    recorder.stop_recording(baseband_ap_type);

end

%% Stop radar and close connection

% Stop streaming by setting FPS = 0.
xep.x4driver_set_fps(0);

% Reset module
xep.module_reset();



% Clean up.
clear mc mc1 mc2;
clear xep xep1 xep2;
clear app app1 app2 ;
clear recorder recorder1 recorder2;
Lib.unloadlib;
clear Lib;

end

function [cache,output] = Signalupdate(Input_signal, storage, channel, threshold, fs_sample)
threshold_bin = fs_sample * threshold;
if size(storage,2) == threshold_bin
    
    analysis_signal = [Input_signal(:,:),storage(:,1:(threshold_bin-1))];
    cache = analysis_signal(:,1:(threshold_bin-5));
    
    pca_coef = pca(analysis_signal(40:channel,:)');
    output = (analysis_signal(40:channel,:)') * pca_coef(:,1);
else 
    cache = [Input_signal,storage];
    output = [];
end
end
function resp_detect(signal,fs_sample)
%% PCA data plot
% etime = size(signal,1)/fs_sample;
T=1/fs_sample;  %Sample frequency
N = size(signal,1);
t = 0:T:(N-1)*T; %采样时间
figure(2)

subplot(221);
plot(t,angle(signal(:,:)))
ylabel('Phase (rad)');  xlabel('Time (s)');
xlim([0,max(t)]);
title('Phase in time domain ');
subplot(222);
plot(t,(abs(signal)));
ylabel('Amplitude (dB)');  xlabel('Time (s)');
xlim([0,max(t)]);
title('Amplitude in time domain ');
%% Filter for resp & heart
subplot(223);
% resp_sig = Pfilter(angle(signal(:,:)),'low',0.8,fs_sample,2);% 
% resp_sig = BPfilter(angle(signal(:,:)),fs_sample,[0.12 0.6],[0.08 0.8]);% 
resp_sig = IIR_BP(abs(signal(:,:)),fs_sample,[0.1 0.5]);% 
plot(t,resp_sig(:,:));
ylabel('Phase (rad)');  xlabel('Time (s)');
xlim([0,max(t)]);
title('Filtered phase in time domain for respiration');

subplot(224);
%heart_sig = Pfilter(angle(signal(:,:)),'high',1,fs_sample,2);
%heart_sig = BPfilter(angle(signal(:,:)),fs_sample,[0.9 1.8],[0.7 2]);% 
heart_sig = IIR_BP(abs(signal(:,:)),fs_sample,[1 2]);% 

plot(t,heart_sig(:,:));
ylabel('Phase (rad)');  xlabel('Time (s)');
xlim([0,max(t)]);
title('Filtered phase in time domain for heartbeat');

%% FFT spectrum and respiration detection
FrequencyResponse_plot(angle(signal),fs_sample);
%FrequencyResponse_plot(heart_sig,fs_sample);
figure(5);
%[~,~] = Rate_estimation(resp_sig,fs_sample);
[~,~] = Rate_estimation(resp_sig,fs_sample,'respiration');
figure(6);
[~,~] = Rate_estimation(heart_sig,fs_sample,'heartbeat');
subplot(211)
[~] = Rate_estimation_fft(resp_sig,fs_sample,'respiration');
subplot(212)
[~] = Rate_estimation_fft(heart_sig,fs_sample,'heartbeat');


end