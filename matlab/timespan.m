% 设置文件夹路径
folderPath = 'D:\buoy_2025';  % 替换为实际路径
filePattern = fullfile(folderPath, '*.dat');
dataFiles = dir(filePattern);

timespan1 = {};
end_year = {};
count = 0;
live = [];
live(1:2025-1979+1,1) = 1979:2025;
live(:,2) = 0;
% 读取所有文件中的数据
for k = 1:length(dataFiles)
    
    baseFileName = dataFiles(k).name;
    fullFileName = fullfile(folderPath, baseFileName);
    fprintf('Now reading %s\n', fullFileName);
    
    % 读取文件中的数据 (假设数据格式为两列，分别为u和v)
    data = readtable(fullFileName);
    id  = data.BuoyID;
    year = data.Year;
    doy  = data.POS_DOY;
    lat = data.Lat;
    dim = size(year);
    siz = dim(1);
    if year(1)<=2025 & year(siz)<=2025 &year(1)>=1979  &year(siz)>=1979 & lat(1)>=60
        count = count+1;
        timespan1{count,5} = id(1);
        timespan1{count,1} = year(1);
        timespan1{count,2} = doy(1);
        timespan1{count,3} = year(siz);
        timespan1{count,4} = doy(siz);
        for yy = timespan1{count,1}:timespan1{count,3}
            live(yy-1978,2) = live(yy-1978,2)+1;
        end
    end


end
timespan1(1, :) = {'Start_year', 'Start_doy','end_year','end_doy','ID'};
% 将cell数组转换为表格
dataTable = cell2table(timespan1(2:end, :), 'VariableNames', timespan1(1, :));
% 保存表格为CSV文件
writetable(dataTable, 'E:\timespan.csv');
writematrix( live,'filename.csv');
