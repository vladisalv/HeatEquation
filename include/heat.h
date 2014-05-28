#ifndef __HEAT_HEADER__
#define __HEAT_HEADER__

#include "types.h"
#include "grid.h"
#include "definition_func.h"

#include <iostream>
#include <fstream>
#include <stdlib.h>

using namespace std;

class Heat : public Grid {
public:
    Heat(double left, double right, double time, double time_step, double coor_step);
    ~Heat();

    void solveEquation(char type);
    void writePlot();
};

#endif /* __HEAT_HEADER__ */
