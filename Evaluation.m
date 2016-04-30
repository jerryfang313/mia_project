% Test program for Project 1 & 2
% Please make sure you have all necessary file in the searching directory,
% including getim.m and ground truth mask for project 1

%  Both evaluate functions are test version, I will appreciate it if you can
%  report any abnormalities and any valuable suggestions !

%% Run your project 1 program
% the result should be a bounding circle given by (x,y,r) 
% And a 2D BINARY MASK for microcalcification
tic
% >>>>>>>>>>>>>>>>> Call your P1 program here <<<<<<<<<<<<<<<<<<




% >>>>>>>>>>>>>>>>> End of your P1 program <<<<<<<<<<<<<<<<<<<<<
curr = toc;

%% Evaluate project 1 result
score_P1 = evaluate_seg(id,x,y,r,yourmask,x_true,y_true,r_true,curr);

%%  Run your project 2 program 
% the result here should be a 3D BINARY bounding BOX
tic
% >>>>>>>>>>>>>>>>> Call your P2 program here <<<<<<<<<<<<<<<<<<



% >>>>>>>>>>>>>>>>> End of your P2 program <<<<<<<<<<<<<<<<<<<<<
curr = toc;

%% %% Evaluate project 2 result
score_P2 = evaluate_reg(yourbox,truebox,curr);
