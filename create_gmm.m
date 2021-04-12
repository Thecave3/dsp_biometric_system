function gmm=create_gmm(features)
% function create_gmm(features)
% create a gaussian mixture model with the features passed

% First we apply a normalization of the features
meanFeat = mean(features,2,'omitnan');
stdFeat = std(features,[],2,'omitnan');
numComponents = 16;

%features = (features' - meanFeat) ./ stdFeat;
gmm = fitgmdist(features,numComponents,'CovarianceType','diagonal','RegularizationValue',0.4,'MaxIter',200,'Display','final');
end