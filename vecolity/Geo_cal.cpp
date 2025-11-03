#include "Geo_cal.h"
#include "math.h"
#include<iostream>
#include "ogrsf_frmts.h"
#include "gdal_priv.h"
#include "ogr_geometry.h"
#include "ogr_attrind.h"
#include "ogr_srs_api.h"
#include <vector>
//#include "ogrsf_frmts.h"


#define pi 3.1415926535897932384626433832795
#define EARTH_RADIUS 6378.137
#define vincentyConstantA 6378137
#define vincentyConstantB 6356752.314245
#define vincentyConstantF 1/298.257223563
/***
 * 度数转弧度
 * @d	: d
 * @return : 弧度
 */
double rad(double d)
{
    return d * pi / 180.0;
}
/***
 * Haversine方法：经纬度转距离
 * @lat1	: 点A的纬度
 * @lon1	: 点A的经度
 * @lat2	: 点B的纬度
 * @lon2	: 点B的经度
 * @return : 距离
 */
double Geo_cal::geo2Distantce(double lat1, double lon1, double lat2, double lon2) {
    double a;
    double b;
    double radLat1 = rad(lat1);
    double radLat2 = rad(lat2);
    a = radLat1 - radLat2;
    b = rad(lon1) - rad(lon2);
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * EARTH_RADIUS;
    s = s * 1000;
    return s;
}

double Geo_cal::getvalue(const char* tiffPath, double x, double y)
{
    GDALAllRegister();  // Register GDAL drivers

    GDALDataset* dataset = (GDALDataset*)GDALOpen(tiffPath, GA_ReadOnly);
    if (dataset == nullptr) {
        std::cerr << "无法打开文件: " << tiffPath << std::endl;
        std::cerr << "错误信息: " << CPLGetLastErrorMsg() << std::endl;
        return -1;
    }
    double geoTransform[6];
    int row, col;
    if (dataset->GetGeoTransform(geoTransform) == CE_None) {
        col = (x - geoTransform[0]) / geoTransform[1];
        row = (y - geoTransform[3]) / geoTransform[5];
    }
    else {
        std::cerr << "无法获取地理变换参数" << std::endl;
    }


    if (col >= 0 && col < dataset->GetRasterXSize() && row >= 0 && row < dataset->GetRasterYSize()) {
        float pixelValue;
        GDALRasterBand* band = dataset->GetRasterBand(1);
        band->RasterIO(GF_Read, col, row, 1, 1, &pixelValue, 1, 1, GDT_Float32, 0, 0);
        GDALClose(dataset);
        return pixelValue;
    }
    else {
        std::cerr << "Coordinate is outside the image bounds." << std::endl;
        GDALClose(dataset);
        return -2;  // Return an error value
    }
}

void Geo_cal::projection(double& X, double& Y, int epsg)
{
    CPLSetConfigOption("GDAL_DATA", "E:\\ThirdSDK\\gdal2_x64_2019\\data");//解决出现Error4的问题。
    //OGRSpatialReference oSourceSRS, oTargetSRS;
    double dX = X, dY = Y;
    OGRSpatialReference oSourceSRS, oTargetSRS;
    oSourceSRS.importFromEPSG(4326);
    oTargetSRS.importFromEPSG(epsg);

    OGRCoordinateTransformation* poCT = OGRCreateCoordinateTransformation(&oSourceSRS, &oTargetSRS);

    if (poCT == NULL || !poCT->Transform(1, &X, &Y))
        printf("Transformation failed.\n");
    else delete poCT;
}
void Geo_cal::projectionXY2BL(double& X, double& Y, int epsg)
{
    CPLSetConfigOption("GDAL_DATA", "E:\\ThirdSDK\\gdal2_x64_2019\\data");//解决出现Error4的问题。

    double dX = X, dY = Y;
    OGRSpatialReference oSourceSRS, oTargetSRS;
    oSourceSRS.importFromEPSG(epsg);
    oTargetSRS.importFromEPSG(4326);

    OGRCoordinateTransformation* poCT = OGRCreateCoordinateTransformation(&oSourceSRS, &oTargetSRS);

    if (poCT == NULL || !poCT->Transform(1, &X, &Y))
        printf("Transformation failed.\n");
    delete poCT;
}
double Geo_cal::direction(double X1, double Y1, double X2, double Y2)
{
    double dx = X2 - X1;
    double dy = Y2 - Y1;
    double angle = std::atan2(dy, dx) * 180.0 / M_PI;

    // 将角度转换为正值
    if (angle < 0.0) {
        angle += 360.0;
    }
    return angle;
}

double Geo_cal::calculateDistance(double X1, double Y1, double X2, double Y2) {

    double dx = X2 - X1;
    double dy = Y2 - Y1;
    double distance = std::sqrt(dy * dy + dx * dx);
    return distance;
}

