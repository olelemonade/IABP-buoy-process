clear all;
% 读取文本文件
data = readmatrix('E:\Major revision\3h_vless3_aless12.txt');


% lat = data(:,5);
% v = data(:,11);
% a = data(:,19);
% indices8 = v<=3 & a<=12 &lat>=66.5;
% data = data(indices8, :);
% writematrix(data, "E:\Major revision\3h_vless3_aless12.txt", 'Delimiter', ',');
% acc = data(:,20);
% sic = data(:,15);
% pra = data(:,17);
% meanall= mean(data(:,17));
% Region2 楚科奇海
%        75°N~80°N
%        155°W~180°
% Region6 弗拉姆海峡
%        77°N~85°N
%        11°W~11°E
lon = data(:,4);
lat = data(:,5);
year= data(:,2);
doy = data(:,3);
%% 

indices8 = lon<=60&lon>=16 & lat >= 66.5 & lat<=85;
result = data(indices8, :);
% indice_summer =  182 <= doy & doy<= 273;
% indice_winter =  182 > doy | doy> 273;
outputFile = 'E:\Major revision\barents.txt';
writematrix(result, outputFile, 'Delimiter', ',');

% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);
%% 

indices7 =  lat>=85|(lon>=150|lon<-110 & lat<85&lon>80);
result = data(indices7, :);
% indice_summer =  182 <= doy & doy<= 273;
% indice_winter =  182 > doy | doy> 273;
outputFile = 'E:\Major revision\central arctic.txt';
writematrix(result, outputFile, 'Delimiter', ',');




% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);
%% 

indices7 = lon<=-22&lon>=-110 & lat >= 80 & lat<=85;
result = data(indices7, :);
% indice_summer =  182 <= doy & doy<= 273;
% indice_winter =  182 > doy | doy> 273;
outputFile = 'E:\Major revision\CANADAISLAND.txt';
writematrix(result, outputFile, 'Delimiter', ',');



% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);
%% 
indices6 = lon<=16& lon>=-22& lat >= 77 & lat<=85;
result = data(indices6, :);
% indice_summer =  182 <= doy & doy<= 273;
% indice_winter =  182 > doy | doy> 273;
outputFile = 'E:\Major revision\fram.txt';
writematrix(result, outputFile, 'Delimiter', ',');



% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);
%% 

indices2 = lon>-180 & (lon<-155|lon>170) & lat>66.5 &lat <80;
result = data(indices2, :);
% indice_summer =  182 <= doy & doy<= 273;
% indice_winter =  182 > doy | doy> 273;
outputFile = 'E:\Major revision\Chukchi.txt';
writematrix(result, outputFile, 'Delimiter', ',');




% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);
% Region1 波弗特海
%        75°N~80°N
%      120°W~155°W
indices1 = lon>-155 & lon<-120 & lat>66.5 &lat <80;
result = data(indices1, :);
% indice_summer =  182 <= doy & doy<= 273;
% indice_winter =  182 > doy | doy> 273;
outputFile = 'E:\Major revision\Beaufort.txt';
writematrix(result, outputFile, 'Delimiter', ',');



% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);

% Region3 东西伯利亚海
%        75°N~85°N
%        150°E~180°
indices3 = lon<170 & lon>150 & lat>66.5 &lat <80;
result = data(indices3, :);
% indice_summer =  182 <= doy & doy<= 273;
% indice_winter =  182 > doy | doy> 273;
outputFile = 'E:\Major revision\ES.txt';
writematrix(result, outputFile, 'Delimiter', ',');


% 显示保存路径
disp(['Filtered data saved to: ', outputFile]);












% 使用逻辑索引找到符合条件的行
% indices = (lon<60&lon>=-30) & lat >= 65;
% indices = (lon>60&lon<=150) & lat >= 65;
% indices = lon>-180 &lon<-110 & lat>80 &lat <85;
% indices = lon>-180 &lon<-132 & lat>73 &lat <83;
% indices = lon>11 &lon<60& lat>70 &lat<85;
% indices = abs(lon)<=20 & lat >= 75 & lat<=82;
% indices = pra>=0.005;
% indices = lon <= -155 & lon >= -180 & lat >= 70 & lat<=80;
% indices = lon <= -120 & lon >= -155 & lat >= 70 & lat<=80 & v<=1& acc<=1;

% Region1 波弗特海
% indices = lat >= 85;

% indices = lon <= 10 & lon >= -20 & lat >= 75 & lat<=85;
% indices = (lon<-30&lon>-120) & lat >= 65;
% 提取符合条件的数据
