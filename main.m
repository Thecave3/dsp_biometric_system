clc;
%threshold = 0.1;
%username = "andrea";
%disp("Begin enrollment");
%enrollment(3,username);
%disp("End enrollment");
%disp("Begin verification");
%verification(3,username,threshold);

[data,info] = record_audio(4);
features = feature_extraction(data,info);
gmm = create_gmm(features);

%gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gmm,[x0 y0]),x,y);
%fcontour(gmPDF,[-10 10]);
%title('Contour lines of pdf');

%save_model(gmm,username);
%gmm = get_stored_model(username);