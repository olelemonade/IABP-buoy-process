clear all;
% 读取 CSV 文件
filename = 'D:\manu\region_data\time\2024_3h_vless1_filtered.csv';
data = readtable(filename, 'HeaderLines', 1);
unix_timestamps = data.Var1;  % 假设 Unix 时间戳在第一列
t = datetime(unix_timestamps, 'ConvertFrom', 'posixtime');
value = abs(data.Var2);

filename1 = 'D:\manu\region_data\time\beaufort_data.csv';
data1 = readtable(filename1, 'HeaderLines', 1);
unix_timestamps1 = data1.Var1;  % 假设 Unix 时间戳在第一列
t1 = datetime(unix_timestamps1, 'ConvertFrom', 'posixtime');
value1 = abs(data1.Var2);


filename2 = 'D:\manu\region_data\time\canada_data.csv';
data2 = readtable(filename2, 'HeaderLines', 1);
unix_timestamps2 = data2.Var1;  % 假设 Unix 时间戳在第一列
t2 = datetime(unix_timestamps2, 'ConvertFrom', 'posixtime','Format','dd-MMM-uuuu');
value2 = abs(data2.Var2);

filename3= 'D:\manu\region_data\time\85_data.csv';
data3 = readtable(filename3, 'HeaderLines', 1);
unix_timestamps3 = data3.Var1;  % 假设 Unix 时间戳在第一列
t3 = datetime(unix_timestamps3, 'ConvertFrom', 'posixtime');
value3 = abs(data3.Var2);



% 设置移动平均窗口大小（假设季节周期为12个月）
windowSize = 52;
% 计算趋势成分
trend = movmean(value, 52, 'Endpoints', 'fill');
ttrend =value-trend;
seasonal = zeros(size(value));
for i = 27:79
    seasonal(i:windowSize:end-27) = mean(ttrend(i:windowSize:end-27));
end
% 计算残差成分
residual = ttrend - seasonal;



% 计算趋势成分
trend1 = movmean(value1, 52, 'Endpoints', 'fill');
ttrend1 = value1-trend1;
% % 计算季节性成分
% detrended = ts.value - trend;
seasonal1 = zeros(size(value1));
for i = 27:79
    seasonal1(i:windowSize:end-27) = mean(ttrend1(i:windowSize:end-27));
end
% 计算残差成分
residual1 = ttrend1 - seasonal1;

% 计算趋势成分
trend2 = movmean(value2, 52, 'Endpoints', 'fill');
ttrend2 = value2-trend2;
% % 计算季节性成分
% detrended = ts.value - trend;
seasonal2 = zeros(size(value2));
for i = 27:79
    seasonal2(i:windowSize:end-27) = mean(ttrend2(i:windowSize:end-27));
end
% 计算残差成分
residual2 = ttrend2 - seasonal2;





% 计算趋势成分
trend3 = movmean(value3, 52, 'Endpoints', 'fill');
ttrend3 = value3-trend3;
% % 计算季节性成分
% detrended = ts.value - trend;
seasonal3 = zeros(size(value3));
for i = 27:79
    seasonal3(i:windowSize:end-27) = mean(ttrend3(i:windowSize:end-27));
end
% 计算残差成分
residual3 = ttrend3 - seasonal3;



% 绘制结果
figure;
set(gcf, 'Color', 'w'); % 将窗口底色设置为白色
subplot(3,1,1);
plot(t, value,'b-','DisplayName', 'All','MarkerSize', 10);
subplot(3,1,2);
plot(t(27:end-27), seasonal(27:end-27),'b-','DisplayName', 'All','MarkerSize', 6);
subplot(3,1,3);
plot(t, residual,'b-','DisplayName', 'All','MarkerSize', 2);
hold on;

grid on;

figure;
set(gcf, 'Color', 'w'); % 将窗口底色设置为白色
% subplot(4,1,2);
subplot(3,1,1);
plot(t1, value1,'b-','DisplayName', 'Beaufort','MarkerSize', 10);
subplot(3,1,2);
plot(t1(27:end-27), seasonal1(27:end-27),'b-','DisplayName', 'Beaufort','MarkerSize', 6);
subplot(3,1,3);
plot(t1, residual1,'b-','DisplayName', 'Beaufort','MarkerSize', 2);
hold on;

grid on;

figure;
set(gcf, 'Color', 'w'); % 将窗口底色设置为白色
subplot(3,1,1);
plot(t2, value2,'b-','DisplayName', 'chukchi','MarkerSize', 10);
subplot(3,1,2);
plot(t2(27:end-27), seasonal2(27:end-27),'b-','DisplayName', 'chukchi','MarkerSize', 6);
subplot(3,1,3);
plot(t2, residual2,'b-','DisplayName', 'chukchi','MarkerSize', 2);

grid on; 

figure;
set(gcf, 'Color', 'w'); % 将窗口底色设置为白色
subplot(3,1,1);
plot(t3, value3,'b-','DisplayName', '85','MarkerSize', 10);
subplot(3,1,2);
plot(t3(27:end-27), seasonal3(27:end-27),'b-','DisplayName', '85','MarkerSize', 6);
subplot(3,1,3);
plot(t3, residual3,'b-','DisplayName', '85','MarkerSize', 2);
grid on; 

% 将 datetime 类型转换为数字格式
tt = 1:523;
tt1 = 1:523;
tt2 = 1:523;
tt3 = 1:523;
trend = trend(27:end-26);
trend1 = trend1(27:end-26);
trend2 = trend2(27:end-26);
trend3 = trend3(27:end-26);
figure;

% 第一子图
subplot(4,1,1);
plot(t(27:end-26), trend,'b-o','DisplayName', '趋势成分(楚科奇海)','MarkerSize', 2);
hold on;

p = polyfit(tt, trend, 1); % 线性拟合
trend_fit = polyval(p, tt); % 计算拟合值

plot(t(27:end-26), trend_fit, 'b--', 'DisplayName', '趋势线','MarkerSize', 2);
xticklabels(datestr(linspace(t(1), t(end), numel(2013.5:2023.5)), 'yyyy'));
% ylim([0,1.1]);
legend;
set(legend,'Orientation','horizontal','Location','southwest',...
    'Interpreter','latex',...
    'FontSize',12);
disp(['Region4 Trend Line Coefficients: ', num2str(p)]);

% 第二子图
subplot(4,1,2);
plot(t1(27:end-26), trend1,'r-o','DisplayName', '趋势成分(波弗特海)','MarkerSize', 2);
hold on;
p1 = polyfit(tt1, trend1, 1); % 线性拟合
trend_fit1 = polyval(p1, tt1); % 计算拟合值
plot(t1(27:end-26), trend_fit1, 'r--', 'DisplayName', '趋势线','MarkerSize', 2);
xticklabels(datestr(linspace(t1(1), t1(end), numel(2013:2023)), 'yyyy'));
% ylim([0,1.1]);
legend;
set(legend,'Orientation','horizontal','Location','southwest',...
    'Interpreter','latex',...
    'FontSize',12);
disp(['Beaufort Trend Line Coefficients: ', num2str(p1)]);

% 第三子图
subplot(4,1,3);
plot(t2(27:end-26), trend2,'g-o','DisplayName', '趋势成分(加拿大海盆北部)','MarkerSize', 2);
hold on;
p2 = polyfit(tt2, trend2, 1); % 线性拟合
trend_fit2 = polyval(p2, tt2); % 计算拟合值
plot(t2(27:end-26), trend_fit2, 'g--', 'DisplayName', '趋势线','MarkerSize', 2);
xticklabels(datestr(linspace(t2(1), t2(end), numel(2013:2023)), 'yyyy'));
% ylim([0,1.1]);
legend;
set(legend,'Orientation','horizontal','Location','southwest',...
    'Interpreter','latex',...
    'FontSize',12);
disp(['Chukchi Trend Line Coefficients: ', num2str(p2)]);

% 第四子图
subplot(4,1,4);
plot(t3(27:end-26), trend3,'c-o','DisplayName', '趋势成分(85°N以北)','MarkerSize', 2);
hold on;
p3 = polyfit(tt3, trend3, 1); % 线性拟合
trend_fit3 = polyval(p3, tt3); % 计算拟合值
plot(t3(27:end-26), trend_fit3, 'c--', 'DisplayName', '趋势线','MarkerSize', 2);
xticklabels(datestr(linspace(t3(1), t3(end), numel(2013:2023)), 'yyyy'));
% ylim([0,1.1]);
legend;
set(legend,'Orientation','horizontal','Location','southwest',...
    'Interpreter','latex',...
    'FontSize',12);
disp(['Region5 Trend Line Coefficients: ', num2str(p3)]);


figure;
% % subplot(4,1,4);
plot(t(27:end-26), trend,'b-o','DisplayName', '趋势成分(楚科奇海)','MarkerSize', 2);
hold on;
plot(t1(27:end-26), trend1,'r-o','DisplayName', '趋势成分(波弗特海)','MarkerSize', 2);
hold on;
plot(t2(27:end-26), trend2,'g-o','DisplayName', '趋势成分(加拿大海盆北部)','MarkerSize', 2);
hold on;
plot(t3(27:end-26), trend3,'c-o','DisplayName', '趋势成分(85°N以北)','MarkerSize', 2);
hold on;
xticklabels(datestr(linspace(t3(1), t3(end), numel(2013:2023)), 'yyyy'));
xlabel('时间','FontSize',15);
legend;
grid on;
figure;
% % subplot(4,1,4);
plot(t(27:end-26), trend_fit, 'b--', 'DisplayName', '趋势线(楚科奇海)','MarkerSize', 10,'LineWidth',2);
hold on;
plot(t1(27:end-26), trend_fit1, 'r--', 'DisplayName', '趋势线(波弗特海)','MarkerSize', 10,'LineWidth',2);
hold on;
plot(t2(27:end-26), trend_fit2, 'g--', 'DisplayName', '趋势线(加拿大海盆北部)','MarkerSize', 10,'LineWidth',2);
hold on;
plot(t3(27:end-26), trend_fit3, 'c--', 'DisplayName', '趋势线(85°N以北)','MarkerSize', 10,'LineWidth',2);
hold on;
xticklabels(datestr(linspace(t3(1), t3(end), numel(2013:2023)), 'yyyy'));
xlabel('时间','FontSize',15);
legend;
grid on;
% subplot(5,1,4);
% plot(ts.dates_datetime, residual);
% title('Residual Component');
% grid on;
% subplot(5,1,5);
% plot(ts.dates_datetime, detrended);
% title('detrended Component');
% grid on;