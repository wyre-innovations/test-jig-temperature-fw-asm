# Makefile for PIC16F72 assembly project using gputils (gpasm + gplink)

GPASM   := gpasm
GPLINK  := gplink
PROC    := p16f72
GPASM_FLAGS := -c -p $(PROC) -I inc

SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.s)
OBJECTS := $(patsubst $(SRC_DIR)/%.s,$(OUT_DIR)/%.o,$(SOURCES))
TARGET  := $(OUT_DIR)/app.hex

.PHONY: all clean

all: $(TARGET)

# create output directory
$(OUT_DIR):
	mkdir -p $(OUT_DIR)

# link object files into final hex (use gplink)
$(TARGET): $(OBJECTS) | $(OUT_DIR)
	$(GPLINK) -p $(PROC) -s 16f72_g.lkr -o $@ $(OBJECTS)

# assemble each .s into a relocatable object (.o)
# note: $< is like src/foo.s -> produces out/foo.o
$(OUT_DIR)/%.o: $(SRC_DIR)/%.s | $(OUT_DIR)
	$(GPASM) $(GPASM_FLAGS) -o $@ $<

clean:
	rm -rf $(OUT_DIR)