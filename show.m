function varargout = show(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show_OpeningFcn, ...
                   'gui_OutputFcn',  @show_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function show_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = show_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function button_start_Callback(hObject, eventdata, handles)

%1.Get the hardware information //��ȡӲ����Ϣ
global obj;%obj�������ط�Ҫ���ã�������Ϊȫ�ֱ���
info=imaqhwinfo('winvideo');%�������ͷӲ����Ϣ
obj=videoinput('winvideo',info.DeviceIDs{1});%������Ƶ����
set(obj,'FramesPerTrigger',1);%ÿ�δ����洢һ����Ƭ
set(obj,'ReturnedColorSpace','RGB');%����ͼ��ΪRGBģʽ

%get(obj)%��ȡobj��Ϣ���鿴�����Ƿ�ɹ������ע�͵�
axes(handles.axes1);

%2.show the video //��̬��ʾ��Ƶͼ��
Resolution=get(obj,'videoResolution');%�ֱ���
nBands=get(obj,'NumberOfBands');%Ƶ��
hImage=image(zeros(Resolution(2),Resolution(1),nBands));
preview(obj,hImage);%���ض���λ�ã�hImage����ʾ

function button_catch_Callback(hObject, eventdata, handles)

global obj;
catch_pic=getsnapshot(obj);%��ȡͼ��
catch_pic=imresize(catch_pic,[240, 320]);  %ͳһͼƬ��С
axes(handles.axes2);
imshow(catch_pic);%��axes2��ʾ��ȡ��ͼƬ
setappdata(gcf,'pic',catch_pic);%��catch_pic���ȫ�ֱ���

function button_cut_Callback(hObject, eventdata, handles)
pic1 = getappdata(gcf,'pic1'); %��ȡȫ�ֱ���
pic2 = getappdata(gcf,'pic2'); 
l = get(handles.popupmenu_choose,'value'); %��ȡ�����˵�ѡ����
if l==2  %������ֵ�ָ���������ڴ�������
    graypic = rgb2gray(pic1); %�Ҷ�ͼ��
    pic_filt=medfilt2(graypic,[3 3]); %3*3��ֵ�˲�
    axes(handles.axes3);imshow(pic_filt);
    pic_cut1 = threshold_cut(pic_filt);
    
    graypic = rgb2gray(pic2); %�Ҷ�ͼ��
    pic_filt=medfilt2(graypic,[3 3]); %3*3��ֵ�˲�
    axes(handles.axes8);imshow(pic_filt);
    pic_cut2 = threshold_cut(pic_filt);
end
if l==1  %����YCgCr��ɫ�ָ�����ڽϸ��ӱ�����
    pic_cut1 = colour_cut(pic1);
    pic_cut2 = colour_cut(pic2);
end
axes(handles.axes3);
imshow(pic_cut1);
axes(handles.axes8);
imshow(pic_cut2);
setappdata(gcf,'pic_cut1',pic_cut1);
setappdata(gcf,'pic_cut2',pic_cut2);

function popupmenu_choose_Callback(hObject, eventdata, handles)

function popupmenu_choose_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_open_Callback1(hObject, eventdata, handles)

[filename, pathname] = uigetfile( ...
{'*.bmp;*.jpg;*.fig;*.tif','MATLAB Files (*.bmp;*.jpg;*.fig;*.tif)';
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');
pic1=imread([pathname,filename]);%��ȡͼƬ��im
pic1=imresize(pic1,[240, 320]);  %ͳһͼƬ��С
axes(handles.axes2);
imshow(pic1);%��axes2��ʾ��ȡ��ͼƬ
setappdata(gcf,'pic1',pic1);%��pic���ȫ�ֱ���

function pushbutton_open_Callback2(hObject, eventdata, handles)

[filename, pathname] = uigetfile( ...
{'*.bmp;*.jpg;*.fig;*.tif','MATLAB Files (*.bmp;*.jpg;*.fig;*.tif)';
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');
pic2=imread([pathname,filename]);%��ȡͼƬ��im
pic2=imresize(pic2,[240, 320]);  %ͳһͼƬ��С
axes(handles.axes7);
imshow(pic2);%��axes2��ʾ��ȡ��ͼƬ
setappdata(gcf,'pic2',pic2);%��pic���ȫ�ֱ���

function pushbutton_denoise_Callback(hObject, eventdata, handles)
pic_cut1 = getappdata(gcf,'pic_cut1'); %��ȡȫ�ֱ���
pic_cut2 = getappdata(gcf,'pic_cut2'); %��ȡȫ�ֱ���
pic_denoise1 = denoise(pic_cut1);
pic_denoise2 = denoise(pic_cut2);
axes(handles.axes4);
imshow(pic_denoise1);
axes(handles.axes10);
imshow(pic_denoise2);
setappdata(gcf,'pic_denoise1',pic_denoise1);
setappdata(gcf,'pic_denoise2',pic_denoise2);
function popupmenu_operator_Callback(hObject, eventdata, handles)

function popupmenu_operator_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_edge_Callback(hObject, eventdata, handles)

%����ͼ��
pic1 = getappdata(gcf,'pic_denoise1'); %��ȡȫ�ֱ���
pic2 = getappdata(gcf,'pic_denoise2');
l = get(handles.popupmenu_operator,'value'); %��ȡ�����˵�ѡ����
if l == 5  %Sobel����
    pic_edge1 = edge(pic1,'sobel');
    pic_edge2 = edge(pic2,'sobel');    
end
if l == 2 %Prewitt����
    pic_edge1 = edge(pic1,'prewitt');
    pic_edge2 = edge(pic2,'prewitt');
end
if l == 3 %Roberts����
    pic_edge1 = edge(pic1,'roberts');
    pic_edge2 = edge(pic2,'roberts');
end
if l == 4 %log����
    pic_edge1 = edge(pic1,'log');
    pic_edge2 = edge(pic2,'log');    
end
if l == 1 %Canny����
    se=fspecial('gaussian',5); %��˹�˲�
    pic1=imfilter(pic1,se);
    pic_edge1 = edge(pic1,'canny');
    pic2=imfilter(pic2,se);
    pic_edge2 = edge(pic2,'canny');
end
[r c]=find(pic_edge1==1);  
% 'a'�ǰ���������С���Σ�������߳���'p'  
[rectx,recty,area,perimeter] = minboundrect(c,r,'p');   
axes(handles.axes5);
imshow(pic_edge1);
hold on  
line(rectx,recty); 
[r c]=find(pic_edge2==1);  
% 'a'�ǰ���������С���Σ�������߳���'p'  
[rectx,recty,area,perimeter] = minboundrect(c,r,'p');   
axes(handles.axes11);
imshow(pic_edge2);
hold on  
line(rectx,recty); 
setappdata(gcf,'pic_edge1',pic_edge1);%��pic_edge���ȫ�ֱ���
setappdata(gcf,'pic_edge2',pic_edge2);
function pushbutton_feature_Callback(hObject, eventdata, handles)

pic1 = getappdata(gcf,'pic_edge1'); %��ȡȫ�ֱ���
pic2 = getappdata(gcf,'pic_edge2');
feature1=fourierdescriptors(pic1); %������ͼ��ȡ����Ҷ������2-8��7��ϵ��
feature2=fourierdescriptors(pic2);
Hu1 = Humoment(pic1); %������ͼ����ȡHu������
Hu2 = Humoment(pic2); 
fdedit1 = ['����Ҷ�����ӣ�',10];
huedit1 = [10,'Hu��������',10];
fdedit2 = ['����Ҷ�����ӣ�',10];
huedit2 = [10,'Hu��������',10];
for i = 1:7
    fdedit1 = [fdedit1,[num2str(feature1(i)),10]];
    huedit1 = [huedit1,[num2str(Hu1(i)),10]];
    fdedit2 = [fdedit2,[num2str(feature2(i)),10]];
    huedit2 = [huedit2,[num2str(Hu2(i)),10]];
end
set(handles.edit_feature,'string',strcat(fdedit1,huedit1));
Allfeature1 = [feature1,Hu1];
setappdata(gcf,'feature1',Allfeature1);
set(handles.edit_feature2,'string',strcat(fdedit2,huedit2));
Allfeature2 = [feature2,Hu2];
setappdata(gcf,'feature2',Allfeature2);

function pushbutton_result_Callback(hObject, eventdata, handles)

feature1 = getappdata(gcf,'feature1');
feature2 = getappdata(gcf,'feature2');
if (isempty(feature1)||isempty(feature2))
    msgbox('������ȡ����ͼ������ֵ��', '��ʾ');
else
    flag = exist('data.mat','file'); %�ж��ļ��Ƿ����
    if flag == 0 %�ļ�������
        msgbox('δ�ҵ�����ģ�������⣡', '��ʾ');
    else
        all = load('data.mat'); %����mat�ļ�
        names = fieldnames(all); % ��ȡmat�����б���������
        data1 = all.(names{1}); %�ѵ�һ����������before
        [row,col] = size(data1);
        results1 = zeros(row,2);
        for i = 1:row;
            results1(i,1) = ModHausdorffDist(feature1,data1(i,1:col-1));
            results1(i,2) = data1(i,col);
        end
        [row,col] = size(data1);
        results2 = zeros(row,2);
        for i = 1:row;
            results2(i,1) = ModHausdorffDist(feature2,data1(i,1:col-1));
            results2(i,2) = data1(i,col);
        end        
    end
    [m,row] = min(results1,[],1);
    result1 = results1(row(1,1),2);
    if(result1==0)
       set(handles.edit_result1,'string','ʯͷ');
    end
    if(result1==2)
       set(handles.edit_result1,'string','����');
    end
    if(result1==5)
       set(handles.edit_result1,'string','��');
    end
    data1 = [feature1,result1];
    setappdata(gcf,'data1',data1);
    [m,row] = min(results2,[],1);
    result2 = results2(row(1,1),2);
    if(result2==0)
       set(handles.edit_result2,'string','ʯͷ');
    end
    if(result2==2)
       set(handles.edit_result2,'string','����');
    end
    if(result2==5)
       set(handles.edit_result2,'string','��');
    end
    data2 = [feature2,result2];
    setappdata(gcf,'data2',data2);
        setappdata(gcf,'result1',result1);
            setappdata(gcf,'result2',result2);
end
function pushbutton_pudge(hObject, eventdata, handles)


button_cut_Callback(hObject, eventdata, handles);%f�ָ�
pushbutton_denoise_Callback(hObject, eventdata, handles);%ȥ��
 pushbutton_edge_Callback(hObject, eventdata, handles);%����
pushbutton_feature_Callback(hObject, eventdata, handles);%����Ҷ
pushbutton_result_Callback(hObject, eventdata, handles)%ʶ��
result1 = getappdata(gcf,'result1');
result2 = getappdata(gcf,'result2');
if(result1==result2)
     set(handles.edit_pudge,'string','ƽ��');
end
if(result1==0)
        if(result2==2)
            set(handles.edit_pudge,'string','���һ��ʤ');
        end
        if(result2==5)
            set(handles.edit_pudge,'string','��Ҷ���ʤ');
        end
end
if(result1==2)
        if(result2==5)
            set(handles.edit_pudge,'string','���һ��ʤ');
        end
        if(result2==0)
            set(handles.edit_pudge,'string','��Ҷ���ʤ');
        end
end
if(result1==5)
        if(result2==0)
            set(handles.edit_pudge,'string','���һ��ʤ');
        end
        if(result2==2)
            set(handles.edit_pudge,'string','��Ҷ���ʤ');
        end
end
function edit_result1_Callback(hObject, eventdata, handles)

function edit_result1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    
    


function edit_feature_Callback(hObject, eventdata, handles)

function edit_feature_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_add.
function pushbutton_add_Callback(hObject, eventdata, handles)

data = getappdata(gcf,'data');
if isempty(data)
    msgbox('���Ƚ�����ȡ����ֵ������������ʶ��������ģ��⣡', '��ʾ');
else
    flag = exist('data.mat','file'); %�ж��ļ��Ƿ����
    if flag == 0 %�ļ�������
        save data data; %����mat�ļ�
    else
        all = load('data.mat'); %����mat�ļ�
        names = fieldnames(all); % ��ȡmat�����б���������
        before = all.(names{1}); %�ѵ�һ����������before
        data = [before;data]; %׷������
        save data data; %���´洢
    end
end

function pushbutton10_Callback(hObject, eventdata, handles)


function pushbutton_pudge_Callback(hObject, eventdata, handles)



function edit_pudge_Callback(hObject, eventdata, handles)

function edit_pudge_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_result2_Callback(hObject, eventdata, handles)

function edit_result2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_feature2_Callback(hObject, eventdata, handles)


function edit_feature2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
