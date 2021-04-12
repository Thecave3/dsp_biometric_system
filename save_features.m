function save_features(features,word,i)
% function  save_features(features,word,i)
% save the features extracted in the database
% each word in the database has a dedicated folder 

main_path = "./database/";
word_path = main_path+word;
if not(isfolder(word_path))
    mkdir(word_path)
end

% save features
save(word_path+"/"+word+"_"+i+".mat", 'features') 

end
