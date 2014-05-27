#include "heat.h"

Heat::Heat(double new_left, double new_right,
    double new_time, double new_time_step, double new_coor_step)
    : Grid(new_left, new_right, new_time, new_time_step, new_coor_step)
{
}

Heat::~Heat()
{
}

void Heat::solveEquation(char type)
{
    initGrid();
    if (type == 'e') {
        double gamma = time_step / (coor_step * coor_step);
        for (int t = 1; t < gridRow; t++) {
            (*grid)[t][0] = leftBoundaryFunction(t);
            (*grid)[t][gridRow - 1] = rightBoundaryFunction(t);
            for (int x = 1; x < gridRow - 1; x++)
                (*grid)[t][x] = (*grid)[t - 1][x]
                           + gamma * ((*grid)[t - 1][x - 1] - 2 * (*grid)[t - 1][x] + (*grid)[t - 1][x + 1])
                           + time_step * heatFunction(left + x * coor_step, t + time_step);
        }
    } else if (type == 'i') {
        ;
    }
}

void Heat::writePlot()
{
    grid_t min, max;
    min = max = (*grid)[0][0];

    ofstream data("result/data");
    for (int x = 0; x < gridCol; x++) {
        data << left + x * coor_step << " ";
        for (int t = 0; t < gridRow; t++) {
            grid_t tmp = (*grid)[t][x];
            if (tmp > max)
                max = tmp;
            if (tmp < min)
                min = tmp;
            data << tmp << " ";
        }
        data << endl;
    }
    data.close();

    ofstream plot("result/plot");
    plot << "set term gif animate enhanced" << endl;
    plot << "set nokey" << endl;
    plot << "set output 'result/graphic.gif'" << endl;
    plot << "set xrange [" << left << ":" << right << "]" << endl;
    plot << "set yrange [" << min  << ":" << max << "]" << endl;
    plot << "progress = 0" << endl;
    plot << "length = " << gridRow + 1 << endl;
    plot << "do for [i = 2 : length] {" << endl;
    plot << "    plot 'result/data' using 1:i w li lw 3 lt rgb 'purple'" << endl;
    plot << "}" << endl;
    plot.close();

    system("gnuplot result/plot");
}

