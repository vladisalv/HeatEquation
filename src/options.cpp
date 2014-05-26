#include "options.h"

Options::Options(int argc, char *argv[])
{
#ifdef VERSION
    sprintf(version_name, VERSION);
#else
    sprintf(version_name, "UNKNOW");
#endif

#ifdef VERSION_NUMBER
    sprintf(version_number, VERSION_NUMBER);
#else
    sprintf(version_number, "UNKNOW");
#endif
    only_help = error_mode = false;
    program_name = argv[0];
    parseOption(argc, argv);
}

Options::~Options()
{
}

void Options::parseOption(int argc, char *argv[])
{
    parse(argc, argv);
    if (!only_help && !only_version) {
        check();
    } else if (only_help) {
        help();
        return;
    } else if (only_version) {
        version();
        return;
    }
    if (only_help) {
        help();
        error_mode = true;
    }
}

void Options::parse(int argc, char *argv[])
{
    int oc;
    while ((oc = getopt(argc, argv, "hv")) != -1) {
        switch(oc) {
        case 'h':
            only_help = true;
            break;
        case 'v':
            only_version = true;
            break;
        }
    }
}

void Options::check()
{
    return;
}

void Options::help()
{
    return;
}

void Options::version()
{
    return;
}
