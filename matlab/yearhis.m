data = readtable('E:\timespan.csv'); % 假设文件名为 data.csv
live = readmatrix('E:\live.csv');
start_years = data.Start_year;
% indices = start_years>=2002;
start_unique_years = unique(start_years);
end_years = live(:,2);
end_unique_years =  live(:,1);;
counts1 = histc(start_years, start_unique_years);

figure;
subplot(2,1,1);
bar(start_unique_years, counts1);

% 添加标题和轴标签
title('投放');
xlabel('年份');
ylabel('次数');

% 显示网格线
grid on;
subplot(2,1,2);
bar(end_unique_years, end_years);

% 添加标题和轴标签
title('存活');
xlabel('年份');
ylabel('次数');

% 显示网格线
grid on;