%threshold = 0.1;
%username = "sam";
%enrollment(3,username);
%verification(3,username,threshold);

[data,info] = record_audio(5);

gmm = feature_extraction(data,info);


