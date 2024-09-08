#-{ Predefined Projects }-------------------------------------------------------

# Define valid projects
VALID_PROJECTS := blink gpio_drv

# Default project (can be overridden by user)
PROJECT ?= NO_PROJECT_SELECTED

# Check if the selected project is valid
ifneq ($(filter $(PROJECT),$(VALID_PROJECTS)), $(PROJECT))
$(error Invalid project "$(PROJECT)"! Valid options are: $(VALID_PROJECTS))
endif


#-{ Project Relative Paths }----------------------------------------------------

BLD 			= ./build/$(PROJECT)
CORE_SRC 		= $(wildcard ./core/src/*.c)
CORE_INC 		= ./core/inc
PROJECT_SRC 	= $(wildcard ./$(PROJECT)/src/*.c)
PROJECT_INC 	= ./$(PROJECT)/inc

#-{ Compiler Definitions }------------------------------------------------------

# Compiler
CC = arm-none-eabi-gcc

# Device specific flags [1]
DFLAGS = -mcpu=cortex-m3 -mthumb -nostdlib
# Compiler flags
CFLAGS = $(DFLAGS) -g -Wall -Wextra -I$(CORE_INC) -I$(PROJECT_INC)

# Path to linker script
LSCRIPT = ./linker.ld

# Linker flags
LFLAGS = -T $(LSCRIPT) --specs=nosys.specs

# Object copy (for converting formats)
OBJCOPY = arm-none-eabi-objcopy
OFLAGS = -O binary

#-{ Programming/Debugging Definitions }-----------------------------------------

# Flashing tool
FLASH = st-flash

FLASH_ADDR = 0x8000000

#-{ Build Rules }---------------------------------------------------------------

# Final binaries
BIN = $(BLD)/$(PROJECT).bin
ELF = $(BLD)/$(PROJECT).elf

#-- These rules for the finally binaries will usually not require modification

# Convert the ELF into binary format
$(BIN): $(ELF)
	$(OBJCOPY) $(OFLAGS) $^ $@

# Link all intermediate objects into a single executable
$(ELF): $(PROJECT_SRC) $(CORE_SRC) | $(BLD)
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
	rm -rf $(BLD)
