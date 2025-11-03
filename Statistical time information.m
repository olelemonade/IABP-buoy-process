clear all;
% Step 1: 读取数据
filename = 'E:\Major revision\spatialdivided\CANADAISLAND.txt';
data = readmatrix(filename);

% Step 2: 处理数据
% 提取年和doy列
years = data(:, 2);
doys = floor(data(:, 3));

% 将doy转换为日期
start_date = datetime(years, 1, 1);
dates = start_date + days(doys - 1);

% 统计每天的数据数量
[unique_dates, ~, idx] = unique(dates);
daily_counts = accumarray(idx, 1);

% Step 3: 绘制图像
figure; 
bar(unique_dates, daily_counts,'blue');
datetick('x', 'yyyy-mm');
title("Fram Sea",'FontSize',18)
xlabel('Time','FontSize',18);
ylabel('Count','FontSize',18);

ylim([0,800]);
grid on;
