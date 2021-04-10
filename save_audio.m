function save_audio(username,c,data,sample)
% function save_audio(username,c,data,sample)
% save the recorded audio into the database
user_path = "./database/"+username;
if not(isfolder(user_path))
    mkdir(user_path)
end
audiowrite(user_path+"/"+username+"_"+ num2str(c)+".wav",data,sample.SampleRate);
 %plot(data);