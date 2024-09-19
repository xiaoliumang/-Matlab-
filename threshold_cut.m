function [pic_cut] = threshold_cut(pic)
se = strel('disk', 5); %����ṹԪ��
pictop = imtophat(pic, se);  % ��ñ�任
picbot = imbothat(pic, se);  % ��ñ�任
picenhance = imsubtract(imadd(pictop, pic), picbot);% ��ñͼ�����ñͼ���������ǿͼ��
pic_half=im2bw(picenhance,40/255); % im2bw������Ҫ���Ҷ�ֵת����[0,1]��Χ��
pic_half = bwareaopen(pic_half,100); %���С����飬�ɸ�����ֵ
se = strel('disk',round(numel(pic_half)/15000));
pic_cut = imclose(pic_half,se); 
end

