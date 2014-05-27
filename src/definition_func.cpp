#include "definition_func.h"

grid_t initFunction(double x)
{
    return 2 * x;
}

grid_t leftBoundaryFunction(double t)
{
    return sin(t);
}

grid_t rightBoundaryFunction(double t)
{
    return cos(t);
}

grid_t heatFunction(double x, double t)
{
    return sin(x) + cos(x);
}
