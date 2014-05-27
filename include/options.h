#ifndef __OPTIONS_HEADER__
#define __OPTIONS_HEADER__

#include <stdio.h>
#include <getopt.h>
#include <stdlib.h>

class Options {
    char version_name[50], version_number[15];
    bool only_help, only_version, error_mode;
    char *program_name;
    bool explicit_scheme, implicit_scheme;
    double left, right, time, time_step, coor_step;

    void parse(int argc, char *argv[]);
    void check();
    void help();
    void version();
public:
    Options(int argc = 0, char *argv[] = 0);
    ~Options();

    void parseOption(int argc = 0, char *argv[] = 0);
    void helpAndExit();

    bool isErrorMode();

    bool isExplicitScheme();
    bool isImplicitScheme();
    double getLeftBoundary();
    double getRightBoundary();
    double getTime();
    double getTimeStep();
    double getCoordStep();
};
#endif /* __OPTIONS_HEADER__ */
