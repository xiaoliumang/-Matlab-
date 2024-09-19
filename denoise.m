function [ pic_cut ] = denoise( pic )
IM= bwareaopen(pic,round(1/20*numel(pic)));%把包含像素点少的白色区域去除

se = strel('disk',round(numel(IM)/15000));
IM=imopen(IM,se);%开操作

IM= bwareaopen(IM,round(1/20*numel(IM)));%把包含像素点少的白色区域去除

se=fspecial('average',[5,5]);%平滑滤波
pic_cut=imfilter(IM,se);

end

