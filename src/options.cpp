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
    only_help = only_version = error_mode = false;
    program_name = argv[0];
    explicit_scheme = implicit_scheme = false;
    left = 0;
    right = 1;
    time = 1;
    time_step = 0.001;
    coor_step = 0.02;
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
    } if (only_help) {
        help();
        exit(1);
    } else if (only_version) {
        version();
        exit(1);
    }
}

void Options::parse(int argc, char *argv[])
{
    int oc;
    while ((oc = getopt(argc, argv, "hveil:r:t:T:c:")) != -1) {
        switch(oc) {
        case 'h':
            only_help = true;
            break;
        case 'v':
            only_version = true;
            break;
        case 'e':
            explicit_scheme = true;
            break;
        case 'i':
            implicit_scheme = true;
            break;
        case 'l':
            left = atof(optarg);
            break;
        case 'r':
            right = atof(optarg);
            break;
        case 't':
            time = atof(optarg);
            break;
        case 'T':
            time_step = atof(optarg);
            break;
        case 'c':
            coor_step = atof(optarg);
            break;
        case '?':
            error_mode = true;
            break;
        default:
            error_mode = true;
            break;
        }
    }
}

void Options::check()
{
    if (!explicit_scheme && !implicit_scheme)
        error_mode = true;
}

void Options::helpAndExit()
{
    help();
    exit(1);
}

void Options::help()
{
    printf("Usage: %s -e | -i [OPTION]...\n", program_name);
    printf("Program solve equation of heat used explicit or implicit scheme\n");
    printf("\n");
    printf("  One of this option must be present:\n");
    printf("      -e,    use explicit scheme\n");
    printf("      -i,    use implicit scheme\n");
    printf("\n");
    printf("  Additional options:\n");
    printf("      -l,    set left boundary of x\n");
    printf("      -r,    set right boundary of x\n");
    printf("      -t,    set time\n");
    printf("      -T,    set step of time\n");
    printf("      -c,    set step of grid\n");
    printf("      -h,    display this help and exit\n");
    printf("      -v,    ouput version information and exit\n");
}

void Options::version()
{
    printf("%s: %s version of %s\n", program_name, version_name, version_number);
}

bool Options::isErrorMode()
{
    return error_mode;
}

/* ========================================================================== */

bool Options::isExplicitScheme()
{
    return explicit_scheme;
}

bool Options::isImplicitScheme()
{
    return implicit_scheme;
}

double Options::getLeftBoundary()
{
    return left;
}

double Options::getRightBoundary()
{
    return right;
}

double Options::getTime()
{
    return time;
}

double Options::getTimeStep()
{
    return time_step;
}

double Options::getCoordStep()
{
    return coor_step;
}

/* ========================================================================== */
