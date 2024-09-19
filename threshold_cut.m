function [pic_cut] = threshold_cut(pic)
se = strel('disk', 5); %构造结构元素
pictop = imtophat(pic, se);  % 高帽变换
picbot = imbothat(pic, se);  % 低帽变换
picenhance = imsubtract(imadd(pictop, pic), picbot);% 高帽图像与低帽图像相减，增强图像
pic_half=im2bw(picenhance,40/255); % im2bw函数需要将灰度值转换到[0,1]范围内
pic_half = bwareaopen(pic_half,100); %清除小面积块，可更改阈值
se = strel('disk',round(numel(pic_half)/15000));
pic_cut = imclose(pic_half,se); 
end

