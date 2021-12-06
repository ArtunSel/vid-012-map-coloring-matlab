clear all,close all,clc;
%%
% import the image
im1 = imread('pic1.png');
% gray-scale it
im1=rgb2gray(im1);
% display it
imshow(im1);
% check the size
size(im1)
% analyze the image-properties
min(im1(:))
max(im1(:))
imhist(im1(:))
class(im1)
size(im1)
%%
% threshold to get 0-1 image
im2_logical=im1>140;
im2=double(im2_logical);
% iteratively adjust the thres.-level to get a good binary-im
% during the tuning process use "montage fcn" to plot em together
% montage({im1,im2});
imshow(im2);
class(im2)
%% opening-closing operations done on im2 [to eliminate the random-lil-dots]
se = strel('disk',3);
closeBW = imclose(im2,se);
% montage({im2,closeBW});
se = strel('disk',3);
afterOpening = imopen(closeBW,se);
montage({im2,afterOpening});
im2=afterOpening;
im2_logical=im2>.5;
%% plot a dot on the image [to determine the location of the point hover over the point and see the location]
imagesc(im2);
hold on;
plot(150,200,'r*','MarkerSize',[10]);
im2=double(im2);
%%
rng(123);
% generate bunch of randNumS to determine a good interior point for each of
% the regions [there are 8 regions in that pic]
X1 = randi([1,size(im2,2)],250,1);
X2 = randi([1,size(im2,1)],250,1);
X=[X1,X2];
imagesc(im2);   hold on;
plot(X(:,1),X(:,2),'r*','MarkerSize',[10]);
%% determine a "center point" for all of the "regions" [es una process-manual]
% these values visually-determined-by-the-user
reg01_pt=[150,150];
reg02_pt=[300,200];
reg03_pt=[500,160];
reg04_pt=[100,400];

reg05_pt=[300,400];
reg06_pt=[400,400];
reg07_pt=[600,300];
reg08_pt=[700,400];
reg_vec=[reg01_pt;reg02_pt;reg03_pt;reg04_pt;...
         reg05_pt;reg06_pt;reg07_pt;reg08_pt];
reg_vec=[reg_vec(:,2),reg_vec(:,1)];
%% check if "grayconnected" has some issues w detecting the regions
ii=1;regt = grayconnected(im2,reg_vec(ii,1),reg_vec(ii,2));
montage({im2,regt});
%% check if "grayconnected" has some issues w detecting the regions
tiledlayout(1,2);
nexttile
imagesc(im2);text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12],'Color','r');
nexttile
imagesc(regt);text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12],'Color','b');
%%
area_layout_tensor=zeros(size(im2,1),size(im2,2),8);
for ii=1:1:8
    reg1 = grayconnected(im2,reg_vec(ii,1),reg_vec(ii,2));
    area_layout_tensor(:,:,ii)=double(reg1);
end
%%
for ii=1:1:8
    reg1=area_layout_tensor(:,:,ii);
%     montage({im2,reg1+(~im2)});
    imagesc(reg1+(~im2))
    text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12]);
    drawnow;
    pause(1);
end
%% plot the colored "map"
imshow(im2);
imshow(~im2_logical)
% construct the "outline-image" boundaries
redChannel=255*ones(size(im2,1),size(im2,2),'uint8');
greenChannel=255*ones(size(im2,1),size(im2,2),'uint8');
blueChannel=255*ones(size(im2,1),size(im2,2),'uint8');
redChannel   =    [1]*   redChannel.*uint8(~im2_logical);
greenChannel =    [0]*   greenChannel.*uint8(~im2_logical);
blueChannel  =    [0]*   blueChannel.*uint8(~im2_logical);
outline_rgbImage = cat(3, redChannel, greenChannel, blueChannel);
imagesc(outline_rgbImage);
%% make "reg-1" "red"
ii=1;
redChannel=255*ones(size(im2,1),size(im2,2),'uint8');
greenChannel=255*ones(size(im2,1),size(im2,2),'uint8');
blueChannel=255*ones(size(im2,1),size(im2,2),'uint8');
redChannel   =    [1]*   redChannel.*uint8(area_layout_tensor(:,:,ii));
greenChannel =    [0]*   greenChannel.*uint8(area_layout_tensor(:,:,ii));
blueChannel  =    [0]*   blueChannel.*uint8(area_layout_tensor(:,:,ii));
reg1_rgbImage = cat(3, redChannel, greenChannel, blueChannel);
imagesc(reg1_rgbImage);
%%
% [regX_rgbImage] = colored_region_image(area_layout_tensor,reg_num,color_vec13)
[reg1_rgbImage] = colored_region_image(area_layout_tensor,[1],[1,0,0]);
imagesc(reg1_rgbImage);text(reg_vec([1],2),reg_vec([1],1),[' ',num2str([1])],'FontSize',[12]);
% make "reg-2" "blue"
% ii=2;
% redChannel=255*ones(size(im2,1),size(im2,2),'uint8');greenChannel=255*ones(size(im2,1),size(im2,2),'uint8');blueChannel=255*ones(size(im2,1),size(im2,2),'uint8');
% redChannel   =    [0]*   redChannel.*uint8(area_layout_tensor(:,:,ii));
% greenChannel =    [0]*   greenChannel.*uint8(area_layout_tensor(:,:,ii));
% blueChannel  =    [1]*   blueChannel.*uint8(area_layout_tensor(:,:,ii));
% reg2_rgbImage = cat(3, redChannel, greenChannel, blueChannel);
% [regX_rgbImage] = colored_region_image(area_layout_tensor,reg_num,color_vec13)
[reg2_rgbImage] = colored_region_image(area_layout_tensor,[2],[0,0,1]);
imagesc(reg2_rgbImage);text(reg_vec([2],2),reg_vec([2],1),[' ',num2str([2])],'FontSize',[12]);
%
imagesc(reg2_rgbImage+outline_rgbImage);text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12]);
imagesc(reg1_rgbImage+reg2_rgbImage+outline_rgbImage);
ii=1;text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12]);
ii=2;text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12]);

%%
% you can use "de2bi([1:1:7]')"
[reg1_rgbImage] = colored_region_image(area_layout_tensor,[1],[1,0,0]);
[reg2_rgbImage] = colored_region_image(area_layout_tensor,[2],[0,1,0]);
[reg3_rgbImage] = colored_region_image(area_layout_tensor,[3],[1,1,0]);
[reg4_rgbImage] = colored_region_image(area_layout_tensor,[4],[0,0,1]);
[reg5_rgbImage] = colored_region_image(area_layout_tensor,[5],[1,0,1]);
[reg6_rgbImage] = colored_region_image(area_layout_tensor,[6],[0,1,1]);
[reg7_rgbImage] = colored_region_image(area_layout_tensor,[7],[1,1,1]);
[reg8_rgbImage] = colored_region_image(area_layout_tensor,[8],[.5,.5,1]);
im_tot=reg1_rgbImage+reg2_rgbImage+reg3_rgbImage+reg4_rgbImage+...
    +reg5_rgbImage+reg6_rgbImage+reg7_rgbImage+reg8_rgbImage;
imagesc(im_tot+outline_rgbImage);
imwrite([im_tot+outline_rgbImage],'pic1_colored.png');
%%