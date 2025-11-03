% 读取 CSV 文件
filename = 'E:\vecolityofbuoys\segmentation\timeseries\direction3h_noland.csv';
% 读取 CSV 文件并跳过首行
data = readmatrix(filename,'HeaderLines', 1);
pra = data(:,2);
sic = data(:,3);
v = data(:,4);
% 计算Spearman相关系数
%R_spearman = corr(B', y1', 'Type', 'Spearman');
R1 = corrcoef(pra, v);

correlation_coefficient = R1(1, 2);