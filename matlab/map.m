% 读取文本文件
data = readmatrix('D:\manu\2013_2024_3h.txt');

% 提取指定列（假设你想要提取第3列、2列和11列）
doy = data(:, 3);
month = floor(doy/30);
year = data(:, 2);
pra = data(:, 17);
lon1 = data(:, 4);

% 创建 figure，并设置其大小
fig = figure;
set(fig, 'Position', [100, 100, 1500, 1000]); % [left, bottom, width, height]

% 为了放置全局的颜色条，需要确定合适的subplot布局
num_plots = numel(unique(year));
num_rows = ceil(num_plots / 4); % 每行最多4个子图
subplot_index = 1; % 记录当前子图的位置

% 初始化颜色条范围
min_pra = min(pra, [], 'omitnan');
max_pra = max(pra, [], 'omitnan');

for y = 2013:2024
    subplot(num_rows, 4, subplot_index); % 根据需要调整subplot的位置和数量

    % 设置北极投影
    axesm('MapProjection', 'stereo', 'Origin', [90 0], 'Frame', 'on', 'Grid', 'on');

    % 设置地图范围，只显示纬度大于60度的区域
    setm(gca, 'FLatLimit', [60 90], 'MapLatLimit', [60 90], 'MapLonLimit', [-180 180]);

    % 隐藏轴
    axis off;

    % 加载并绘制海岸线数据
    load coastlines;
    geoshow(coastlat, coastlon, 'DisplayType', 'polygon', 'FaceColor', [0.5 0.7 0.5]);

    % 添加经纬线
    mlabel on; % 标注经度
    plabel on; % 标注纬度
    % 设置经纬度标注的位置和样式
    setm(gca, 'MLabelLocation', 90, 'PLabelLocation', 30, 'MLabelParallel', 'south');
    % 绘制数据点
    % 假设data的第4列是纬度，第5列是经度
    indices = year == y & ~isnan(lon1);
    lat = data(indices, 5);
    lon = data(indices, 4);
    pra_value = pra(indices);

    % 检查并添加 NaN 分隔符
    lat(isnan(lat)) = [];
    lon(isnan(lon)) = [];
    pra_value(isnan(lat)) = [];

    % 根据 pra 值分级设色
    scatterm(lat, lon, 2,"blue", '.');
    colormap(parula); % 使用 jet 颜色映射

    % 设置颜色条范围
    clim([min_pra, max_pra]);

    % 为每个子图添加标题
    title(['年份：', num2str(y)]);

    % 调整图以适应窗口
    tightmap;

    subplot_index = subplot_index + 1;
end

% 在整个 figure 底部添加全局的颜色条
% h = colorbar('southoutside');
% set(h, 'Position', [0.1 0.05 0.8 0.03]); % 调整颜色条的位置和大小
% set(get(h,'Label'),'string','PRA Value'); % 添加颜色条的标签，说明颜色条的含义

% 设置整个 figure 的标题
set(gcf, 'Name', 'PRA Data Distribution');
