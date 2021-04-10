function save_model(gmm_model,username)
% function  save_model(gmm_model)
% save the gaussian mixture model gmm_model in the database
% each user in the database has a dedicated folder represented by its
% username
main_path = "./database/";
user_path = main_path+username;
if not(isfolder(user_path))
    mkdir(user_path)
end

% save model
save(user_path+"/gmm.mat", 'gmm_model') 

end
