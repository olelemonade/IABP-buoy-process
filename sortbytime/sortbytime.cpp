#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>
#include <ctime>
#include<filesystem>
#include <cmath>
namespace fs = std::filesystem;
// 数据结构来存储每一行的数据
struct DataPoint {
    std::string buoyID;
    int year;
    int hour;
    int minute;
    double doy;
    double pos_doy;
    double latitude;
    double longitude;
    time_t time;
};

// 将浮点型的DOY和年份转换为time_t
time_t doyToTimeT(double doy, int year) {
    int int_doy = static_cast<int>(doy);
    double frac_doy = doy - int_doy;

    std::tm tm = {};
    tm.tm_year = year - 1900;  // 年份从1900年开始
    tm.tm_mon = 0;             // 一月
    tm.tm_mday = 1;            // 第一天
    tm.tm_hour = 0;
    tm.tm_min = 0;
    tm.tm_sec = 0;
    time_t base = mktime(&tm);

    // 将整数天部分加入时间
    time_t time_with_days = base + (int_doy - 1) * 24 * 60 * 60;

    // 处理小数部分
    int hours = static_cast<int>(frac_doy * 24);
    int minutes = static_cast<int>((frac_doy * 24 - hours) * 60);
    int seconds = static_cast<int>((((frac_doy * 24 - hours) * 60) - minutes) * 60);

    tm = {};
    localtime_s(&tm, &time_with_days); // 使用localtime_s
    tm.tm_hour += hours;
    tm.tm_min += minutes;
    tm.tm_sec += seconds;

    return mktime(&tm);
}
// 去除字符串两端的空格
std::vector<std::string> splitString(const std::string& input, const std::string& delimiter) {
    std::vector<std::string> tokens;
    size_t start = 0, end = 0;

    while ((end = input.find(delimiter, start)) != std::string::npos) {
        tokens.push_back(input.substr(start, end - start));
        start = end + delimiter.length();
    }

    tokens.push_back(input.substr(start)); // 处理最后一个分割后的子串
    return tokens;
}
// 解析单行数据
DataPoint parseLine(const std::string& line) {
    std::vector<std::string> tokens = splitString(line, "  "); // 使用多个空格作为分隔符

    DataPoint dataPoint;
    dataPoint.buoyID = tokens[0];
    dataPoint.year = std::stoi(tokens[1]);
    dataPoint.hour = std::stoi(tokens[2]);
    dataPoint.minute = std::stoi(tokens[3]);
    dataPoint.doy = std::stod(tokens[4]);
 
    dataPoint.pos_doy = std::stod(tokens[5]);
    dataPoint.latitude = std::stod(tokens[6]);
    if (dataPoint.pos_doy < 0)  dataPoint.pos_doy = dataPoint.doy;
    dataPoint.longitude = std::stod(tokens[7]);

    // 计算具体时间
    dataPoint.time = doyToTimeT(dataPoint.pos_doy, dataPoint.year);

    return dataPoint;
}

// 比较函数用于排序
bool compareDataPoints(const DataPoint& dp1, const DataPoint& dp2) {
    return dp1.time < dp2.time;
}

int main() {
    std::string folderPath = "D:\\buoy_2025\\";

    int file_count = 1;
    // 遍历文件夹内所有文件
    for (const auto& entry : fs::directory_iterator(folderPath)) {
        // 文件名
        std::string filename = entry.path().filename().string();
        std::string outputFilename = "D:\\buoy_sort_2025\\"+ filename;

        // 读取文件内容
        std::ifstream inputFile(entry.path());
        if (!inputFile.is_open()) {
            std::cerr << "无法打开文件: " << filename << std::endl;
            return 1;
        }

        std::vector<DataPoint> dataPoints;
        std::string line;
        std::getline(inputFile, line);
        // 逐行读取文件内容
        while (std::getline(inputFile, line)) {
            dataPoints.push_back(parseLine(line));
        }

        inputFile.close();

        // 对数据点进行排序
        std::sort(dataPoints.begin(), dataPoints.end(), compareDataPoints);

        // 将排序后的结果写入文件
        std::ofstream outputFile(outputFilename);
        if (!outputFile.is_open()) {
            std::cerr << "无法打开文件: " << outputFilename << std::endl;
            return 1;
        }
        outputFile << "BuoyID     Year     Hour     Min     DOY     POS_DOY     Lat     Lon\n";
        for (const DataPoint& dp : dataPoints) {
            outputFile << dp.buoyID << "   " << dp.year << "   " << dp.hour << "   " << dp.minute << "   "
                << dp.doy << "   " << dp.pos_doy << "   " << dp.latitude << "   " << dp.longitude << std::endl;
        }

        outputFile.close();

        std::cout <<"数据已排序并写入文件: " << outputFilename << std::endl;
    }
    return 0;
}
