#ifndef __GRID_HEADER__
#define __GRID_HEADER__

#include "types.h"
#include "definition_func.h"

#include <vector>

using namespace std;

class Grid {
protected:
    grid_vec *grid;
    int gridRow, gridCol;
    double left, right, time, time_step, coor_step;
    void initGrid();
public:
    Grid(double left, double right, double time, double time_step, double coor_step);
    ~Grid();

    virtual void solveEquation(char type) = 0;
    virtual void writePlot() = 0;
};

#endif /* __GRID_HEADER__ */ 
