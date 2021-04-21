function recognition(sample_time,acceptance_trshd)
% function recognition(sample_time,word,acceptance_trshd)
% routine that performs the recognition of a word
% sample_time represents the recording time
% acceptance_trshd indicates the minimum acceptance distance

[data,info]= record_audio(sample_time);
% plot(data);

extracted_ftrs = feature_extraction(data,info);

% Iterate over the database to find the minimum distance
database = './database';
databaseFolder = dir(fullfile(database,'*'));
% list of subfolders of the database representing the words.
words = setdiff({databaseFolder([databaseFolder.isdir]).name},{'.','..'}); 

best_match ="";
% since we want min distance we start with a bigger (and impossible) one
best_dist = 10000000000;

for ii = 1:numel(words)
    word = dir(fullfile(database,words{ii},'*.mat'));
    templates = {word(~[word.isdir]).name}; % files in subfolder.
    for jj = 1:numel(templates)
        fileTemplate = fullfile(database,words{ii},templates{jj});
        template =  load(fileTemplate).features;
        distance = dtw(transpose(extracted_ftrs),transpose(template),'absolute');
        if distance < best_dist
            best_match = fileTemplate;
            best_dist = distance;
        end
    end
end

if best_dist < acceptance_trshd
   best_match = split(best_match,"\");
   best_match = best_match(3);
    disp("Word guessed is: '"+best_match+"' (dist: "+num2str(best_dist)+")!"); 
else
    disp("Word not recognized!"); 
    disp("Closest guess: '"+best_match+"' (dist: "+num2str(best_dist)+").");
end

end