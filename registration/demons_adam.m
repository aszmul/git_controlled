clear all; close all; clc;

iteration_pre = 10;     % if 0 then this step is omitted
iteration_fine =100;    % if 0 then this step is omitted

iteration_final = 1;    % number of iteration in fine registration
pre_reg_fact = 5;     % preregistration resize coefficient

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rigid Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I_rigid = draw_circle(100, 100, 25, 25, 12);
%I_rigid = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\elipse.jpg')));
%I_rigid = im2double((imread('C:\work\matlab\obrazki\demons\kolko_3.jpg')));
%I_rigid = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\kolko_rigid.jpg')));
%I_rigid = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\kolko_rigid.jpg')));
%I_rigid = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\lena_rigid.jpg')));
I_rigid = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\brain_FLAIR.jpg')));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I_mov = draw_circle(100, 100, 35, 35, 12);
%I_mov = imread('C:\work\matlab\obrazki\demons\kolko_3.jpg')/255;
%I_mov = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\kolko_mov_2.jpg')));
%I_mov = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\square.jpg')));
%I_mov = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\lena_mov.jpg')));
%I_mov = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\brain_mov.jpg')));
%I_mov = im2double((imread('C:\work\matlab\obrazki\demons\kolko_4.jpg')));
I_mov = im2double(rgb2gray(imread('C:\work\matlab\obrazki\demons\brain_mov_3.jpg')));

%I_mov = im2double(rgb2gray(I_mov));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 I_mov(isnan(I_mov)) = mean(mean(I_mov(~isnan(I_mov))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Images resize
I_mov_resize = imresize(I_mov,pre_reg_fact);
I_rigid_resize = imresize(I_rigid,pre_reg_fact);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Transformation Matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Tx=zeros(size(I_mov_resize)); 
Ty=zeros(size(I_mov_resize));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Registration with use demons algoritm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preregistration with preregistration resize factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma = 10;
range = [ceil(3/2*sigma)*4+1 ceil(3/2*sigma)*4+1];
%range = [40 40];



    [I_register, Tx, Ty] = registration_demons(I_rigid_resize, I_mov_resize,Tx,Ty,iteration_pre, range * pre_reg_fact, sigma*pre_reg_fact);
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rescaling to normal size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
Tx_1 = imresize(Tx./pre_reg_fact ,size(I_mov));
Ty_1 = imresize(Ty./pre_reg_fact ,size(I_mov));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Registration after rescaling transformation field
% It is not needed in registration without resizing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [x,y]=ndgrid(1:size(I_rigid,1),1:size(I_rigid,2));
       
 I_register = interp2(I_mov, y+Ty_1,x+Tx_1);         % notice switched axis
 
 
 I_register(isnan(I_register)) = mean(mean(I_register(~isnan(I_register))));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualization of preregistration images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_register_pre = I_register;

figure
subplot(2,3,1), imshow(I_mov,[]); title('Image mov');
subplot(2,3,2), imshow(I_rigid,[]); title('Image rigid');
subplot(2,3,3), imshow(I_register_pre,[]); title('Registered');
subplot(2,3,4), imshow(I_mov - I_rigid,[]); title('Diff before');
subplot(2,3,5), imshow(I_register_pre - I_rigid,[]); title('Diff after');
subplot(2,3,6), imshow(I_mov - I_register_pre,[]); title('Diff def');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Registration fine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:iteration_final

Tx=zeros(size(I_rigid)); 
Ty=zeros(size(I_rigid));


    
[I_register, Tx, Ty] = registration_demons(I_rigid, I_register_pre,Tx,Ty,iteration_fine, range,sigma);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
figure
imagesc(I_register-I_rigid);
title('I register - I rigid')
colormap(gray)

figure
imagesc(I_register-I_mov);
title('I register - I mov')
colormap(gray) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% figure 
% imagesc(I_register)
% colormap(gray)
%   
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%
% figure
% imagesc(I_rigid);
% colormap(gray)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
figure
subplot(2,3,1), imshow(I_register_pre,[]); title('Image mov');
subplot(2,3,2), imshow(I_rigid,[]); title('Image rigid');
subplot(2,3,3), imshow(I_register,[]); title('Registered');
subplot(2,3,4), imshow(I_register_pre - I_rigid,[]); title('Diff before');
subplot(2,3,5), imshow(I_register - I_rigid,[]); title('Diff after');
subplot(2,3,6), imshow(I_register_pre - I_register,[]); title('Diff def');