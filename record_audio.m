function [record,data]=record_audio(time)
% function [record,data]=record_audio(time)
% registration of an audio sample for the user for a given time
% returns the audio recorded and some useful info
if time < 0
   error('Time must be a positive integer value');
end

recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, time);
disp('End of Recording.');
record = recObj;
data = getaudiodata(recObj);

