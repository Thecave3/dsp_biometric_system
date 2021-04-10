function [gmm]=get_stored_model(username)
% function  get_stored_model(username)
% get the stored gaussian mixture model of the corrisponding user
% from the database

user_path = "./database/"+username+"/";
% get gmm model with user path
load(user_path+"gmm.mat", "gmm"); 

end
