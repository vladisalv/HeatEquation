#include <iostream>

#include "options.h"

using namespace std;

int main(int argc, char *argv[])
{
    Options options(argc, argv);
    if (options.isErrorMode())
        options.helpAndExit();

    return 0;
}
