#pragma once
#include <string>
struct Buoy
{
	double lon; //lon
	double lat; //lat
	double X; //lon->X
	double Y; //lat->Y
	double velocity;
	std::string id;
	double doy;
	double year;
	double direction;
	double vx;
	double vy;

	Buoy operator-(const Buoy& p) {
		Buoy out;
		out.lon = this->lon - p.lon;
		out.lat = this->lat - p.lat;
		return out;
	}
	Buoy() {

	}

	Buoy(const Buoy& p) {
		this->lon = p.lon;
		this->lat = p.lat;
		this->velocity = p.velocity;
		this->id = p.id;
		this->direction = p.direction;
		this->doy = p.doy;
		this->year = p.year;
		this->vx = p.vx;
		this->vy = p.vy;
		this->X = p.X;
		this->Y = p.Y;
	}


};
