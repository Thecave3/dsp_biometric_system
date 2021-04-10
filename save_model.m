function save_model(gmm_model,username)
% function  save_model(gmm_model)
% save the gaussian mixture model gmm_model in the database
% each user in the database has a dedicated folder represented by its
% username
main_path = "./database/";

if not(isfolder(main_path+username))
    mkdir(main_path+username)
end

% save model

end
