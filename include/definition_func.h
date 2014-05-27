#ifndef __DEFINITION_FUNC_HEADER__
#define __DEFINITION_FUNC_HEADER__

#include "types.h"

#include <math.h>

grid_t initFunction(double x);
grid_t leftBoundaryFunction(double t);
grid_t rightBoundaryFunction(double t);
grid_t heatFunction(double x, double t);

#endif /* __DEFINITION_FUNC_HEADER__ */
