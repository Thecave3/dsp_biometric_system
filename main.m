clc;
clear;
word = "home";
time = 4;
threshold = 200;

enroll = 0;
recon = 1;
    
if enroll
    disp("Begin enrollment of word: "+word);
    enrollment(time,word);
    disp("End enrollment");
end

if recon
    disp("Recognition will start in "+ num2str(time/2)+ " seconds with a threshold of "+ num2str(threshold)+".");
    pause(time/2);
    recognition(time,threshold);
end