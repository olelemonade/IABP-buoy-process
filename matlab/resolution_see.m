% 设置文件夹路径
folderPath = 'D:\resoluition_see\5315\vecolity';  % 替换为实际路径
filePattern = fullfile(folderPath, '*.dat');
dataFiles = dir(filePattern);

date = [];
pra = [];
ss = [];
% 读取所有文件中的数据
count = 0;
figure;
startValue = 0;
endValue = 10;
nElements = 1000;
edges = linspace(startValue, endValue, nElements);
for k = 1:length(dataFiles)
    count = count+1;
    baseFileName = dataFiles(k).name;
    fullFileName = fullfile(folderPath, baseFileName);
    fprintf('Now reading %s\n', fullFileName);
    
    % 读取文件中的数据 (假设数据格式为两列，分别为u和v)
    data = load(fullFileName);
    year = data(:, 2);
    doy  = data(:, 3);
    % pra1 = data(:,15);
    time = data(:,14);
    time_men = mean(time);
    subplot(4, 1, count);
    % date1 = year+doy/365;
    % plot(date1, time,'b.','MarkerSize', 2);
    histObj=histogram(time,edges,'Normalization', 'probability');
    title('相邻点时间差直方图');
    xlabel('值');
    ylabel('频率');
    xlim([0,10]);
    freqCounts = histObj.Values;
    grid on;
    % dim = size(year);
    % siz = 1:dim(1);
    % ss(count,1) = dim(1);
    % ss(count,2) = mean(pra1);
    % date(siz,count) = date1;
    % pra(siz,count) = pra1;
    % 将数据追加到总数组中
end
% subplot(5, 1, count);
% plot(date(1:3415,1), pra(1:3415,1),'b-',date(1:4059,4), pra(1:4059,4),'r-','MarkerSize', 2);
% grid on;