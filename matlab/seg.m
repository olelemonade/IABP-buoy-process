% 读取文本文件
data = readmatrix('E:\vecolityofbuoys\vecl_2025\vel\coor3h_processed.txt');
% 提取指定列（假设你想要提取第2列和第4列）
v = data(:,11);

start_time = data(:,2);
end_time = data(:,3);
time_end = (data(:,5));


startValue = 1;
endValue = 10000;
nElements = 1000;
edges = linspace(startValue, endValue, nElements);


start_year = floor(start_time/10000);
indices = start_year>=2012 & start_year<=2023& lat >65;
data = data(indices,:);
stability = data(:,10);

time_tart = (data(:,4));
start_month = floor(mod(start_time,10000)/100);
start_day = mod(mod(start_time,10000),100);
wwww = ceil(time_tart/(7*24*60*60));
% high_four_bits = high_four_bits+((month-1)*30+day)/365;
y= 2012:2023;
mon = 1:12;
meandata={};
WW = min(wwww):max(wwww);
row=0;
for ww=WW
    row=row+1;
    indices = wwww==ww & stability<10;
    data1 = data(indices,:)
    meandata{row,1} = ww*(7*24*60*60);
    if isnan(mean(data1(:,10)))
        meandata{row,2} = (meandata{row-1,2}+meandata{row-2,2})/2;
    else
        meandata{row,2} = mean(data1(:,10));
    end

    
end

% 在第一行插入标题行
meandata(1, :) = {'Date', 'Value'};

% 将cell数组转换为表格
dataTable = cell2table(meandata(2:end, :), 'VariableNames', meandata(1, :));

% 保存表格为CSV文件
writetable(dataTable, 'E:\vecolityofbuoys\segmentation\timeseries\distance3h_noland.csv');
% for yy = y   
%     for mm=mon
%         for ww = 
%         row = row+1;
%         indices = start_year==yy & start_month == mm & stability <= 5000;
%         data1 = data(indices,:)
%         meandata{row,1} = yy*100+mm;
%         meandata{row,2} = mean(data1(:,9));
%     end
% end


% date = high_four_bits(indices,:);
% data2 = data(indices,:);
% 
% stability1 = data2(:,9);
% 
% m = mean(stability);
% 
% subplot(2, 1, 1); % 2行1列的网格，选择第一个位置
% histObj=histogram(stability1,edges,'Normalization', 'probability');
% title('偏移量直方图');
% xlabel('值');
% ylabel('频率');
% xlim([0 5000])
% freqCounts = histObj.Values;
% % plot(stability, 'g', 'DisplayName', 'Original Data');
% % hold on;
% subplot(2, 1, 2); % 2行1列的网格，选择第二个位置
% plot(date, stability1, '.', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', 'MarkerSize', 5);
% title('偏移量按年分布');
% xlabel('年份');
% ylabel('偏移量');
% xlim([2002 2024])
% ylim([0 10000]);
% hold on;