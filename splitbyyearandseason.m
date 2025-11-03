clear all;
% 读取文本文件
data = readmatrix('E:\Major revision\spatialdivided\3h_vless3_aless12.txt');
% lon = data(:,4);
% lat = data(:,5);
year= data(:,2);
% v = data(:,11);
% for y = 2013:2024
%     indices = year == y;
%     result = data(indices, :);
% 
%     % 修正字符串拼接方式
%     outputFile = fullfile('E:\Major revision\spatialdivided\year\barents\', [num2str(y), '.txt']);  % 使用 fullfile 生成路径:ml-citation{ref="5,7" data="citationList"}
% 
% 
%     % 保存文件
%     writematrix(result, outputFile, 'Delimiter', ',');
% 
%     disp(['已保存至: ', outputFile]);
% end
% acc = data(:,20);
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
%        110°W~180°
% Region5（85°N以北）
%        85°N~90°N
% Region6 弗拉姆海峡
%        77°N~85°N
%        11°W~11°E
    % doy = data(:, 3);
    % indice_summer = doy >= 152 & doy <= 303;
    % indice_winter = doy < 152 | doy > 303;
    % % 
    % summer = data(indice_summer, :);
    % winter = data(indice_winter, :);
    % % 
    % writematrix(summer, "E:\Major revision\season\allseason\fram_summer.txt", 'Delimiter', ',');
    % writematrix(winter, "E:\Major revision\season\allseason\fram_winter.txt", 'Delimiter', ',');





% for y = 2013:2024
%     indices = year == y|year == y+1;
%     result = data(indices, :);
% 
%     doy = result(:, 3);
%     yy = result(:, 2);
%     % indice_summer = (yy == y)&(doy >= 182) & (doy <= 273);
%     % indice_winter = (yy == y+1&doy < 182) | (yy == y&doy > 273);
%     indice_summer = (yy == y)&(doy >= 213) & (doy <= 273);
%     indice_winter = (yy == y&doy < 181) | (yy == y&doy > 60);
%     summer = result(indice_summer, :);
%     winter = result(indice_winter, :);
% 
%     % 修正字符串拼接方式
%     outputFile_summer = fullfile('E:\Major revision\season\ES\', [num2str(y), '_summer.txt']);  % 使用 fullfile 生成路径:ml-citation{ref="5,7" data="citationList"}
%     outputFile_winter = fullfile('E:\Major revision\season\ES\', [num2str(y), '_winter.txt']);
% 
%     % 保存文件0
%     writematrix(summer, outputFile_summer, 'Delimiter', ',');
%     writematrix(winter, outputFile_winter, 'Delimiter', ',');
% 
%     disp(['夏季数据已保存至: ', outputFile_summer]);
%     disp(['冬季数据已保存至: ', outputFile_winter]);
% end
for y = 2013:2024
    indices = year == y;
    result = data(indices, :);

    % doy = result(:, 3);
    % yy = result(:, 2);
    % % indice_summer = (yy == y)&(doy >= 182) & (doy <= 273);
    % % indice_winter = (yy == y+1&doy < 182) | (yy == y&doy > 273);
    % indice_summer = (yy == y)&(doy >= 213) & (doy <= 273);
    % indice_winter = (yy == y&doy < 181) | (yy == y&doy > 60);
    % summer = result(indice_summer, :);
    % winter = result(indice_winter, :);

    % 修正字符串拼接方式
    outputFile_summer = fullfile('E:\Major revision\year\', [num2str(y), '.txt']);  % 使用 fullfile 生成路径:ml-citation{ref="5,7" data="citationList"}


    % 保存文件0
    writematrix(result, outputFile_summer, 'Delimiter', ',');


    disp(['数据已保存至: ', outputFile_summer]);
end
% indices = (lon<60&lon>=-30) & lat >= 65;
