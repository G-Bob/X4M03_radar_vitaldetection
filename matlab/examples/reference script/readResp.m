function [ref_rr] = readResp()
%READRESP Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen('C:\Users\2288980g\Desktop\radar_driver\XeThru\matlab\examples\reference script\RespOut.txt','r');
formatSpec = '%s';
A = fscanf(fileID,formatSpec);
fclose(fileID);
B = strrep(A,'[','');
B = strrep(B,']','');
ref_rr = str2num(B)/60;
end

