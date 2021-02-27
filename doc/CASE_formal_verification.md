---
title: "Formal Verification of HDL designs"
date: TODO
subtitle: "Using VHDL, PSL and open-source tools."
titlepage: true
header-includes: |
    \usepackage{sectsty}
    \sectionfont{\clearpage}
abstract: |
  TODO
---

# Background

The promise of formal verification is to be able to mathematically prove
aspects about a design. These methods can be applied to a design either in a
construction phase in order to find bugs or as a verification of a completed
design. Formal verification can be used both as a complement to verification
using test benches or in some cases as a replacement.


In a hand-wavy way the process can be compared to traditional test benches in
the following way; When writing a test bench the designer writes codes that
defines the input and checks if the output is correct, when constructing a
formal proof the designer writes code that defines the output, and the tools
checks if output is correct.


Formal verification has until recently required proprietary and expensive
software. Recent advances in some open-source software has lowered the entry
barrier greatly, some of these tools are connected to other FPGA open-source
project^[synthesis, place and route and bitstream generation]. Many of these
projects primary use Verilog as the HDL of choice, however this project looks
at using the tools with VHDL.

The HDL language chosen needs to be augmented with another language to
accurately be able to describe the temporal aspects of the design for the
verification tools. For this chosen the PSL language as seems to be the option
most closely related to VHDL.


It should be noted that the author is a beginner and this an exploration and
**not authoritative knowledge** in any way. The methods described is also only
one of many possible techniques for formal verification.


# Theory

A HDL design after synthesis can be viewed in its whole as a Finite State
Machine, completely represented by its current state and all its
inputs^[including any clock] as transitions. This then represent all possible
states of a design, probably only some of these states are **valid states**
where the design works as expected, this is implicit, this state space will
also contain the designs **initial** state.

By **asserting** certain aspects of a design e.g.:

- The output `foo` **shall** never have a value higher then $50$.
- The output `bar` **shall** only ever be high for one cycle at a time.

Some of the possible states, where any of these things happens, can then be
marked as **invalid states**, this is shown in @fig:st_1.

![States](states_1.png){#fig:st_1 width=6cm}

Further it can be **assumed** aspects about the design, I.e thing that will
never or always happen:

- The input `baz` **will** only be high at the same time as input `zot`.
- The input `blarg` **will** always be high after `fum` has been low for two
  cycles.

The result of an assumption is that corresponding states are removed from
possible states, as shown in @fig:st_2.

![Assumed states](states_2.png){#fig:st_2 width=6cm}

The goal of writing a formal proof is by **asserting** to make sure any
transition from a valid is either to a implicit valid state or a explicit
invalid state, **not** to a possible, undefined state. And by **assuming**
shrinking the possible state space until only valid and invalid states remain,
see @fig:st_3

![Goal](states_3.png){#fig:st_3 width=4cm}

It might be thought that it is enough to assert that all transitions from a
valid state to a possible (but not invalid) state might be enough, but for the
second step of the prof ($z$-induction), all possible steps must be considered.
Although the first part may be valuable in itself.



## Step 1: BMC

**B**ounded **M**odel **C**heck is the first part of the formal proof. The
solver starts out in the initial state of the design and steps the logic
forward from there a certain number of steps $k_{bmc}$ (also referred to as the
depth of the proof). I.e it checks a branching tree of states to see that we
don't enter an invalid state, see @fig:bmc_1. This proves that **no invalid
state is reachable within $k_{bmc}$ steps.** However it says nothing about the
what might happen after that ($k_{bmc}+1$ or $k_{bmc}+n$), in practice this
step turns out to often be able to find many bugs in itself. Increasing $k$
makes the operation exponentially larger, so to be able to prove the design
will never enter a invalid state the next step is used.

![Successfull BMC](bmc_1.png){#fig:bmc_1 width=4cm}


## Step 2: $k$-induction

This part can be illustrated in the following way, The solver looks at the
states that are asserted and invalid, from there it steps "backward" to see if
it will reach an invalid stage within $k_{ind}$ cycles @fig:ind_1. If this
holds for all invalid states, this means that **when starting from any valid
state the following $k_{ind}$ states will always be valid**.

![Successfull induction](ind_1.png){#fig:ind_1 width=4cm}

## Combining step 1 and 2

The matter of combining these two steps is the application of mathematical
induction[@wiki_ind], where there is a series of statements $P(n)$:

1. Prove that $P(0)$ is true, this is a "base case".
2. Prove that $P(n+1)$ is true, this is a induction step.
3. Combining these: If $P(0)$ leads to $P(0+1)$ leads to $P(0+1+1)$ etc. This
   means that all $P(n)$ where $n \geq 0$ are true.

This is what the tools does; BMC is the base case, the induction step is then
done with $k_{bmc} \leq k_{ind}$, if this passes the following is known:

1. **no invalid state is reachable within $k_{bmc}$ steps**
2. **when starting from any valid state the following $k_{ind}$ states will always be valid**
3. this means that $k_{bmc} + 1$ must be valid and recursively also $k_{bmc} +
   1 + 1$ etc. So all states reachable^[all possible states excluding assumed
   invalid states] from the initial state must be valid, I.e. **the design
   will never enter a invalid state.**


## Workflow

The main workflow for these tools can be summarized:

1. **Run Bounded Check**
   + `FAIL` $\Rightarrow$ Fix design, add assumptions, or loosen asserts
   + `PASS` $\Rightarrow$ So far so good. Proceed to step 2

2. **Run Induction Proof**

   + `FAIL` $\Rightarrow$ Investigate the produced counterexample: Is it reachable?

      * `REACHABLE` $\Rightarrow$ Fix design, add assumptions, or loosen asserts
      * `UNREACHABLE` $\Rightarrow$ Add restrictions, strengthen asserts,or increase induction length

   + `PASS` $\Rightarrow$ Do you want more asserts in your design?

      * `YES` $\Rightarrow$  Reduce induction length or remove restrictions.
      * `NO` $\Rightarrow$ You are done.

### Assert/Assume

When constructing a formal proof for a design the main tools are **assertions**
and **assumptions**. The rule for how to use these are if the design is viewed
from the top level:

   - **Assert outputs and internal state** The description of the correct
     functionality of the design.
   - **Assume inputs** Remove inputs that are known to never happen.
     If to much is assumed, the design might pass and still
     have errors^[Or the saying "Assumptions are the mother of all F***ups"].

### Depth

TODO depth inportance



# Property Specification Language

**P**roperty **S**pecification **L**anguage [@wiki_psl] is a _temporal logic_
i.e. a language designed for expressing logic over time easily. This is what
will be used to formulate verifications.

Here follows a short introduction to PSL, further concepts will be introduced
as needed, other sources are [@vhdl_konst, ch. 13; @psl_doulos; @psl_tutorial].

## Syntax

**A PSL statement has the following form:**

```{.vhdl}
assert always CONDITION;
```


**Usually only asserted at an associated clock edge:**

```{.vhdl}
assert always CONDITION @(rising_edge(clk));
-- Or using a default clock
default Clock is rising_edge(clk);
assert always CONDITION;
```

**An assertion can be conditional:**

```{.vhdl}
assert always PRECONDITION -> CONDITION;
```

"`assert`" is a directive, the following are available
:   `assert` Assert the following holds
:   `assume` Assume the following holds
:   `restrict` Like Assume, but behaves differently when simulating in some tools
:   `cover` Specifically check that following state is reachable



"`always`" is a temporal operator, i.e. when should the condition hold, the most common ones are:
:   `always` must always hold
:   `never` shall never hold


---

**There is also "SERE" syntax:**

```{.vhdl}
{CONDITION_A;CONDITION_B}
```

`CONDITION_A` refers to something in the current cycle and `CONDITION_B`
something in the following cycle. These can be modified further e.g.
`{a[*5];b;c}` means `a` must hold for 5 cycles, then `b` for one cycle and then
`c` for one cycle.

SERE also includes the operators `|->` and `|=>`

```{.vhdl}
{a;b} |-> {c}
{x} |=> {y}
```

This means that `a` and a consecutive `b` implies `c` in the **same cycle** as
`b` and means that `x` implies `y` in the **next cycle**.

## Examples

As an example the statements from the previous chapter could be expressed using
PSL in as follows, notice that the examples follows the rule of asserting
output and assuming inputs:


- **The output `foo` *shall* never have a value higher `50`**.

    ``` {.vhdl}
    assert always (foo <= 50);
    -- or
    assert never (foo > 50);
    ```

- **The output `bar` *shall* only ever be high for one cycle at a time, `next`
here refers to the next cycle.**

    ```{.vhdl}
    assert always bar = '1' -> next bar = '0';
    -- or
    assert always bar -> next not bar;
    -- or
    assert always {bar} |=> {not bar};
    ```

- **The input `baz` *will* only be high at the same time as input `zot`.**

    ```{.vhdl}
    assume always baz -> zot;
    -- or
    assume always {baz} |-> {zot};
    ```


- **The input `blarg` *will* always be high after `fum` has been low for two
cycles.**

    ```{.vhdl}
    assume always {(fum = '0')[*2]} |=> {blarg};
    ```


## PSL and VHDL

PSL is available in "flavors" for use with both VHDL and Verilog, this document
uses the VHDL flavor. An common alternative  to PSL is "**S**ystem **V**erilog
**A**ssertions" for System Verilog, which is the primary use case for some of
the tools mentioned below^[SVA can also be made to work with VHDL but this
requires extra proprietary tools.].

The PSL code can be connected to the VHDL code in one of three ways:

 - **As comments:** This places the PSL code in the same file as the VHDL code
   but in comments starting with `-- psl`. An advantage is that unsupported
   tools just ignores these statements. e.g.

      ```{.vhdl}
      -- psl assert always bar -> next not bar;
      ```

 - **Inline:** The VHDL 2008 Standard supports PSL directly in VHDL code, this
   can be combined with a generic generate statement to optionally toggle the
   code.

      ```{.vhdl}
      formal_g : if g_doFormal generate
      begin
         psl assert always bar -> next not bar;
      end generate;
      ```

 - **Vunit**: In a separate file as so called vunit, this brings the PSL code
   into to the same scope as entity that is being tested.



# Tools

## SymbiYosys

From [@symbiyosys]:

>SymbiYosys (sby) is a front-end driver program for Yosys-based formal hardware
>verification flows. SymbiYosys provides flows for the following formal tasks:
>
> - Bounded verification of safety properties (assertions)
  - Unbounded verification of safety properties
  - Generation of test benches from cover statements
  - Verification of liveness properties

This is the main program used in the verification process, its main function is
to orchestrate the other programs to a easy to handle interface. Setup is done
with `.sby` files that describes and runs the verification flow.


## Yosys

**Yosys** [@yosys] is an open-source synthesis tool/framework with built in
functions for formal verification. Normally takes Verilog code as input,
however when built with `ghdl-yosys-plugin` it uses `GHDL` to input VHDL and
synthesize this to native netlists.


## GHDL

From [@ghdl]:

> GHDL is an open-source analyzer, compiler, simulator and (experimental)
synthesizer for VHDL, a Hardware Description Language (HDL). GHDL is not an
interpreter: it allows you to analyse and elaborate sources to generate machine
code from your design. Native program execution is the only way for high speed
simulation.

GHDL is a very versatile tool, with many uses. For the formal verification
herein it is used mainly as library to compile/synthesize VHDL designs
including PSL to a netlist that is compatible with the Yoys tool.

## ghdl-yosys-plugin

A plugin [@yosys-ghdl] for Yosys that enables synthesis of VHDL input using
GHDL.


## z3, avy, boolector, smtbmc etc.

Different SMT engines [@wiki_smt], they are called by SymbiYosys to do the
heavy lifting of checking the whether the assertion and assumptions holds. They
have different advantages and disadvantages, so which one to use for a certain
design might differ.


## Prerequisites

The tools used throughout this example are command line based Linux
applications, so some familiarity with a command line environment^[The examples
uses `bash`] is assumed.


#### Operating system

The tool are Linux based but the workflow is possible to run on other systems:

- **Linux:** Any recent Linux distribution should be usable.
- **Windows 10:** Using 'Windows Subsystem for Linux', its recommended to use a
  up to date Windows10 and WSL2:
  [`docs.microsoft.com/en-us/windows/wsl/install-win10`](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
- **macOS:** Using the nix method described below this should be possible as well, but is
  not verified. TODO


#### Optional

- `Git` if the project is to be fetched from GitHub, alternatively use the
  attached files, this is included by default in most Linux distros and WSL.
- `GtkWave` a Linux waveform viewer for visualising the output from the tools
  [`gtkwave.sourceforge.net`](http://gtkwave.sourceforge.net/),
  ModelSim includes the `vcd2wlf` utility, this can be used to view resultant
  waveforms in ModelSim instead.


## Installation

TODO mention docker setup

### Nix setup

In order to facilitate easy installation of the required software a custom
setup using the **Nix**^[Nix is among other things a package manager that
allows setting up a per project shell environment that is independent of the
operating system] package manager[@nix_web] has been constructed along with
examples in this guide. This consist of the `.nix` files in TODO directory.
This is also made available as GitHub repository TODO.

These files declaratively describes a shell environment using working versions
of all required software, **Nix** is a completely separate subject, but this
should make the installation which is fairly advanced possible for users with
limited knowledge.


1. At the time of writing nix can be installed as follows (but check the
   website for any updates), then follow the instructions:

      ``` .bash
      $ curl -L https://nixos.org/nix/install | sh
      ```

2. Download the examples and nix setup, or skip this and copy the attached
   files:

      ``` .bash
      $ git clone TODO
      ```

3. Enter the project directory can then be entered

      ``` .bash
      $ cd TODO/TODO
      ```

4. Start the Nix environment with the following command ^[This might take a while the first time,
some parts are fetched and some are built from source]:

      ``` .bash
      $ nix-shell
      ```

5. Now the tools should be executable:

      ``` .bash
      $ ghdl --version
      GHDL 1.0-dev () [Dunoon edition]
       Compiled with GNAT Version: 9.3.0
       llvm code generator
      Written by Tristan Gingold.
      ...

      $ yosys --version
      Yosys 0.9+3830 (git sha1 b72c294653, g++ 10.2.0 -fPIC -Os)
      ...

      $ sby --help
      usage: sby [options] [<jobname>.sby [tasknames] | <dirname>]
      ...
      ```

A alternative way of simplifying setting up a environment is by use of docker
containers ,this is not covered here, but for anyone interested containers are
available at
[`https://hdl.github.io/containers/`](https://hdl.github.io/containers/).


# Example 1: Counter

The first example is the formal verification of simple counter, the complete
code can be seen in the appendix, the entity and main process is:

```{.vhdl include=../code/hdl/counter.vhd startLine=5 endLine=18}
```

```{.vhdl include=../code/hdl/counter.vhd startLine=27 endLine=44}
```

The PSL statement are wrapped as a VHDL `generate` section controlled by a
generic option, this makes disabling the checks easy when using synthesizing
for hardware etc.

## `.sby` file

To be able to do a formal verification SymbiYosys needs a `.sby` file script
this is located in TODO folder and looks as follows, the file is described in
the comments, the complete syntax is described at the SymbiYosys website
@symbiyosys:

```{.ini include=../code/formal/counter.sby}
```

Now the tools can be tested, as nothing about the design has been asserted, it
should pass both the BMC and induction step, this is run from the `formal`
folder:

```{.bash}
$ cd formal
$ sby -f counter.sby
...
[counter] engine_0: Status returned by engine for basecase: pass
[counter] summary: Elapsed clock time [H:MM:SS (secs)]: 0:00:00 (0)
[counter] summary: Elapsed process time [H:MM:SS (secs)]: 0:00:00 (0)
[counter] summary: engine_0 (smtbmc z3) returned pass for induction
[counter] summary: engine_0 (smtbmc z3) returned pass for basecase
[counter] summary: successful proof by k-induction.
[counter] DONE (PASS, rc=0)
```

And it passes, all files generated by the verification tools are located in the
`counter` directory, note the `-f` when running `sby` is needed to overwrite
this directory directory on subsequent runs. If the verification fails a wave
file is generated located in this directory^[A Verilog testbench with a
counterexample is also generated in case of failure].


## Assertions and assumptions

### Saturation

Now we can start to add assertions, firstly we add a default clock then we
assert that the counter should not change when saturated, The `stable()`
function checks that a signal has not changed since the previous cycle:

```{.vhdl}
 default clock is rising_edge(clk);

 high_stable : assert always up and unsigned(count_out) = to_unsigned(high_val, 32) ->
   next stable(count_out);
 low_stable : assert always not up and unsigned(count_out) = to_unsigned(low_val, 32) ->
   next stable(count_out);
```

If we now rerun `SymbiYosys`:

```{.bash}
$ sby -f counter.sby
...
[counter] summary: engine_0 (smtbmc z3) returned FAIL for basecase
[counter] summary: counterexample trace: counter/engine_0/trace.vcd
[counter] DONE (FAIL, rc=2)
```

Failure? Let's open the counterexample^[If using GtkWave: "`gtkwave
counter/engine_0/trace.vcd &`"] and look at the trace (@fig:c1):

![Counter Fail](count_fail_1.png){#fig:c1 width=4cm}

The verification failed because the assertions don't hold when the reset goes
low, this is expected behavior, to handle case this the `abort` qualifier can
be added to the statements making the tool disregard this assertion if a
`reset_n` goes low:

```{.vhdl}
 high_stable : assert always up and unsigned(count_out) = to_unsigned(high_val, 32) ->
   next stable(count_out) abort not reset_n;
 low_stable : assert always not up and unsigned(count_out) = to_unsigned(low_val, 32) ->
   next stable(count_out) abort not reset_n;
```

This fixes the problem:

```{.bash}
$ sby -f counter.sby
...
[counter] DONE (PASS, rc=0)
```

### Enable signal

Next we add an assertion regarding the `enable` signal, whenever `enable` is
low the output shall remain unchanged. `until_` is a operator that means that
the condition shall hold until the right hand condition is met. The underscore
suffix means that the cycle when enable goes high should be included, there is
a corresponding `until`. This is common pattern in PSL functions.

```{.vhdl}
  disable_stable : assert always
    not enable -> next (stable(count_out) until_ enable) abort not reset_n;
```

### Increment/Decrement

The next section asserts that the output counts up and down as it should. The
`prev()` function references the signal value of the previous cycle, since the
right hand side of the implies operator (`->`) starts with `next` the `prev()`
refers to the cycle when the left side condition was true ie. the previous
cycle.

```{.vhdl}
count_up : assert always
  reset_n and up and enable and unsigned(count_out) < to_unsigned(high_val, 32) ->
    next unsigned(count_out) = unsigned(prev(count_out)) + 1
      abort not reset_n;

count_down : assert always
  (reset_n and (up = '0')) and enable and unsigned(count_out) > to_unsigned(low_val, 32) ->
    next unsigned(count_out) = unsigned(prev(count_out)) - 1
      abort not reset_n;
```

### Reset

What should happen when the reset goes low? The output should be reset to the
initial `low_val` generic. And since the output is registered it should stay
the same for one more cycle, notice the use of the SERE operators `|->` and
`[*2]` to describe exactly this:

```{.vhdl}
reset_output : assert always
 reset_n = '0' |-> {(unsigned(count_out) = to_unsigned(low_val,32))[*2]};
```

Verification still passes with these new assertions:

```{.bash}
$ sby -f counter.sby
...
[counter] DONE (PASS, rc=0)
```

### Minimum and maximum

Let's assert the minimum and maximum value of the output:

```{.vhdl}
valid_range : assert always
   unsigned(count_out) >= to_unsigned(low_val,32) and
   unsigned(count_out) <= to_unsigned(high_val,32);
```

However this fails, lets investigate:

```{.bash}
$ sby -f counter.sby
...
[counter] DONE (FAIL, rc=2)
```

If we look at the trace @fig:c2 we see that the counter **starts** with a value
of 18 (`>high_val`). This shows an important point, the tools checks all
possible values, including **all possible initial states** and nothing has been
said about the initial state. So the solver starts in invalid (but not
asserted/assumed state).

![Counter Fail](count_fail_2.png){#fig:c2 width=4cm}

One way to solve this is to assign the counter a default value:

```{.vhdl}
signal count : natural range low_val to high_val := low_val;
```

However this might not correspond to what will happen in hardware. Instead we
might make an **assumption** that the design with always start with a reset:

```{.vhdl}
initial_reset : assume {{not Reset_n[+]; Reset_n[+]}[+]};
```

The SERE operator "`[+]`" means that the preceding statement should hold for
one or more cycles. So the assumption is that `reset_n` will be low for one or
more cycles, then high for one or more cycles, this whole sequence might be
repeated one or more times.

```{.bash}
$ sby -f counter.sby
...
[counter] DONE (PASS, rc=0)
```

## Artificial error

If we introduce a not so subtle error in the main process the verification
fails and we can see this represented in the waveform (@fig:c3):

```{.vhdl}
 -- count <= count + 1;
 if count /= 10 then count <= count +1; else count <= 7; end if;
```

![Counter Fail](count_fail_3.png){#fig:c3 width=8cm}


## Summary

TODO

# Example 2: TODO


# Example 3: TODO


# Remarks

TODO


# References

::: {#refs}
:::

# Appendix {-}

## A. Counter {-}

```{.vhdl include=../code/hdl/counter.vhd}
```

