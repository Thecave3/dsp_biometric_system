function [gmm]=feature_extraction(data,info)
% function  feature_extraction(data,info)
% extracts the gaussian mixture model from the sample audio
% data is the actual audio
% info represent the information associated with the audio
fs = info.SampleRate;

%detectSpeech(data,fs);
% TODO explore mfcc function more in depth
[coeffs,delta,deltaDelta,loc] = mfcc(data,fs);
X = [coeffs,delta];
% TODO
GMModel = fitgmdist(coeffs,2,'RegularizationValue',0.1);

figure
y = [zeros(1000,1);ones(1000,1)];
h = gscatter(X(:,1),X(:,2),y);
hold on
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(GMModel,[x0 y0]),x,y);
g = gca;
fcontour(gmPDF,[g.XLim g.YLim])
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
legend(h,'Model 0','Model1')
hold off

