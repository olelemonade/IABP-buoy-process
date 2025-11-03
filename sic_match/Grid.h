#pragma once

struct Grid
{
	double x;
	double y;
	double lon;
	double lat;
	double dx;
	double dy;


	Grid() {}

	Grid(const Grid& grid) {
		this->x = grid.x;
		this->y = grid.y;
		this->lon = grid.lon;
		this->lat = grid.lat;
		this->dx = grid.dx;
		this->dy = grid.dy;
	}
};