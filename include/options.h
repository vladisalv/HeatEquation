#ifndef __OPTIONS_HEADER__
#define __OPTIONS_HEADER__

#include <stdio.h>
#include <getopt.h>

class Options {
    char version_name[50], version_number[15];
    bool only_help, only_version, error_mode;
    char *program_name;

    void parse(int argc, char *argv[]);
    void check();
    void help();
    void version();
public:
    Options(int argc = 0, char *argv[] = 0);
    ~Options();

    void parseOption(int argc = 0, char *argv[] = 0);
};
#endif /* __OPTIONS_HEADER__ */
