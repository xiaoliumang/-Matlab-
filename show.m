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

%1.Get the hardware information //获取硬件信息
global obj;%obj在其他地方要调用，所以设为全局变量
info=imaqhwinfo('winvideo');%获得摄像头硬件信息
obj=videoinput('winvideo',info.DeviceIDs{1});%创建视频对象
set(obj,'FramesPerTrigger',1);%每次触发存储一张相片
set(obj,'ReturnedColorSpace','RGB');%接收图像为RGB模式

%get(obj)%获取obj信息，查看设置是否成功，最后注释掉
axes(handles.axes1);

%2.show the video //动态显示视频图像
Resolution=get(obj,'videoResolution');%分辨率
nBands=get(obj,'NumberOfBands');%频段
hImage=image(zeros(Resolution(2),Resolution(1),nBands));
preview(obj,hImage);%在特定的位置（hImage）显示

function button_catch_Callback(hObject, eventdata, handles)

global obj;
catch_pic=getsnapshot(obj);%摄取图像
catch_pic=imresize(catch_pic,[240, 320]);  %统一图片大小
axes(handles.axes2);
imshow(catch_pic);%在axes2显示摄取的图片
setappdata(gcf,'pic',catch_pic);%把catch_pic变成全局变量

function button_cut_Callback(hObject, eventdata, handles)
pic1 = getappdata(gcf,'pic1'); %获取全局变量
pic2 = getappdata(gcf,'pic2'); 
l = get(handles.popupmenu_choose,'value'); %获取下拉菜单选中项
if l==2  %基于阈值分割（尤其适用于纯背景）
    graypic = rgb2gray(pic1); %灰度图像
    pic_filt=medfilt2(graypic,[3 3]); %3*3中值滤波
    axes(handles.axes3);imshow(pic_filt);
    pic_cut1 = threshold_cut(pic_filt);
    
    graypic = rgb2gray(pic2); %灰度图像
    pic_filt=medfilt2(graypic,[3 3]); %3*3中值滤波
    axes(handles.axes8);imshow(pic_filt);
    pic_cut2 = threshold_cut(pic_filt);
end
if l==1  %基于YCgCr肤色分割（适用于较复杂背景）
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
pic1=imread([pathname,filename]);%读取图片给im
pic1=imresize(pic1,[240, 320]);  %统一图片大小
axes(handles.axes2);
imshow(pic1);%在axes2显示摄取的图片
setappdata(gcf,'pic1',pic1);%把pic变成全局变量

function pushbutton_open_Callback2(hObject, eventdata, handles)

[filename, pathname] = uigetfile( ...
{'*.bmp;*.jpg;*.fig;*.tif','MATLAB Files (*.bmp;*.jpg;*.fig;*.tif)';
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');
pic2=imread([pathname,filename]);%读取图片给im
pic2=imresize(pic2,[240, 320]);  %统一图片大小
axes(handles.axes7);
imshow(pic2);%在axes2显示摄取的图片
setappdata(gcf,'pic2',pic2);%把pic变成全局变量

function pushbutton_denoise_Callback(hObject, eventdata, handles)
pic_cut1 = getappdata(gcf,'pic_cut1'); %获取全局变量
pic_cut2 = getappdata(gcf,'pic_cut2'); %获取全局变量
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

%轮廓图像
pic1 = getappdata(gcf,'pic_denoise1'); %获取全局变量
pic2 = getappdata(gcf,'pic_denoise2');
l = get(handles.popupmenu_operator,'value'); %获取下拉菜单选中项
if l == 5  %Sobel算子
    pic_edge1 = edge(pic1,'sobel');
    pic_edge2 = edge(pic2,'sobel');    
end
if l == 2 %Prewitt算子
    pic_edge1 = edge(pic1,'prewitt');
    pic_edge2 = edge(pic2,'prewitt');
end
if l == 3 %Roberts算子
    pic_edge1 = edge(pic1,'roberts');
    pic_edge2 = edge(pic2,'roberts');
end
if l == 4 %log算子
    pic_edge1 = edge(pic1,'log');
    pic_edge2 = edge(pic2,'log');    
end
if l == 1 %Canny算子
    se=fspecial('gaussian',5); %高斯滤波
    pic1=imfilter(pic1,se);
    pic_edge1 = edge(pic1,'canny');
    pic2=imfilter(pic2,se);
    pic_edge2 = edge(pic2,'canny');
end
[r c]=find(pic_edge1==1);  
% 'a'是按面积算的最小矩形，如果按边长用'p'  
[rectx,recty,area,perimeter] = minboundrect(c,r,'p');   
axes(handles.axes5);
imshow(pic_edge1);
hold on  
line(rectx,recty); 
[r c]=find(pic_edge2==1);  
% 'a'是按面积算的最小矩形，如果按边长用'p'  
[rectx,recty,area,perimeter] = minboundrect(c,r,'p');   
axes(handles.axes11);
imshow(pic_edge2);
hold on  
line(rectx,recty); 
setappdata(gcf,'pic_edge1',pic_edge1);%把pic_edge变成全局变量
setappdata(gcf,'pic_edge2',pic_edge2);
function pushbutton_feature_Callback(hObject, eventdata, handles)

pic1 = getappdata(gcf,'pic_edge1'); %获取全局变量
pic2 = getappdata(gcf,'pic_edge2');
feature1=fourierdescriptors(pic1); %对轮廓图提取傅里叶描述子2-8共7个系数
feature2=fourierdescriptors(pic2);
Hu1 = Humoment(pic1); %对轮廓图像提取Hu矩特征
Hu2 = Humoment(pic2); 
fdedit1 = ['傅里叶描述子：',10];
huedit1 = [10,'Hu矩特征：',10];
fdedit2 = ['傅里叶描述子：',10];
huedit2 = [10,'Hu矩特征：',10];
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
    msgbox('请先提取手势图像特征值！', '提示');
else
    flag = exist('data.mat','file'); %判断文件是否存在
    if flag == 0 %文件不存在
        msgbox('未找到手势模板特征库！', '提示');
    else
        all = load('data.mat'); %加载mat文件
        names = fieldnames(all); % 获取mat中所有变量的名字
        data1 = all.(names{1}); %把第一个变量赋给before
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
       set(handles.edit_result1,'string','石头');
    end
    if(result1==2)
       set(handles.edit_result1,'string','剪刀');
    end
    if(result1==5)
       set(handles.edit_result1,'string','布');
    end
    data1 = [feature1,result1];
    setappdata(gcf,'data1',data1);
    [m,row] = min(results2,[],1);
    result2 = results2(row(1,1),2);
    if(result2==0)
       set(handles.edit_result2,'string','石头');
    end
    if(result2==2)
       set(handles.edit_result2,'string','剪刀');
    end
    if(result2==5)
       set(handles.edit_result2,'string','布');
    end
    data2 = [feature2,result2];
    setappdata(gcf,'data2',data2);
        setappdata(gcf,'result1',result1);
            setappdata(gcf,'result2',result2);
end
function pushbutton_pudge(hObject, eventdata, handles)


button_cut_Callback(hObject, eventdata, handles);%f分割
pushbutton_denoise_Callback(hObject, eventdata, handles);%去噪
 pushbutton_edge_Callback(hObject, eventdata, handles);%轮廓
pushbutton_feature_Callback(hObject, eventdata, handles);%傅里叶
pushbutton_result_Callback(hObject, eventdata, handles)%识别
result1 = getappdata(gcf,'result1');
result2 = getappdata(gcf,'result2');
if(result1==result2)
     set(handles.edit_pudge,'string','平局');
end
if(result1==0)
        if(result2==2)
            set(handles.edit_pudge,'string','玩家一获胜');
        end
        if(result2==5)
            set(handles.edit_pudge,'string','玩家二获胜');
        end
end
if(result1==2)
        if(result2==5)
            set(handles.edit_pudge,'string','玩家一获胜');
        end
        if(result2==0)
            set(handles.edit_pudge,'string','玩家二获胜');
        end
end
if(result1==5)
        if(result2==0)
            set(handles.edit_pudge,'string','玩家一获胜');
        end
        if(result2==2)
            set(handles.edit_pudge,'string','玩家二获胜');
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
    msgbox('请先进行提取特征值，并进行手势识别后，再添加模板库！', '提示');
else
    flag = exist('data.mat','file'); %判断文件是否存在
    if flag == 0 %文件不存在
        save data data; %保存mat文件
    else
        all = load('data.mat'); %加载mat文件
        names = fieldnames(all); % 获取mat中所有变量的名字
        before = all.(names{1}); %把第一个变量赋给before
        data = [before;data]; %追加数据
        save data data; %重新存储
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
