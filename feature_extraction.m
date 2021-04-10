function [gmm]=feature_extraction(data,info)
% function  feature_extraction(data,info)
% extracts the gaussian mixture model from the sample audio
% data is the actual audio
% info represent the information associated with the audio
fs = info.SampleRate;

%detectSpeech(data,fs);
% TODO explore mfcc function more in depth
[coeffs,delta,deltaDelta,loc] = mfcc(data,fs);
X = [coeffs,delta,deltaDelta,loc];
% TODO
gmm = fitgmdist(X,16, 'CovarianceType','diagonal','RegularizationValue',0.4,'MaxIter',200,'Display','final');

