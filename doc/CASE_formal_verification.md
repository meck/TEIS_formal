---
title: "CASE: Formal Verification of an HLS component"
date: TODO
subtitle: "Using open-source tools, VHDL and PSL"
titlepage: true
abstract: |
  TODO
---

# Background

TODO


# Theory

The promise of formal verification is to be able to mathematically prove
aspects about a construction. These methods can be applied to a design either
in a construction phase in order to find bugs or as a verification of a
completed design. It should be noted that the author is a beginner and this an
exploration and **not authoritative knowledge** in any way. The methods
described is only one of many possible techniques for formal verification.

## Formal Verification.

A HDL design after synthesis can be viewed in its whole as a Finite State
Machine, completely represented by its current state and its inputs^[including
any clock and reset signals] as transitions. This can then represent all
possible states of a design, probably only some of these states are **valid
states** where the design works as expected, this is implicit, this state space
will also contain the designs initial state.

By **asserting** certain aspects of a design. I.e:

- The output `foo` **shall** never have a value higher `50`.
- The output `bar` **shall** only ever be high for one cycle at a time.

Some of the possible states, where any of these things happens, can then be
viewed as **invalid states**, this is shown in @fig:st_1.

![States](states_1.png){#fig:st_1 width=6cm}

Further it can be **assumed** aspects about the design, I.e thing that will
never happen:

- The input `baz` **will** only be high at the same time as input `zot`.
- The input `blarg` **will** always be high after `fum` has been low for two
  cycles.

The result of an assumption is that corresponding states are removed from
possible states, as shown in @fig:st_2.

![Assumed states](states_2.png){#fig:st_2 width=6cm}

The goal is by **asserting** to make sure any transition from a valid is either
to a implicit valid state or a explicit invalid state, **not** to a possible,
undefined state. And by **assuming** shrinking the possible state space until
only valid and invalid states remains, see @fig:st_3

![Goal](states_3.png){#fig:st_3 width=4cm}

It might be thought that it is enough to assert that all transitions from a
valid state to a possible (but not invalid) state might be enough, but for the
second step of the prof ($z$-induction), all possible steps must be considered.
Although the first part may be valuable in itself.


## PSL

**P**roperty **S**pecification **L**anguage [@wiki_psl] is _temporal logic_
i.e. a language constructed for expressing logic over time easily. It is
available in "flavors" for both VHDL and Verilog, this document uses the VHDL
flavor.

An alternative is "**S**ystem **V**erilog **A**ssertions" for System Verilog,
which is the primary use case for some of the tools mentioned below^[SVA can
also be made to work with VHDL but requires extra proprietary tools.].

A PSL statement has the following form:

```{.text}
assert always CONDITION;
```

Checked at an associated clock edge:

```{.text}
assert always CONDITION @(rising_edge(clk));
```

Or a default clock:

```{.text}
default Clock is rising_edge(clk);
assert always CONDITION;
```

And the check can be conditional:

```{.text}
assert always PRECONDITION -> CONDITION;
```


`assert` is a directive, can be `assert`, `assume`, `cover` or `restrict` the
first two should be familiar. `always` is a "temporal operator" i.e when the
most common ones are `always` and `never`.

There is also "**SERE**" syntax where `{CONDITION_A;CONDITION_B}` means that
`CONDITION_A` refers to something in the first cycle and `CONDITION_B`
something in the following cycle. This also includes the operators `|->` and
`|=>` where `{a;b} |-> {c}` means that `a` and a consecutive `b` implies `c` in
the **same cycle** as `b`.

`{a} |=> {b}` means that `a` implies `b` in the **next cycle**

These can be modified further `{a[*5]}` means `a` repeated for 5 cycles

If we look at the aspects from the previous chapter:


- The output `foo` **shall** never have a value higher `50`.

    ```{.text}
    assert always (foo <= 50);
    or
    assert never (foo > 50);
    ```


- The output `bar` **shall** only ever be high for one cycle at a time, `next`
  here refers to the next cycle.

    ```{.text}
    assert always bar = '1' -> next bar = '0';
    or
    assert always bar -> next not bar;
    ```

- The input `baz` **will** only be high at the same time as input `zot`.

    ```{.text}
    assume always baz -> zot;
    ```

- The input `blarg` **will** always be high after `fum` has been low for two
  cycles.

    ```{.text}
    assume always {(fum = '0')[*2]} |=> {blarg};
    ```

This is just a short introduction to **PSL**, further concepts will be
introduced as needed. Some other sources are TODO TODO.

## BMC

TODO


## $k$-induction

TODO


# Tools

## `Yosys`

TODO

## `SymbiYosys`

TODO

## `z3`, `avy`, `boolector` etc.

TODO

## `GHDL`

TODO

## `ghdl-yosys-plugin`

TODO


### Prerequisites

#### Operating system

The tools used throughout this example are command line based Linux
applications but is possible to run them on multiple systems:

- **Linux:** Any recent Linux distribution should be usable.
- **Windows 10:** Using 'Windows Subsystem for Linux'
- **macOS:** Using the nix method described below this should be possible as well, but is
  not verified.

https://docs.microsoft.com/en-us/windows/wsl/install-win10
Any recent Linux distribution should be usable.


open-source tools used are intended to run on Linux,

#### Optional

- `Git` if the project is to be fetched from GitHub, alternatively use the
  attached files.
- `GtkWave` a Linux waveform viewer for visualising the output from the tools,
  ModelSim can be used as a alternative, (TODO investigate this)


## Installation


### Nix setup

In order to facilitate easy installation of required software a custom setup
using the **Nix**^[Nix is among other things a package manager that allows
setting up a per project shell environment that is independent of the operating
system] package manager[@nix_web] has been prepared. This consist of the `.nix`
files in TODO directory. This is also made available as GitHub repository TODO.

These files declaratively describes a shell environment using working versions
of all required software, **Nix** is a completely separate subject, but this
should make the installation which is fairly advanced possible for users with
limited knowledge.


At the time of writing nix can be installed as follows (but check the website
for any updates), then follow the instructions:

``` .bash
$ curl -L https://nixos.org/nix/install | sh
```


The TODO directory can then be entered

``` .bash
$ cd <location of attched files>/TODO
```

**or** cloned from GitHub:

``` .bash
$ git clone TODO
$ cd TODO/TODO
```


The environment can then be invoked^[This might take a while the first time,
some parts are fetched and some are built from source]:

``` .bash
$ nix-shell
```

Now the tools should be executable:

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


TODO


# Formal verification of TEIS VGA IP

TODO


# Remarks

TODO


# References

<div id="refs"></div>

# Attachments {-}

## Appendix A
