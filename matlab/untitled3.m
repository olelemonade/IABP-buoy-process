% 生成示例数据
data = randn( 1,100); % 生成一个100个随机数的向量

% 计算自相关函数
acf = autocorr(data);

% 绘制自相关函数
autocorr(data);
