function [ pic_cut ] = denoise( pic )
IM= bwareaopen(pic,round(1/20*numel(pic)));%�Ѱ������ص��ٵİ�ɫ����ȥ��

se = strel('disk',round(numel(IM)/15000));
IM=imopen(IM,se);%������

IM= bwareaopen(IM,round(1/20*numel(IM)));%�Ѱ������ص��ٵİ�ɫ����ȥ��

se=fspecial('average',[5,5]);%ƽ���˲�
pic_cut=imfilter(IM,se);

end

