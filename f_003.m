clear all,close all,clc;
%%
% the name and location of the states are from
% 'https://www.ine.mx/voto-y-elecciones/elecciones-2021/'
% the CovCases data vector is from 
% 'https://www.nytimes.com/interactive/2021/world/mexico-covid-cases.html'
% import the image
im1 = imread('mexico_map.png');
% gray-scale it
im1=rgb2gray(im1);
% "im1" was imported as "uint8" and it's required to be a "double"
im1=255*double(im1>uint8(200));
% display it
imshow(im1);
% check the size
size(im1)
% analyze the image-properties
min(im1(:))
max(im1(:))
imhist(im1(:))
im1=double(im1);
imshow(im1)
%%
% threshold to get 0-1 image
im2_logical=double(im1)>0;
im2=255*double(im2_logical);
% iteratively adjust the thres.-level to get a good binary-im
% during the tuning process use "montage fcn" to plot em together
% montage({im1,im2});
imshow(im2);
class(im2)
%% opening-closing operations done on im2 [to eliminate the random-lil-dots]
% se = strel('disk',1);
% closeBW = imclose(im2,se);
% % montage({im2,closeBW});
% se = strel('disk',1);
% afterOpening = imopen(closeBW,se);
% montage({im2,afterOpening});
% im2=afterOpening;
% im2_logical=im2>.5;
%% plot a dot on the image [to determine the location of the point hover over the point and see the location]
imagesc(im2);
hold on;
plot(150,200,'r*','MarkerSize',[10]);
im2=double(im2);
%%
% generate bunch of randNumS to determine a good interior point for each of
% the regions [there are 8 regions in that pic]
rng(1)
X1 = randi([1,size(im2,2)],5000,1);
X2 = randi([1,size(im2,1)],5000,1);
X=[X1,X2];
imagesc(im2);   hold on;
plot(X(:,1),X(:,2),'r*','MarkerSize',[5]);
grid on;
grid minor;
%% determine a "center point" for all of the "regions" [es una process-manual]
% these values visually-determined-by-the-user
reg01_pt=[430,410];
reg02_pt=[60,100];
reg03_pt=[120,220];
reg04_pt=[820,520];
reg05_pt=[750,600];
reg06_pt=[300,160];
reg07_pt=[530,500];
reg08_pt=[440,200];
reg09_pt=[380,510];
reg10_pt=[350,300];

reg11_pt=[510,500];
reg12_pt=[470,450];
reg13_pt=[500,550];
reg14_pt=[540,460];
reg15_pt=[400,460];
reg16_pt=[450,500];
reg17_pt=[530,520];
reg18_pt=[350,400];
reg19_pt=[500,300];
reg20_pt=[600,600];

reg21_pt=[570,520];
reg22_pt=[500,460];
reg23_pt=[880,500];
reg24_pt=[500,400];
reg25_pt=[280,320];
reg26_pt=[200,150];
reg27_pt=[740,540];
reg28_pt=[570,300];
reg29_pt=[560,500];
reg30_pt=[620,520];

reg31_pt=[850,450];
reg32_pt=[400,350];
reg_vec=[reg01_pt;reg02_pt;reg03_pt;reg04_pt;reg05_pt;...
         reg06_pt;reg07_pt;reg08_pt;reg09_pt;reg10_pt;...
         reg11_pt;reg12_pt;reg13_pt;reg14_pt;reg15_pt;...
         reg16_pt;reg17_pt;reg18_pt;reg19_pt;reg20_pt;...
         reg21_pt;reg22_pt;reg23_pt;reg24_pt;reg25_pt;...
         reg26_pt;reg27_pt;reg28_pt;reg29_pt;reg30_pt;...
         reg31_pt;reg32_pt];
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
exterior_layout=zeros(size(im2,1),size(im2,2));
for ii=1:1:32
    reg1 = grayconnected(im2,reg_vec(ii,1),reg_vec(ii,2));
    area_layout_tensor(:,:,ii)=double(reg1);
    exterior_layout=exterior_layout+reg1;
end
imagesc(exterior_layout)
%%
pause(1);
for ii=1:1:32
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
%% white background
redChannel  =255*ones(size(im2,1),size(im2,2),'uint8');
greenChannel=255*ones(size(im2,1),size(im2,2),'uint8');
blueChannel =255*ones(size(im2,1),size(im2,2),'uint8');
% redChannel   =    [(63-0)/(255-0)]*   redChannel  .*uint8(~exterior_layout);
% greenChannel =    [(72-0)/(255-0)]*   greenChannel.*uint8(~exterior_layout);
% blueChannel  =    [(204-0)/(255-0)]*   blueChannel .*uint8(~exterior_layout);
redChannel   =    [1]*   redChannel  .*uint8(~exterior_layout);
greenChannel =    [1]*   greenChannel.*uint8(~exterior_layout);
blueChannel  =    [1]*   blueChannel .*uint8(~exterior_layout);
white_background_rgbImage = cat(3, redChannel, greenChannel, blueChannel);
imagesc(white_background_rgbImage);
%%
% rng(123);
temp_rgb=[];
[sum_rgb] = colored_region_image(area_layout_tensor,[1],[rand(1,3)]);
for ii=1:1:32
    [temp_rgb] = colored_region_image(area_layout_tensor,[ii],[rand(1,3)]);
    sum_rgb=sum_rgb+temp_rgb;
end
imagesc(sum_rgb+outline_rgbImage);
%% get the cov-case-per-100k-datas
covCaso=[8,4,9,15,2,3,25,11,33,7,...
         6,11,10,9,13,6,12,12,18,9,...
         7,19,11,16,6,11,37,12,11,8,...
         15,6];
min_arr=min(covCaso);
max_arr=max(covCaso);
normalized_covCaso=(covCaso-min_arr)./(max_arr-min_arr);
%% PLOT THE COVI-MAP
temp_rgb=[];
sum_rgb=[];
% [sum_rgb] = colored_region_image(area_layout_tensor,[1],[normalized_covCaso(1),0,1-normalized_covCaso(1)]);
for ii=1:1:32
    [temp_rgb] = colored_region_image(area_layout_tensor,[ii],[normalized_covCaso(ii),0,1-normalized_covCaso(ii)]);
    if ii==1
        [sum_rgb] = colored_region_image(area_layout_tensor,[1],[normalized_covCaso(1),0,1-normalized_covCaso(1)]);
    else
        sum_rgb=sum_rgb+temp_rgb;
    end
end
imagesc(sum_rgb+white_background_rgbImage,'AlphaData',.8);
imagesc(white_background_rgbImage,'AlphaData',.8);
%%
imwrite(sum_rgb+white_background_rgbImage,'Mexico_colored_map.png');














%