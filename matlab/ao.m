% Step 1: Read the data from the CSV file
filename = 'E:\vecolityofbuoys\segmentation\timeseries\ao.csv'; % Replace with your actual file path
data = readtable(filename);
% Display the data to ensure it is loaded correctly
disp(data);

% Step 2: Convert the dates to datetime format
dates = datetime(data{:,1}, 'InputFormat', 'yyyy/MM/dd');

% Extract the values
values = data{:,2};

% Step 3: Plot the original data
figure;
plot(dates, values, '-o');
title('Time Series Data');
xlabel('Date');
ylabel('Value');
grid on;

% Step 4: Perform seasonal decomposition using STL (requires Econometrics Toolbox)
decomposition =seasonal_decompose(values, 'Model', 'multiplicative', 'Period', 12);

% Extract the components
trend = decomposition.Trend;
seasonal = decomposition.Seasonal;
residual = decomposition.Residual;

% Step 5: Plot the decomposed components
figure;
subplot(4, 1, 1);
plot(dates, values, '-o');
title('Original Time Series');
xlabel('Date');
ylabel('Value');
grid on;

subplot(4, 1, 2);
plot(dates, trend, '-o');
title('Trend Component');
xlabel('Date');
ylabel('Value');
grid on;

subplot(4, 1, 3);
plot(dates, seasonal, '-o');
title('Seasonal Component');
xlabel('Date');
ylabel('Value');
grid on;

subplot(4, 1, 4);
plot(dates, residual, '-o');
title('Residual Component');
xlabel('Date');
ylabel('Value');
grid on;