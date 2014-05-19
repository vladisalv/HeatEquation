# ============================================================================ #
# Version: 1.0                                                                 #
# Last update: 08.05.2014                                                      #
#                                                                              #
# Makefile для проекта Ковчег                                                  #
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
# Что нужно будет сделать:                                                     #
# 1. Исправить ошибку первого прохода                                          #
# 2. Написать makefile для BlueGene                                            #
# 3. Добавить цели:                                                            #
# 	- test                                                                     #
# 4. Опции gfortran.
# 5. Вынесение всей черной работы в отдельный файл                             #
# 6. Повысить гибкость и понимание                                             #
#                                                                              #
# ============================================================================ #
#                                                                              #
#                         Версия для: ЛОМОНОСОВА                               #
#                                                                              #
# ============================================================================ #


# подключение конфигурационного файла
include config.mk

# инициализация опций

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

# дополнительные параметры для запуска
DATE        = `date +%X`
ARGUMENTS   = 
OUTPUT      = $(OUTPUT_DIR)/$(DATE)

# ============== ОПРЕДЕЛЕНИЕ ЦЕЛЕЙ =============================================

# абстрактные цели (выполняются в любом случае)
.PHONY: print clean all run

# главная цель (пустая команда make)
all: build

# компиляция
build:  $(OBJMODULES) 
	@echo Compiling program.....
	@$(CC) $(CFLAGS) $^ -o $(BIN_NOW)/$(PROG_NAME) $(CFLAGSLIB)
	@echo Program is compiled.

# запуск
run:
	@echo "RUN PROGRAM"
	@echo -n "YOUR PARAMETRS: "
	@echo $(ARGUMENTS)
	@./$(BIN_NOW)/$(PROG_NAME) $(ARGUMENTS)

# пересобрать
rebuild: clean all

# очистка от исполняемых данных
clean:
	@echo Cleaning...
	@rm -f $(OBJ_NOW)/*.o
	@rm -f $(BIN_NOW)/$(PROG_NAME)
	@rm -f deps.mk

# полная очистка. удаление исполняемых файлов и файлов результата
cleanAll: clean
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

# посмотреть свою очередь
# загрузить модули
module:

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
