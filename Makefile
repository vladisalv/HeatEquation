# ============================================================================ #
# Version: 1.0                                                                 #
# Last update: 25.05.2014                                                      #
#                                                                              #
# Makefile для проекта HeatEquation                                            #
#                                                                              #
# !!!!!!!!!!!!!!!!!!!!!!! ВАЖНО !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
#                                                                              #
#   При первом запуске выйдет ОШИБКА при линковке в окончательный модуль!      #
#   Это особенность данной версии Makefile. просто соберите проект еще раз!    #
#                                                                              #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
#                                                                              #
#  если интересно в чем ошибка:                                                #
# дело в том, что откомпилированные объектные файлы сохраняются не корневой    #
# каталог, а в папку obj, но утилита make (видимо ее особенность) запоминает   #
# отсутствие файлов в корневом каталоге и потом ищет их только там (хотя опция #
# vpath %.o $(OBJ_NOW) стоит задолго до этого). В будущем исправлю             #
#                                                                              #
# ============================================================================ #


# подключение конфигурационного файла
include config.mk

# инициализация опций
ifneq ($(S), "")
ARGUMENTS += "-$(S)"
endif
ifneq ($(L), "")
ARGUMENTS += "-l $(L)"
endif
ifneq ($(R), "")
ARGUMENTS += "-r $(R)"
endif
ifneq ($(t), "")
ARGUMENTS += "-t $(t)"
endif
ifneq ($(T), "")
ARGUMENTS += "-T $(T)"
endif
ifneq ($(c), "")
ARGUMENTS += "-c $(c)"
endif

# ==============================================================================
# опции компилятора
CFLAGSDEBUG   = -g
CFLAGSRELEASE = -Werror -Wall -pedantic

# общие опции при любом варианте VERSION
CFLAGSCOMMON  = 
ifneq ($(VERSION), "")
    CFLAGSCOMMON += -DVERSION=\"$(VERSION)\"
endif
ifneq ($(VERSION_NUMBER), "")
    CFLAGSCOMMON += -DVERSION_NUMBER=\"$(VERSION_NUMBER)\"
endif

CFLAGSINCLUDE = $(addprefix -I , $(INCLUDE_DIR)) $(addprefix -I , $(OBJ_NOW))
CFLAGSLIB     = $(addprefix -L, $(LIB_DIR)) $(addprefix -l, $(LIBMODULES))

ifeq ($(VERSION), DEBUG)
    CFLAGS    = $(CFLAGSCOMMON) $(CFLAGSDEBUG) $(CFLAGSINCLUDE)
else ifeq ($(VERSION), RELEASE)
    CFLAGS    = $(CFLAGSCOMMON) $(CFLAGSRELEASE) $(CFLAGSINCLUDE)
else
    CFLAGS    = $(CFLAGSCOMMON) $(CFLAGSINCLUDE)
endif
# ==============================================================================

# директории
INCLUDE_DIR = include
SRC_DIR     = src
LIB_DIR     = 
CODE_DIR    = $(INCLUDE_DIR) $(SRC_DIR)
OUTPUT_DIR  = result

# определение всех имен через директории
SRCMODULES := $(notdir $(wildcard  $(SRC_DIR)/*.cpp))
OBJMODULES := $(SRCMODULES:.cpp=.o)
INCMODULES := $(notdir $(wildcard $(INCLUDE_DIR)/*.h) )
LIBMODULES := 

# директория для бинарника
BIN         = bin
BIN_DEBUG   = $(BIN)/debug
BIN_RELEASE = $(BIN)/release
ifeq ($(VERSION), DEBUG)
    BIN_NOW = $(BIN_DEBUG)
else ifeq ($(VERSION), RELEASE)
    BIN_NOW = $(BIN_RELEASE)
endif

# директория для объектных файлов
OBJ         = obj
OBJ_DEBUG   = $(OBJ)/debug
OBJ_RELEASE = $(OBJ)/release
ifeq ($(VERSION), DEBUG)
    OBJ_NOW = $(OBJ_DEBUG)
else ifeq ($(VERSION), RELEASE)
    OBJ_NOW = $(OBJ_RELEASE)
endif

# ============== ОПРЕДЕЛЕНИЕ ЦЕЛЕЙ =============================================

# абстрактные цели (выполняются в любом случае)
.PHONY: print clean all run delete watch

# главная цель (пустая команда make)
all: build

# компиляция
build:  $(OBJMODULES) 
	@echo Compiling program.....
	@$(CC) $(CFLAGS) $^ -o $(BIN_NOW)/$(PROG_NAME) $(CFLAGSLIB)
	@echo Program is compiled.

# запуск
run:
	@./$(BIN_NOW)/$(PROG_NAME) $(ARGUMENTS)

# пересобрать
rebuild: clean build

# очистка от исполняемых данных
clean:
	@echo Cleaning...
	@rm -f $(OBJ_NOW)/*.o
	@rm -f $(BIN_NOW)/$(PROG_NAME)
	@rm -f deps.mk

# удаление файлов результата
delete:
	@echo Delete output file
	@rm -f $(OUTPUT_DIR)/*

# вывести опции программы
help:
	@$(BIN_NOW)/$(PROG_NAME) -h

# отладочная печать 
print:
	@echo $(BIN_NOW)
	@echo $(VERSION)
	@echo $(CFLAGS)
	@echo $(ARGUMENTS)

watch:
	@$(GIFPROG) $(OUTPUT_DIR)/graphic.gif

vim:
	vim -s project/vim_open
# ==============================================================================

# включение файла зависимостей
-include deps.mk

# файл зависимостей
deps.mk: $(SRCMODULES)
	@echo "Create file of dependens..."
	@$(CC) $(CFLAGSINCLUDE) -MM $^ > $@

# пути поиска шаблонов
vpath %.h   $(INCLUDE_DIR)
vpath %.cpp $(SRC_DIR)
vpath %.o   $(OBJ_NOW)

# шаблоны компилирования 
%.o: %.cpp %.h
	@$(CC) $(CFLAGS) -c $<  -o $(OBJ_NOW)/$@
%.o: %.cpp
	@$(CC) $(CFLAGS) -c $<  -o $(OBJ_NOW)/$@
