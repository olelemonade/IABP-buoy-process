% 读取文本文件
data = readmatrix('E:\vecolityofbuoys\segmentation\vecolity0618.dat');
% 提取指定列（假设你想要提取第2列和第4列）
distance = (data(:,7));
v = data(:,8);
dim = size(distance);


startValue = 0;
endValue = 200;
nElements = 200;
edges = linspace(startValue, endValue, nElements);







% 
% subplot(2, 1, 1); % 2行1列的网格，选择第一个位置
histObj=histogram(v,edges,'Normalization', 'probability');
title('偏移量直方图');
xlabel('值');
ylabel('频率');
xlim([0 6000])
freqCounts = histObj.Values;
% plot(stability, 'g', 'DisplayName', 'Original Data');
% hold on;
% subplot(2, 1, 2); % 2行1列的网格，选择第二个位置
% plot(date, stability, '.', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', 'MarkerSize', 5);
% title('偏移量按年分布');
% xlabel('年份');
% ylabel('偏移量');
% xlim([2002 2024])
% ylim([0 50000]);
hold on;