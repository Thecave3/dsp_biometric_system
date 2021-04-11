function gmm=create_gmm(features)
% function create_gmm(features)
% create a gaussian mixture model with the features passed
gmm = fitgmdist(features,16,'CovarianceType','diagonal','RegularizationValue',0.4,'MaxIter',200,'Display','final');
end