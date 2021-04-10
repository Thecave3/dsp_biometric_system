function verification(sample_time,username,acceptance_trshd)
% function verification(sample_time,username)
% routine that performs the authentication of a single subject identified
% by username
% sample_time represents the recording time
% acceptance_trshd indicates the minimum acceptance distance to be authenticated
% correctly

% need array ?
[sample,data]= record_audio(sample_time);
%plot(data);
%audiowrite("./sam_"+ num2str(c)+".wav",data,sample.SampleRate);
% pass the array ?
extracted_gmm = feature_extraction(sample,data,sample_time);
stored_gmm = get_stored_model(username);

% check different types of distance available in pdist
euclidean_distance = pdist(extracted_gmm,stored_gmm);

disp("euclidean_distance: " +euclidean_distance+" acceptance_trshd: "+acceptance_trshd);
if euclidean_distance < acceptance_trshd
    disp("Welcome back "+username+"!"); 
else
    disp("Error, unauthorized!"); 
end

end

