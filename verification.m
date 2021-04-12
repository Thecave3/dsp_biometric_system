function verification(sample_time,username,acceptance_trshd)
% function verification(sample_time,username)
% routine that performs the authentication of a single subject identified
% by username
% sample_time represents the recording time
% acceptance_trshd indicates the minimum acceptance distance to be authenticated
% correctly

[data,info]= record_audio(sample_time);
% plot(data);

extracted_ftrs = feature_extraction(data,info);
stored_gmm = get_stored_model(username);


P = posterior(stored_gmm,extracted_ftrs);

% Mahalanobis distance to Gaussian mixture component
%mahal_distance = sqrt(mahal(stored_gmm,extracted_ftrs));
%disp("mahal_distance: " +  mahal_distance +" acceptance_trshd: "+ acceptance_trshd);

if P >= acceptance_trshd
    disp("Welcome back "+username+"!"); 
else
    disp("Error, unauthorized!"); 
end

end