clear all;
% 读取文本文件
data = readmatrix('D:\resoluition_see\3h\coor_direction3h_sic_65.txt');
% lon = data(:,4);
% lat = data(:,5);
year = data(:,2);
% sic = data(:,15);
% v1 = data(:,11);
% startValue = 0;
% endValue = 10;
% nElements = 1000;
% edges = linspace(startValue, endValue, nElements);
% [counts, binEdges] = histcounts(v1, edges);
% binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2;
% 
% figure
% plot(binCenters, counts, '-', 'LineWidth', 2, 'MarkerSize', 6);
% title('速度直方图');
% xlabel('值');
% ylabel('百分比');
% xlim([0,10]);
% grid on;
% % max_v = max(v);
% % min_v = min(v);
interval = 0.0001;
meandata={};
count = 0
for year1 = 2013:2023
    count = count+1;
    count1 =0;
    indices1 = year==year1;
    data1 = data(indices1,:);
    v = data1(:,17);
    for x = 0:interval:0.0083
        count1 = count1+1;
        indices2 = v>=x& v<x+0.0001;
        pra = mean(data1(indices2,15));
        meandata{count1,count} = pra;
    end
end








% 将cell数组转换为表格
dataTable = cell2table(meandata(1:end, :));

% 保存表格为CSV文件
writetable(dataTable, 'D:\resoluition_see\3h\sicwithpra.csv');
