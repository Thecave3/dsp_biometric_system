function save_audio(username,c,data,info)
% function save_audio(username,c,data,info)
% save the recorded audio into the database
user_path = "./database/"+username;
if not(isfolder(user_path))
    mkdir(user_path)
end
audiowrite(user_path+"/"+username+"_"+ num2str(c)+".wav",data,info.SampleRate,'BitsPerSample',8);
%plot(data);
end