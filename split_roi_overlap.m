%Tested with 5x_1, 10x_1, 20x_1 
%8/5/20
%clc 
%clear all 
%close all 

% %Import bigTIFF
%i5=imread('/home/hzhuge/Downloads/patches_code/2020_07_30__16_47__1451.tif');
%i10 = imread('/home/hzhuge/Downloads/patches_code/2020_07_30__18_44__1459.tif');
%i20 =imread('/home/hzhuge/Downloads/patches_code/2020_07_28__22_16__1421.tif');
%Folder for saving patches 

%mkdir('/home/hzhuge/Downloads/patches_code/stitch/test3/5x_overlap/');
%outpath5 = '/home/hzhuge/Downloads/patches_code/stitch/test3/5x_overlap/';
%mkdir('/home/hzhuge/Downloads/patches_code/stitch/test3/10x_overlap/');
%outpath10 = '/home/hzhuge/Downloads/patches_code/stitch/test3/10x_overlap/';
mkdir('/home/hzhuge/Downloads/patches_code/stitch/test6/20x_overlap/');
outpath20 = '/home/hzhuge/Downloads/patches_code/stitch/test6/20x_overlap/';
mkdir('/home/hzhuge/Downloads/patches_code/stitch/test6/4x_stitch_overlap/');
outpath = '/home/hzhuge/Downloads/patches_code/stitch/test6/4x_stitch_overlap/';

%Height and width of patches - 1 
height_5x = 63; 
width_5x = 63;
overlap_5x= 32;

height_10x = 127; 
width_10x = 127; 
overlap_10x=64;

height_20x = 255; 
width_20x = 255;
overlap_20x=128;

%%Factors for translating between 5x and 10x, 5x and 20x 
%UPDATE THESE values based on translation found with SIFT (jupyter
%notebook) 
%use float values for greater accuracy 
final_factor_10 = 0.5031252824091897;
global_shiftx_10 = -233.20530964215588; %Multiply by 10 because WSI was downsized 10% 
global_shifty_10 =527.5446798614152;

final_factor_20= 0.25089277633586865;
global_shiftx_20= 15.31724229625895;
global_shifty_20= 552.7097477177516;

%final_factor_20= 0.25089277633586865;
%global_shiftx_20= 10.31724229625895;
%global_shifty_20= 530.7097477177516;

%Size of 5x image 
[y5,x5,channels] = size(i5);
%Size of 10x image 
%[y10,x10,channels] = size(i10);
%Size of 20x image 
[y20,x20,channels] = size(i20);

%Determine number of patches for height and width, use the smallest value of 5x,10x,20x / size of tile 
%a = min(floor(x5/64),floor(x10/128));
%b = min(floor(y5/64),floor(y10/128)); 
a = min(floor(x5/64),floor(x20/256));
b = min(floor(y5/64),floor(y20/256));

m_min=59;
basex=64*m_min;
n_min=89;
basey=64*n_min;

for m=m_min:m_min+40 %Start with 6 because of shift start position would be negative at 0, this can be increased to minimize white space
    for n=n_min:n_min+40
%m=m_min;n=n_min;
%     %5x patch 
    
    starty = overlap_5x*(n-n_min)+basey;  
    startx = overlap_5x*(m-m_min)+basex;
    img5x_patch =i5(starty:(height_5x+starty), startx:(width_5x+startx),:);
    
    %s=strcat('5x','_',num2str(m),'_',num2str(n),'.png'); 
	%fullFileName=fullfile(outpath5,s); 
	%imwrite(img5x_patch,fullFileName)
    
    %10x patch 
    %startx = round((startx-global_shiftx_10)/final_factor_10);  
    %starty = round((starty -global_shifty_10)/final_factor_10); 
    %img10x_patch =i10(starty:(height_10x+starty), startx:(width_10x+startx),:);
 
    
    %s=strcat('10x','_',num2str(m),'_',num2str(n),'.png'); 
	%fullFileName=fullfile(outpath10,s); 
	%imwrite(img10x_patch,fullFileName);
    
    %level=graythresh(img5x_patch);
    %bw_5x=imbinarize(img5x_patch,level);
    %min_5x=min(img5x_patch(:));
    %max_5x=max(img5x_patch(:));
    
    %if abs(max_5x-min_5x)>100
     %20x patch 
      startx = round((startx-global_shiftx_20)/final_factor_20);  
      starty = round((starty -global_shifty_20)/final_factor_20); 
      img20x_patch =i20(starty:(height_20x+starty), startx:(width_20x+startx),:);
      
      s=strcat('20x','_',num2str(m),'_',num2str(n),'.png'); 
      fullFileName=fullfile(outpath20,s); 
      imwrite(img20x_patch,fullFileName)
    
%        small_patch=uint8(zeros(128,192,3));
%        small_patch(1:64,1:64,:)=img5x_patch;
%        small_patch(1:128,65:192,:)=img10x_patch;
       
       small_patch=uint8(zeros(256,320,3));
       small_patch(1:64,1:64,:)=img5x_patch;
       small_patch(1:256,65:320,:)=img20x_patch;

       s=strcat('pair5&20','_',num2str(m),'_',num2str(n),'.png'); 
       fullFileName=fullfile(outpath,s); 
	   imwrite(small_patch,fullFileName);
    %end
    
   end
end