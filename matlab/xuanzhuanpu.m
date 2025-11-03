% 设置文件夹路径
folderPath = 'D:\debug';  % 替换为实际路径
filePattern = fullfile(folderPath, '*.dat');
dataFiles = dir(filePattern);

% 初始化存储所有速度分量的数组
all_u = [];
all_v = [];

% 读取所有文件中的数据
for k = 1:length(dataFiles)
    baseFileName = dataFiles(k).name;
    fullFileName = fullfile(folderPath, baseFileName);
    fprintf('Now reading %s\n', fullFileName);
    
    % 读取文件中的数据 (假设数据格式为两列，分别为u和v)
    data = load(fullFileName);
    u = data(:, 11);
    v = data(:, 12);
    
    % 将数据追加到总数组中
    all_u = [all_u; u];
    all_v = [all_v; v];
end

% 采样频率 (假设每秒采样一次)
fs = 1;

% 复数形式的速度矢量
z = all_u + 1i * all_v;

% 计算傅里叶变换
Z = fft(z);

% 计算频率
N = length(z);
f = (0:N-1)*(fs/N);

% 分离顺时针和逆时针分量
Z_cw = 0.5 * (Z + conj(flip(Z)));
Z_ccw = 0.5 * (Z - conj(flip(Z)));

% 计算功率谱密度
P_cw = abs(Z_cw).^2 / N;
P_ccw = abs(Z_ccw).^2 / N;

% 只取前半部分频谱（正频率部分）
f_half = f(1:floor(N/2));
P_cw_half = P_cw(1:floor(N/2));
P_ccw_half = P_ccw(1:floor(N/2));

% 绘制旋转功率谱
figure;
subplot(2, 1, 1);
plot(f_half, P_cw_half);
title('Clockwise Rotating Spectrum');
xlabel('Frequency (Hz)');
ylabel('Power');

subplot(2, 1, 2);
plot(f_half, P_ccw_half);
title('Counterclockwise Rotating Spectrum');
xlabel('Frequency (Hz)');
ylabel('Power');
