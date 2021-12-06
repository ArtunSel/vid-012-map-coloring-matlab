clear all,close all,clc;
%%
% import the image
im1 = imread('romania_map.png');
% gray-scale it
im1=rgb2gray(im1);
% display it
imshow(im1);
% check the size
size(im1)
% analyze the image-properties
min(im1(:))
max(im1(:))
imhist(im1)
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
se = strel('disk',1);
closeBW = imclose(im2,se);
% montage({im2,closeBW});
se = strel('disk',1);
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
% generate bunch of randNumS to determine a good interior point for each of
% the regions [there are 8 regions in that pic]
X1 = randi([1,size(im2,2)],500,1);
X2 = randi([1,size(im2,1)],500,1);
X=[X1,X2];
imagesc(im2);   hold on;
plot(X(:,1),X(:,2),'r*','MarkerSize',[10]);
%% determine a "center point" for all of the "regions" [es una process-manual]
% these values visually-determined-by-the-user
reg01_pt=[230,100];
reg02_pt=[400,100];
reg03_pt=[120,250];

reg04_pt=[260,220];
reg05_pt=[500,220];
reg06_pt=[130,350];

reg07_pt=[250,400];
reg08_pt=[400,400];
reg09_pt=[600,400];
reg_vec=[reg01_pt;reg02_pt;reg03_pt;reg04_pt;...
         reg05_pt;reg06_pt;reg07_pt;reg08_pt;reg09_pt];
reg_vec=[reg_vec(:,2),reg_vec(:,1)];
%% check if "grayconnected" has some issues w detecting the regions
ii=5;regt = grayconnected(im2,reg_vec(ii,1),reg_vec(ii,2));
montage({im2,regt});
%% check if "grayconnected" has some issues w detecting the regions
tiledlayout(1,2);
nexttile
imagesc(im2);text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12],'Color','r');
nexttile
imagesc(regt);text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12],'Color','b');
%%
area_layout_tensor=zeros(size(im2,1),size(im2,2),9);
for ii=1:1:9
    reg1 = grayconnected(im2,reg_vec(ii,1),reg_vec(ii,2));
    area_layout_tensor(:,:,ii)=double(reg1);
end
%%
for ii=1:1:9
    reg1=area_layout_tensor(:,:,ii);
%     montage({im2,reg1+(~im2)});
    imagesc(reg1+(~im2))
    text(reg_vec(ii,2),reg_vec(ii,1),[' ',num2str(ii)],'FontSize',[12]);
    drawnow;
    pause(1);
end
%% plot the colored "map"
imshow(im2);
% construct the "outline-image" boundaries
redChannel=255*ones(size(im2,1),size(im2,2),'uint8');
greenChannel=255*ones(size(im2,1),size(im2,2),'uint8');
blueChannel=255*ones(size(im2,1),size(im2,2),'uint8');
redChannel   =    [1]*   redChannel.*uint8(~im2_logical);
greenChannel =    [0]*   greenChannel.*uint8(~im2_logical);
blueChannel  =    [0]*   blueChannel.*uint8(~im2_logical);
outline_rgbImage = cat(3, redChannel, greenChannel, blueChannel);
imagesc(outline_rgbImage);

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
[reg9_rgbImage] = colored_region_image(area_layout_tensor,[9],[.5,0,.5]);
im_tot=reg1_rgbImage+reg2_rgbImage+reg3_rgbImage+reg4_rgbImage+...
    +reg5_rgbImage+reg6_rgbImage+reg7_rgbImage+reg8_rgbImage+reg9_rgbImage;
imagesc(im_tot+outline_rgbImage);
%%
% you can generate the colours randomly
[reg1_rgbImage] = colored_region_image(area_layout_tensor,[1],[rand(1,3)]);
[reg2_rgbImage] = colored_region_image(area_layout_tensor,[2],[rand(1,3)]);
[reg3_rgbImage] = colored_region_image(area_layout_tensor,[3],[rand(1,3)]);
[reg4_rgbImage] = colored_region_image(area_layout_tensor,[4],[rand(1,3)]);
[reg5_rgbImage] = colored_region_image(area_layout_tensor,[5],[rand(1,3)]);
[reg6_rgbImage] = colored_region_image(area_layout_tensor,[6],[rand(1,3)]);
[reg7_rgbImage] = colored_region_image(area_layout_tensor,[7],[rand(1,3)]);
[reg8_rgbImage] = colored_region_image(area_layout_tensor,[8],[rand(1,3)]);
[reg9_rgbImage] = colored_region_image(area_layout_tensor,[9],[rand(1,3)]);
im_tot=reg1_rgbImage+reg2_rgbImage+reg3_rgbImage+reg4_rgbImage+...
    +reg5_rgbImage+reg6_rgbImage+reg7_rgbImage+reg8_rgbImage+reg9_rgbImage;
imagesc(im_tot+outline_rgbImage);
%%
imwrite(im_tot+outline_rgbImage,'Romania_colored_map.png');














%