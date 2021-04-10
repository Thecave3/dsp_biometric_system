function enrollment(sample_time,username)
% function enrollment(sample_time)
% routine that performs the creations of the templates
% sample_time represents the recording time for each representation
% username represent the identification in the database of the user

if isfolder(main_path+username)
    mkdir(main_path+username)
end

for c = 1:3
    % put into array
    [sample,data]= record_audio(sample_time);
    save_audio(username,c,data,sample);
    disp("Wait for "+ num2str(sample_time)+ " seconds")
    pause(sample_time);
end
    
 % pass the array
 gmm_model = feature_extraction(sample,data,sample_time);
 save_model(gmm_model,username);
 dist("New user enrolled in the system "+username);
end

