#include "grid.h"

Grid::Grid(double new_left, double new_right,
    double new_time, double new_time_step, double new_coor_step)
    : time(new_time), time_step(new_time_step), coor_step(new_coor_step),
    left(new_left), right(new_right)
{
    gridRow = (int)((right - left) / coor_step);
    gridCol = (int)((time - 0) / time_step);

    grid = new grid_vec (gridRow, vector<grid_t>(gridCol, 0));
}
