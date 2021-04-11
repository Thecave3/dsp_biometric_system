function enrollment(sample_time,username)
% function enrollment(sample_time)
% routine that performs the creations of the templates
% sample_time represents the recording time for each representation
% username represent the identification in the database of the user
main_path = "./database/";

if not(isfolder(main_path+username))
    mkdir(main_path+username)
end

all_ftrs = [];

for c = 1:3
    [data,info]= record_audio(sample_time);
    save_audio(username,c,data,info);
    disp("Wait for "+ num2str(sample_time/2)+ " seconds")
    pause(sample_time/2);
    fresh_ftr = feature_extraction(data,info);
    all_ftrs = vertcat(all_ftrs,fresh_ftr);
end

 gmm_model  = create_gmm(all_ftrs);

 save_model(gmm_model,username);
 disp("New user enrolled in the system "+username);
end

