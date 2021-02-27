CC = ghdl
SIM = gtkwave
FORMAL = sby
WORKDIR = work

QUIET = @

# Name of top level (`.vhd`) file
ARCHNAME?= Counter

# Name of verification (`.sby`) file
VERNAME?= $(ARCHNAME)

STOPTIME= 100ms

VHDL_SOURCES = $(wildcard rtl/*.vhd)
TBS = $(wildcard sim/*_tb.vhd)
TB = sim/$(ARCHNAME)_tb.vhd
FORMAL_SBY = $(VERNAME).sby

CFLAGS += --std=08 # enable ieee 2008 standard
CFLAGS += -frelaxed
CFLAGS += --warn-binding
CFLAGS += --warn-no-library # turn off warning on design replace with same name

FORMALFLAGS += -f

all: check analyze
	@echo ">>> completed..."

.PHONY: check
check:
	@echo ">>> check syntax on all designs..."
	$(QUIET)$(CC) -s $(CFLAGS) $(VHDL_SOURCES) $(TBS)

.PHONY: analyze
analyze:
	@echo ">>> analyzing designs..."
	$(QUIET)mkdir -p $(WORKDIR)
	$(QUIET)$(CC) -a $(CFLAGS) --workdir=$(WORKDIR) $(VHDL_SOURCES) $(TBS)

.PHONY: run
run: analyze
	@echo ">>> simulating design:" $(TB)
	$(QUIET)$(CC) --elab-run $(CFLAGS) --workdir=$(WORKDIR) \
		-o $(WORKDIR)/$(ARCHNAME).bin $(ARCHNAME) \
		--vcd=$(WORKDIR)/$(ARCHNAME).vcd --stop-time=$(STOPTIME)

.PHONY: simulate
simulate: run
	@echo ">>> showing waveform for:" $(TB)
	$(QUIET)$(SIM) $(WORKDIR)/$(ARCHNAME).vcd & disown

.PHONY: formal
formal:
	@echo ">>> running formal verification:" $(VER)
	$(QUIET)cd formal;$(FORMAL) $(FORMALFLAGS) $(FORMAL_SBY)

.PHONY: clean
clean:
	@echo "cleaning design..."
	$(QUIET)rm -rf $(WORKDIR)
	$(QUIET)rm -rf -- formal/*/
