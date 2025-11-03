

% 读取文本文件
data = readmatrix('D:\resoluition_see\direction3h2002-2012_025pra.csv');
% data1 = readmatrix('D:\resoluition_see\coor_direction6h_sic_60_winter.txt');
% 提取指定列（假设你想要提取第2列和第4列）
% distance = (data(:,7));
% all_distance = data(:,8);
% dim = size(distance);
% start_time = data(:,4)/(24*60*60*365);
% time = (data(:,2));
year = data(:,2);
doy = data(:,3);
date = year+doy/365;
stability = data(:,15);
% stability1 = data1(:,17);
time=data(:,14);


startValue = 2002;
endValue = 2012;
nElements = 1000;
edges = linspace(startValue, endValue, nElements);
[counts, binEdges] = histcounts(date, edges);
binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2;
% high_four_bits = floor(time/10000);
% month = floor(mod(time,10000)/100);
% day = mod(mod(time,10000),100);

% indices = stability<=10000;
% 
% date = high_four_bits(indices,:);
% data2 = data(indices,:);
% 
% stability1 = data2(:,10);
% 
% m = mean(stability);
figure
% plot(binCenters, counts, '-', 'LineWidth', 2, 'MarkerSize', 6);
histObj2=histogram(date,edges);
histObj2.FaceColor = [0 0 1]; % 红色
histObj2.EdgeColor = backgroundColor; % 
xlabel('值');
ylabel('百分比');
xlim([2012,2024]);
grid on;
freqCounts = histObj.Values;
% plot(stability, 'g', 'DisplayName', 'Original Data');
% hold on;
% subplot(2, 1, 2); % 2行1列的网格，选择第二个位置
% plot(high_four_bits, stability, '.', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', 'MarkerSize', 5);
% title('偏移量按年分布');
% xlabel('年份');
% ylabel('偏移量');
% xlim([2012 2024])
% ylim([0 10]);
% hold on;