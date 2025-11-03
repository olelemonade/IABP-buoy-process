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
#include "atltime.h"
using namespace std;
namespace fs = std::filesystem;
//拆分字符串
// Helper function to convert year and day of year (including fractional part) to std::tm structure
std::tm convertToTm(int year, double doy) {
    std::tm timeStruct = {};
    timeStruct.tm_year = year - 1900; // tm_year is years since 1900
    timeStruct.tm_mon = 0;            // January
    timeStruct.tm_mday = 1;           // 1st day of the month

    // Separate the integer and fractional parts of doy
    int int_doy = static_cast<int>(doy);
    double frac_doy = doy - int_doy;

    // Add integer part of doy to January 1st
    timeStruct.tm_mday += int_doy - 1;

    // Calculate hours, minutes, and seconds from fractional part of doy
    int total_seconds = static_cast<int>(frac_doy * 24 * 60 * 60);
    int hours = total_seconds / 3600;
    int minutes = (total_seconds % 3600) / 60;
    int seconds = total_seconds % 60;

    // Set the time components
    timeStruct.tm_hour = hours;
    timeStruct.tm_min = minutes;
    timeStruct.tm_sec = seconds;

    // Handle overflow to the correct month and day
    std::mktime(&timeStruct);

    return timeStruct;
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
    s << i;
    return s.str();
}
double d2r(double dgree)
{
    double rad = dgree / 180 * 3.1415926;
    return rad;
}
int main() {
    std::string folderPath = "D:\\buoy_sort_2025\\";
    vector<Buoy> result;
    Buoy buoy1, buoy_mark;
    ofstream myfile;
    int file_count = 1;
    // 遍历文件夹内所有文件
    for (const auto& entry : fs::directory_iterator(folderPath)) {
        int count = 1;

        string filename = entry.path().filename().string();
        string resultname = "E:/Major revision/3h_velocity/3_" + filename;
        double timediff = 0;
        // 检查文件扩展名是否为dat
        if (entry.path().extension() == ".dat") {
            // 打开txt文件并读取内容
            std::ifstream inputFile(entry.path());

            // 检查文件是否成功打开
            if (!inputFile.is_open()) {
                std::cerr << "无法打开文件 " << entry.path() << std::endl;
                continue;
            }
            // 逐行读取文件内容
            std::string line;
            std::getline(inputFile, line);//跳过表头
            double X = 0, Y = 0, distance = 0;
            while (std::getline(inputFile, line))//读取第一个点
            {

                vector<string> var = splitString(line, "   ");
                if ((var.size() < 8) || (var[6] == "nan") || (var[7] == "nan"))
                    continue;
                if ((atof((var[6]).c_str()) < 0) || (abs(atof((var[6]).c_str())) > 90) || (abs(atof((var[7]).c_str())) > 180) || ((atof((var[6]).c_str()) == 0) && (atof((var[7]).c_str()) == 0)))
                    continue;
                buoy1.id = var[0];
                buoy1.lat = atof((var[6]).c_str());
                buoy1.lon = atof((var[7]).c_str());
                buoy1.doy = atof((var[5]).c_str());
                buoy1.year = atof((var[1]).c_str());
                /*if (buoy1.year < 2012 || buoy1.year>2024) continue;*/
                X = buoy1.lon;
                Y = buoy1.lat;

                Geo_cal::projection(X, Y, 3411);
                buoy1.Y = Y;
                buoy1.X = X;
                buoy_mark = buoy1;
                break;
            }
            myfile.open(resultname);
            while (std::getline(inputFile, line))
            {
                // 处理每一行的内容，这里可以根据需要进行操作
                vector<string> var = splitString(line, "   ");
                if ((var.size() < 8) || (var[6] == "nan") || (var[7] == "nan"))
                    continue;

                if (atof((var[6]).c_str()) < 0)
                {
                    myfile.close();
                    fs::remove(resultname);
                    break;
                }
                else if ((abs(atof((var[6]).c_str())) > 90) || (abs(atof((var[7]).c_str())) > 180) || ((atof((var[6]).c_str()) == 0) && (atof((var[7]).c_str()) == 0)))
                    continue;
                else {
                    Buoy buoy2, target;
                    buoy2.lat = atof((var[6]).c_str());
                    buoy2.lon = atof((var[7]).c_str());
                    X = buoy2.lon;
                    Y = buoy2.lat;

                    Geo_cal::projection(X, Y, 3411);


                    buoy2.Y = Y;
                    buoy2.X = X;
                    buoy2.doy = atof((var[5]).c_str());
                    buoy2.year = atof((var[1]).c_str());
                    buoy2.id = buoy1.id;

                    //if (buoy2.year < 2012 || buoy2.year>2023) { buoy1 = buoy2; continue; };
                    // Convert year and doy to std::tm
                    std::tm time1 = convertToTm(buoy1.year, buoy1.doy);
                    std::tm time2 = convertToTm(buoy2.year, buoy2.doy);

                    // Convert std::tm to time_t
                    std::time_t time1_t = std::mktime(&time1);
                    std::time_t time2_t = std::mktime(&time2);

                    double difference = std::difftime(time2_t, time1_t);
                    //cout << time1_t << "     " << time2_t <<"        " << difference << "\n";
                    //cout << difference << endl;

                    if (difference == 0) { buoy1 = buoy2; continue; }

                    /*if (((buoy2.year - buoy1.year) < 0) || ((buoy2.year == buoy1.year) && buoy2.doy < buoy1.doy) || (buoy2.doy < buoy1.doy))*/
                    //if (difference>=30*24*60*60|| time1_t> time2_t)
                    //{
                    //    buoy1 = buoy2;
                    //    count++;
                    //    std::string resultname1 = split(resultname, ".")[0] + "(" + itos(count) + ")" + ".dat";
                    //    myfile.close();
                    //    myfile.open(resultname1);
                    //    continue;
                    //}
                    if (difference > 6.5 * 60 * 60) {
                        timediff = 0; buoy_mark = buoy2; buoy1 = buoy2; continue;
                    }
                    else
                    {
                        double ddd = abs(timediff - 3 * 60 * 60);
                        timediff = timediff + difference;
                        double ddd2 = abs(timediff - 3 * 60 * 60);
                        if (timediff > 3 * 60 * 60)
                        {
                            if (ddd2 < ddd)
                            {
                                distance = Geo_cal::geo2Distantce(buoy2.lat, buoy2.lon, buoy_mark.lat, buoy_mark.lon);
                                //cout << distance;
                                double v = 0;  
                                if (distance > 0)  v = distance / timediff;
                                target.velocity = v;
                                target.year = buoy2.year;
                                target.id = buoy2.id;
                                target.direction = Geo_cal::direction(buoy_mark.X, buoy_mark.Y, buoy2.X, buoy2.Y);
                                target.vx = target.velocity * sin(d2r(target.direction));
                                target.vy = target.velocity * cos(d2r(target.direction));
                                //result.push_back(target);


                                myfile << buoy_mark.id << "," << buoy_mark.year << "," << buoy_mark.doy << "," << buoy_mark.lon << "," << buoy_mark.lat << "," << buoy2.doy << "," << buoy2.lon << "," << buoy2.lat << "," << target.direction << "," << distance << "," << target.velocity << "," << target.vx << "," << target.vy << "," << timediff / (60 * 60) << "," << buoy_mark.X << "," << buoy_mark.Y << "\n";
                                buoy_mark = buoy2;
                                buoy1 = buoy2;
                                timediff = 0;
                            }
                            else
                            {
                                timediff -= difference;
                                distance = Geo_cal::geo2Distantce(buoy1.lat, buoy1.lon, buoy_mark.lat, buoy_mark.lon);
                                //cout << distance;
                                double v = 0;
                                if (distance > 0)  v = distance / timediff;
                                target.velocity = v;
                                target.year = buoy1.year;
                                target.id = buoy1.id;
                                target.direction = Geo_cal::direction(buoy_mark.X, buoy_mark.Y, buoy1.X, buoy1.Y);
                                target.vx = target.velocity * sin(d2r(target.direction));
                                target.vy = target.velocity * cos(d2r(target.direction));
                                //result.push_back(target);


                                myfile << buoy_mark.id << "," << buoy_mark.year << "," << buoy_mark.doy << "," << buoy_mark.lon << "," << buoy_mark.lat << "," << buoy1.doy << "," << buoy1.lon << "," << buoy1.lat << "," << target.direction << "," << distance << "," << target.velocity << "," << target.vx << "," << target.vy << "," << timediff / (60 * 60) << "," << buoy_mark.X << "," << buoy_mark.Y << "\n";
                                buoy_mark = buoy1;
                                buoy1 = buoy2;
                                timediff = difference;
                            }
                        }
                        else
                        {
                            buoy1 = buoy2;
                        }

                    }

                }

            }
            //"300234066218790   2019   06   00   216.2500   216.2500   60.07700   -22.70200   14.24"
            // 关闭文件
            file_count++;
            std::cout << entry.path().filename() << "    " << file_count << std::endl;
            inputFile.close();
            myfile.close();
        }
    }

    return 0;
}
