
#-{ Project Relative Paths }----------------------------------------------------

BLD = ./build
CORE_SRC = $(wildcard ./core/*.c)
SRC = $(wildcard ./blink/*.c) # to be changed later depending on project


#-{ Compiler Definitions }------------------------------------------------------

# Compiler
CC = arm-none-eabi-gcc

# Device specific flags [1]
DFLAGS = -mcpu=cortex-m3 -mthumb -nostdlib
# Compiler flags
CFLAGS = $(DFLAGS) -g -Wall -Wextra

# Linker
LD = arm-none-eabi-gcc

# Path to linker script
LSCRIPT = ./linker.ld

# Linker flags
LFLAGS = -T $(LSCRIPT) --specs=nosys.specs

# Object copy (for converting formats)
OBJCOPY = arm-none-eabi-objcopy
OFLAGS = -O binary

#-{ Programming/Debugging Definitions }-----------------------------------------

# Debugger
DBG = arm-none-eabi-gdb

# Flashing tool
FLASH = st-flash

FLASH_ADDR = 0x8000000

#-{ Build Rules }---------------------------------------------------------------

# Final binaries
BIN = $(BLD)/blink.bin
ELF = $(BLD)/blink.elf

#-- These rules for the finally binaries will usually not require modification

# Convert the ELF into binary format
$(BIN): $(ELF)
	$(OBJCOPY) $(OFLAGS) $^ $@

# Link all intermediate objects into a single executable
$(ELF): $(SRC) $(CORE_SRC) | $(BLD)
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

$(BLD):
	mkdir -p $(BLD)

#-{ Utility Rules }-------------------------------------------------------------

# st-flash command to program a board
program: $(BIN) erase
	$(FLASH) write $(BIN) $(FLASH_ADDR)

erase:
	$(FLASH) erase


# Build the entire program
all: $(BIN)

# Delete all of the generated files
clean:
	rm -rf $(BLD) $(BIN) $(ELF)
