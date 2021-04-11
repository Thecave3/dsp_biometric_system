clc;
clear;
threshold = eye (398,16);
username = "andrea";
time = 4;
disp("Begin enrollment");
enrollment(time,username);
disp("End enrollment");
disp("Verification will start in"+ num2str(ti)+ " seconds.")
pause(sample_time/2);
disp("Begin verification");
verification(time,username,threshold);