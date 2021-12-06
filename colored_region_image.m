function [regX_rgbImage] = colored_region_image(area_layout_tensor,reg_num,color_vec13)
% [R,G,B] each one is in the interval of [0,1]
% [1,0.2,0.1]

redChannel=255*ones(size(area_layout_tensor(:,:,reg_num),1),size(area_layout_tensor(:,:,reg_num),2),'uint8');
greenChannel=255*ones(size(area_layout_tensor(:,:,reg_num),1),size(area_layout_tensor(:,:,reg_num),2),'uint8');
blueChannel=255*ones(size(area_layout_tensor(:,:,reg_num),1),size(area_layout_tensor(:,:,reg_num),2),'uint8');
redChannel   =    [color_vec13(1)]*   redChannel.*uint8(area_layout_tensor(:,:,reg_num));
greenChannel =    [color_vec13(2)]*   greenChannel.*uint8(area_layout_tensor(:,:,reg_num));
blueChannel  =    [color_vec13(3)]*   blueChannel.*uint8(area_layout_tensor(:,:,reg_num));
regX_rgbImage = cat(3, redChannel, greenChannel, blueChannel);


end

