fileID = fopen('C:\Users\2288980g\Desktop\radar_driver\XeThru\matlab\examples\reference script\RespOut.txt','r')
formatSpec = '%s';
A = fscanf(fileID,formatSpec);
fclose(fileID)
B = strrep(A,'[','');
B = strrep(B,']','');
C = str2num(B)