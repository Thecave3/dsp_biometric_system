clc;
clear;
threshold = 0.7;
username = "andrea";
time = 3;
disp("Begin enrollment");
enrollment(time,username);
disp("End enrollment");
disp("Verification will start in "+ num2str(time/2)+ " seconds.")
pause(time/2);
disp("Begin verification");
verification(time,username,threshold);