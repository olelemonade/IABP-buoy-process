#pragma once

class Geo_cal
{
private:
public:
	static double calculateDistance(double lat1, double lon1, double lat2, double lon2);
	static double geo2Distantce(double lat1, double lon1, double lat2, double lon2);
	static void projection(double& X, double& Y, int epsg);
	static double direction(double X1, double Y1, double X2, double Y2);
	static void projectionXY2BL(double& X, double& Y, int epsg);
	static double getvalue(const char* tiffPath, double x, double y);
};

