function enrollment(sample_time,word)
% function enrollment(sample_time)
% routine that performs the creations of the templates
% sample_time represents the recording time for each template
% word represents the word to be enrolled in

main_path = "./database/";

if not(isfolder(main_path+word))
    mkdir(main_path+word)
end

% numbers of recordings for each word
n = 5;

for c = 1:n
    disp("Wait for "+ num2str(sample_time/2)+ " seconds")
    pause(sample_time/2);
    [data,info]= record_audio(sample_time);
    save_audio(word,c,data,info);
    features = feature_extraction(data,info);
    save_features(features,word,c);
end
 
% save mean and std of dtw OR save minimum and maximum distances 

disp("New word enrolled in the system: "+ word);
end

