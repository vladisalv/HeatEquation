#include "options.h"
#include "heat.h"

int main(int argc, char *argv[])
{
    Options options(argc, argv);
    if (options.isErrorMode())
        options.helpAndExit();

    Heat heatEquation(options.getLeftBoundary(),
                      options.getRightBoundary(),
                      options.getTime(),
                      options.getTimeStep(),
                      options.getCoordStep()
                     );

    if (options.isExplicitScheme()) {
        heatEquation.solveEquation('e');
        heatEquation.writePlot();
    }
    if (options.isImplicitScheme()) {
        heatEquation.solveEquation('i');
        heatEquation.writePlot();
    }

    return 0;
}
