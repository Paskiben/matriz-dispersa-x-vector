.PHONY: all clean
# Directorios de origen y destino
SRC_DIR = src
INCLUDE_DIR = include
COMPILED_DIR = out

# Nombre del ejecutable
EXECUTABLE = bin/prog

# Compilador y opciones de compilación
CXX = g++
CXXFLAGS = -std=c++23 -Wall -O4 -fopenmp -lm -I$(INCLUDE_DIR)


# Obtener la lista de archivos fuente (excluyendo main.cpp)
SOURCES = $(filter-out main.cpp, $(wildcard $(SRC_DIR)/**/*.cpp))

# Objeto correspondiente a main.cpp
MAIN_OBJECT = out/main.o

# Objetos generados
OBJECTS = $(patsubst $(SRC_DIR)/%.cpp,$(COMPILED_DIR)/%.o,$(SOURCES)) $(MAIN_OBJECT)

# Regla principal para compilar el ejecutable
all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJECTS)

# Regla para compilar los objetos del directorio SRC_DIR
$(COMPILED_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Regla para compilar main.cpp
$(MAIN_OBJECT): src/main.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Limpieza de archivos compilados
clean:
	@echo " [CLN] Cleaning"
	rm -rf $(COMPILED_DIR)/*.o $(EXECUTABLE) $(COMPILED_DIR)/*