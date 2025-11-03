#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <string>
#include<filesystem>
#include "buoy.h"
#include "Geo_cal.h"
#include <cmath>
#include <sstream>
#include "Grid.h"
#include "atltime.h"
using namespace std;
namespace fs = std::filesystem;
//拆分字符串

double WNLON = -135, WSLON = -45, ESLON = 45, ENLON = 135;
double WNLAT = 50, WSLAT = 50, ENLAT = 50, ESLAT = 50;

std::string getDateFromYearAndDOY(int year, int doy) {
    // 创建tm结构，并设置年份和一年中的第几天
    std::tm time_in = { 0, 0, 0, 1, 0, year - 1900 }; // January 1st of the given year
    time_in.tm_mday += doy - 1; // Adjust to the correct day of the year

    // 使用mktime将tm结构转换为time_t类型
    std::mktime(&time_in);

    // 创建字符串流，格式化日期
    std::ostringstream oss;
    oss << std::put_time(&time_in, "%Y%m%d");

    return oss.str();
}
std::vector<std::string> split(const std::string& str, const std::string& pattern)
{
    std::vector<std::string> res;
    if (str == "")
        return res;

    std::string strs = str + pattern;
    size_t pos = strs.find(pattern);

    while (pos != strs.npos)
    {
        std::string temp = strs.substr(0, pos);
        res.push_back(temp);
        strs = strs.substr(pos + 1, strs.size());
        pos = strs.find(pattern);
    }

    return res;
}
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

double doy2sec(double doy1, double doy2)
{
    double sec = abs(doy1 - doy2) * 24 * 60 * 60;
    return sec;
}
std::string itos(int i)
{
    std::stringstream s;
    s << std::setw(2) << std::setfill('0') << i;
    return s.str();
}
void saveAsCSV(const std::vector<std::vector<string>>& data, const std::string& filename) {
    std::ofstream file(filename);
    if (file.is_open()) {
        for (const auto& row : data) {
            for (const auto& value : row) {
                file << value << ",";
            }
            file << "\n";
        }
        file.close();
        std::cout << filename + "  CSV file saved successfully.\n" << std::endl;
    }
    else {
        std::cout << "Unable to open the file." << std::endl;
    }
}
vector<vector<Grid>> getGrid2(vector<vector<string>> data, int size) {
    // 遍历所有采样数据
    vector<vector<Grid>> datas;
    vector<double> d2xy;
    vector<Grid> grids;
    for (int i = 0; i <= size; i++)
    {
        for (int j = 0; j <= size; j++)
        {
            Grid grid;
            string s = data[i][j].c_str();
            if (s == "--:--")
            {
                grid.dx = 0;
                grid.dy = 0;//// 单位为cm/s
                grids.push_back(grid);
            }
            else {
                vector<string> str = splitString(s, ":");
                grid.dx = atof(str[0].c_str());
                grid.dy = atof(str[1].c_str());//// 单位为cm/s
                grids.push_back(grid);
            }
        }
        datas.push_back(grids);
        grids.clear();
    }
    return datas;
}

bool fileExists(const std::string& filePath) {
    return fs::exists(filePath) && fs::is_regular_file(filePath);
}
int main() {
    std::string folderPath = "E:\\Major revision\\3h_velocity";
    std::string outpath = "E:\\Major revision\\wind\\sic_wind_";
    for (const auto& entry : fs::directory_iterator(folderPath)) {
        // 打开包含数据的文件
        string inputFileName = entry.path().filename().string();
        string resultname = outpath + inputFileName;
        if (fileExists(resultname)) {
            
            std::cout << "文件存在" << std::endl;
            continue;
        }
        std::ifstream inFile(entry.path());
        std::ofstream outFile(resultname);
        if (!inFile.is_open()) {
            std::cerr << "Unable to open the input file." << std::endl;
            return 1;
        }

        // 读取文件中的数据并处理
        std::string line;
        std::string Path = "";
        std::string Year = "";
        std::getline(inFile, line);
        int maxday = 365;
        vector<string> ice;
        while (std::getline(inFile, line)) {
            std::vector<std::string> var = splitString(line, ",");
            std::string year = var[1];
            if (year == "2012" || year == "2016" || year == "2020")
                maxday = 366;
            if (atoi(year.c_str()) < 2013 || atoi(year.c_str()) > 2024) continue;
            int doy = ceil(atof(splitString(var[2], ".")[0].c_str()));
            int hour = floor((atof(var[2].c_str()) - floor(atof(splitString(var[2], ".")[0].c_str())))*24);
            std::string DOY = itos(doy);
            if (floor(atof(splitString(var[2], ",")[0].c_str())) == maxday)
            {
                doy = 1;
                int y = atoi(year.c_str()) + 1;
                year = itos(y);
            }
            string date = getDateFromYearAndDOY(atoi(year.c_str()), doy);
            std::vector<std::string> path;
            std::vector<std::string> windpath;
            if (atoi(year.c_str()) >= 2017)
                path.push_back("E:\\pythonProject\\bremen_sic\\1km\\sic_modis-aqua_amsr2-gcom-w1_merged_nh_1000m_" + date + ".tif");
            path.push_back("E:\\pythonProject\\bremen_sic\\downloads" + date.substr(0, 4) + "\\" + "asi-AMSR2-n3125-" + date + "-v5.4.tif");
            path.push_back("E:\\pythonProject\\bremen_sic\\downloads" + date.substr(0, 4) + "\\" + "asi-AMSR2-n3125-" + date + "-v5.tif");
            windpath.push_back("G:\\era5wind\\" + date.substr(0, 4) + "\\u10\\" + "u10_mps_" + date +itos(hour)+ ".tif");
            windpath.push_back("G:\\era5wind\\" + date.substr(0, 4) + "\\v10\\" + "v10_mps_" + date + itos(hour) + ".tif");
            double lat = atof(var[4].c_str());
            double lon = atof(var[3].c_str());
            //double v = atof(var[7].c_str());
            //if (v >= 5) continue;
            double u10 = 0;
            double v10 = 0;
            u10 = Geo_cal::getvalue(windpath[0].c_str(), lon, lat);
            v10 = Geo_cal::getvalue(windpath[1].c_str(), lon, lat);
            Geo_cal::projection(lon, lat, 3411);

            double sic = 0;



            for (int i = 0; i <= path.size() - 1; i++)
            {
                sic = Geo_cal::getvalue(path[i].c_str(), lon, lat);
                if (sic <= 100 && sic >= 0) break;
            }



            if (sic <= 100 && sic >= 0)
                outFile << line << "," << sic / 100.0 <<"," << u10<<"," << v10 << "\n";



        }
    }
    return 0;

}
