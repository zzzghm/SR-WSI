%Tested with 5x_1, 10x_1, 20x_1 
%8/5/20
clc 
clear all 
close all 

% %Import bigTIFF
i5=imread('/home/hzhuge/Downloads/SR_2D/2020_07_30__16_47__1451.tif');
%i10 = imread('/home/hzhuge/Downloads/patches_code/2020_07_30__18_44__1459.tif');
i20 =imread('/home/hzhuge/Downloads/SR_2D/2020_07_28__22_16__1421.tif');
%Folder for saving patches 
outpath5 = '/home/hzhuge/Downloads/patches_code/5x_patches/';
outpath10 = '/home/hzhuge/Downloads/patches_code/10x_patches/';
%outpath20 = 'C:\Users\kashman\Documents\Data\Focus\Super-resolution\20x\small_patches\';

%Height and width of patches - 1 
height_5x = 127; 
width_5x = 127; 

height_10x = 255; 
width_10x = 255; 

height_20x = 511; 
width_20x = 511; 

%%Factors for translating between 5x and 10x, 5x and 20x 
%UPDATE THESE values based on translation found with SIFT (jupyter
%notebook) 
%use float values for greater accuracy 
final_factor_10 = 0.5031252824091897;
global_shiftx_10 = -22.520530964215588*10; %Multiply by 10 because WSI was downsized 10% 
global_shifty_10 =53.65446798614152*10;

final_factor_20= 0.2507182907832122;
global_shiftx_20= 18.609092461914457;
global_shifty_20= 539.0454236079352;

%Size of 5x image 
[y5,x5,channels] = size(i5);
%Size of 10x image 
[y10,x10,channels] = size(i10);
%Size of 20x image 
%[y20,x20,channels] = size(i20);

%Determine number of patches for height and width, use the smallest value of 5x,10x,20x / size of tile 
a = min(floor(x5/128),floor(x10/256));
b = min(floor(y5/128),floor(y10/256)); 
 
for m=6:a %Start with 6 because of shift start position would be negative at 0, this can be increased to minimize white space
    for n=6:b
%     %5x patch 
    starty = 128*(n-1);  
    startx =128*(m-1);
    img5x_patch =i5(starty:(height_5x+starty), startx:(width_5x+startx),:);
    
    s=strcat('5x','_',num2str(m),'_',num2str(n),'.png'); 
	fullFileName=fullfile(outpath5,s); 
	imwrite(img5x_patch,fullFileName)
    
    %10x patch 
    startx = round((startx-global_shiftx_10)/final_factor_10);  
    starty = round((starty -global_shifty_10)/final_factor_10); 
    img10x_patch =i10(starty:(height_10x+starty), startx:(width_10x+startx),:);
    
    %small_patch=uint8(256,384,3);
    %small_patch(1:128,1:128,:)=img5x_patch;
    %small_patch(1:256,129:384,:)=img10x_patch;
    
    s=strcat('10x','_',num2str(m),'_',num2str(n),'.png'); 
	fullFileName=fullfile(outpath10,s); 
	imwrite(img10x_patch,fullFileName)
    
%     %20x patch 
%     startx = round((startx-global_shiftx_20)/final_factor_20);  
%     starty = round((starty -global_shifty_20)/final_factor_20); 
%     img20x_patch =i20(starty:(height_20x+starty), startx:(width_20x+startx),:);
%     
%     s=strcat('20x','_',num2str(m),'_',num2str(n),'.png'); 
% 	fullFileName=fullfile(outpath20,s); 
% 	imwrite(img20x_patch,fullFileName)
    
    
    end
end
