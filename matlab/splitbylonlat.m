clear all;
% 读取文本文件
data = readmatrix('E:\vecolityofbuoys\vecl_2025\new.txt');
lon = data(:,4);
lat = data(:,5);
year= data(:,2);
doy = data(:,3);
v = data(:,11);
acc = data(:,20);
% sic = data(:,15);
% pra = data(:,17);
% meanall= mean(data(:,17));

% Region1 波弗特海
%        75°N~80°N
%      120°W~155°W
% Region2 楚科奇海
%        75°N~80°N
%        155°W~180°
% Region3 东西伯利亚海
%        75°N~85°N
%        150°E~180°
% Region4（北加拿大海盆）
%        80°N~85°N
%        110°E~180°
% Region5（85°N以北）
%        85°N~90°N
% Region6 弗拉姆海峡
%        77°N~85°N
%        11°W~11°E




% 使用逻辑索引找到符合条件的行
% indices = (lon<60&lon>=-30) & lat >= 65;
% indices = (lon>60&lon<=150) & lat >= 65;
% indices = lon>-180 &lon<-110 & lat>80 &lat <85;
% indices = lon>-180 &lon<-132 & lat>73 &lat <83;
% indices = lon>11 &lon<60& lat>70 &lat<85;
% indices = abs(lon)<=20 & lat >= 75 & lat<=82;
% indices = pra>=0.005;
% indices = lon <= -155 & lon >= -180 & lat >= 70 & lat<=80;
indices = lon <= -120 & lon >= -155 & lat >= 70 & lat<=80 & v<=1& acc<=1;
% indices = lat >= 85;
% indices =  182 <= doy & doy<= 273;
% indices =  182 > doy | doy> 273;
% indices = lon <= 10 & lon >= -20 & lat >= 75 & lat<=85;
% indices = (lon<-30&lon>-120) & lat >= 65;
% 提取符合条件的数据
result = data(indices, :);
% 保存结果为逗号分隔的文本文件
outputFile = 'E:\vecolityofbuoys\vecl_2025\region\new_beaufort.txt';
writematrix(result, outputFile, 'Delimiter', ',');

% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);