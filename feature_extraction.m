function [features]=feature_extraction(data,info)
% function  feature_extraction(data,info)
% extracts the features from the sample audio
% data is the actual audio
% info represent the information associated with the audio

fs = info.SampleRate;

% Normalize audio
%data = data./max(abs(data));

%detectSpeech(data,fs);

% Locate and extract the region of speech in the audio
idx = detectSpeech(data,fs);
data = data(idx(1,1):idx(1,2));

% TODO explore mfcc function more in depth
[coeffs,delta,deltaDelta,loc] = mfcc(data,fs);
features = [coeffs,delta,deltaDelta,loc];
end