#include "definition_func.h"

grid_t initFunction(double x)
{
    //return 0.0;
    return sin(x * M_PI);
}

grid_t leftBoundaryFunction(double t)
{
    return 0.0;
    //return t;
    //return sin(t);
}

grid_t rightBoundaryFunction(double t)
{
    //return t;
    //return t;
    return 0.0;
    //return cos(t);
}

grid_t heatFunction(double x, double t)
{
    //return x + t;
    //return 0.0;
    return sin(t * 2 * M_PI);
}
