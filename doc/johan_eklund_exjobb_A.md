---
title: "Pre-study: Formal Verification of an HLS component"
date: 2021-01-07
subtitle: "Using open-source tools, VHDL and PSL"
titlepage: true
abstract: |
  Formal Verification of HLS components is a field that promises to help in
  producing more robust constructions by mathematically prove properties of the
  same. The technique has until recently been limited to proprietary tools, in
  this prestudy exploration and documentation of the current state of
  open-source tools are proposed.
---


# Requirement specification

The requirement specification for the pre-study is presented in @tbl:req_spec.

+--------------------------+---------------------------+------------+
| **Krav**                 | **Beskrivning**           | **Utfört** |
+--------------------------+---------------------------+------------+
| **Förstudie/startrapport |                           |            |
| (lägg även med detta i   |                           |            |
| slutrapporten)**         |                           |            |
+--------------------------+---------------------------+------------+
| F1                       | Startrapport              | JA         |
|                          |                           |            |
|                          | 1.  Sammanfattning        |            |
|                          |                           |            |
|                          | 2.  Beskriv vad projektet |            |
|                          | ska resultera i och       |            |
|                          | eventuellt bakgrund       |            |
|                          | till beslutet             |            |
|                          |                           |            |
|                          | 3.  En specifikation (kan |            |
|                          | ändras) som beskriver     |            |
|                          | systemet eller IP         |            |
|                          | komponenten som ska       |            |
|                          | levereras                 |            |
|                          |                           |            |
|                          | 4.  Beskriv vilka         |            |
|                          | komponenter som           |            |
|                          | kanske kommer att         |            |
|                          | återanvändas med          |            |
|                          | referenser. Undersök      |            |
|                          | även äldre                |            |
|                          | examensleveranser         |            |
|                          |                           |            |
|                          | 5.  Skissa på en HW och   |            |
|                          | en SW arkitektur          |            |
|                          |                           |            |
|                          | 6.  Beskriv hur den ska   |            |
|                          | verifieras och            |            |
|                          | valideras (kan ändras     |            |
|                          | under resans gång)        |            |
|                          |                           |            |
|                          | 7.  Aktivitets- och       |            |
|                          | tidplan för projektet     |            |
|                          | (se kursplanen hur        |            |
|                          | många dagar det är        |            |
|                          | beräknat till). Följ      |            |
|                          | upp tidplanen,            |            |
|                          | redovisa resultatet i     |            |
|                          | slutrapporten och         |            |
|                          | lönekostnaden. Lön är     |            |
|                          | 800 SEK/Tim               |            |
|                          |                           |            |
|                          | 8.  Om gruppen består av  |            |
|                          | flera studerande,         |            |
|                          | berätta vad du ska        |            |
|                          | göra för delar. Alla      |            |
|                          | i gruppen levererar       |            |
|                          | kopior av hela            |            |
|                          | projektet.                |            |
|                          |                           |            |
|                          | 9.  Max 5 sidor           |            |
+--------------------------+---------------------------+------------+
| **Konstruktions krav     |                           |            |
| (minimikrav)**           |                           |            |
+--------------------------+---------------------------+------------+
| F2                       | Krav på konstruktionen:   | N/A        |
|                          |                           |            |
|                          | \- minst en CPU           |            |
|                          |                           |            |
|                          | \- VGA (egenutvecklad),   |            |
|                          |                           |            |
|                          | \- Watchdog               |            |
|                          | (egenutvecklad)           |            |
|                          |                           |            |
|                          | \- Sierra eller något     |            |
|                          | annat OS                  |            |
|                          |                           |            |
|                          | \- en egen ny IP          |            |
|                          | komponent, ansluten till  |            |
|                          | bussen                    |            |
+--------------------------+---------------------------+------------+
| F4                       | All kod ska få plats på   | N/A        |
|                          | det interna RAM-minnet.   |            |
|                          | (kan få dispens)          |            |
+--------------------------+---------------------------+------------+
| F5                       | Kortet ska boota upp både | N/A        |
|                          | HW/SW automatiskt efter   |            |
|                          | spänningspåslag. (Just nu |            |
|                          | i skrivande stund är det  |            |
|                          | problem att boota upp med |            |
|                          | Sierra, så om Sierra      |            |
|                          | används behöver           |            |
|                          | konstruktören inte boota  |            |
|                          | upp systemet, 2020-12-14) |            |
+--------------------------+---------------------------+------------+
| F6                       | Startrapporten ska vara   | JA         |
|                          | en standardrapport.       |            |
|                          |                           |            |
|                          | Startrapporten ska        |            |
|                          | skickas till chefen före  |            |
|                          | projektstart för          |            |
|                          | godkännande. Leveransen   |            |
|                          | ska ske till plattformen  |            |
|                          | Itslearning. Namnet på    |            |
|                          | filen ska vara            |            |
|                          | "fornamn                  |            |
|                          | _efternamn_exjobb_A.zip". |            |
+--------------------------+---------------------------+------------+

:Requirement specification {#tbl:req_spec}


# Background

Formal verification can be described as follows [@wiki_formal_methods]:

>In computer science, specifically software engineering and hardware
>engineering, formal methods are a particular kind of mathematically rigorous
>techniques for the specification, development and verification of software and
>hardware systems. The use of formal methods for software and hardware design
>is motivated by the expectation that, as in other engineering disciplines,
>performing appropriate mathematical analysis can contribute to the reliability
>and robustness of a design.

Open-Source tools enabling formal verification of HDL modules has recently
become available, mainly as part of the **Yosys** [@yosys] synthesis tool,
while originally intended for use with **Verilog** and **System Verilog
Assertions**, but by combing these tools with the **GHDL** [@ghdl]
compiler/simulator modules written in **VHDL** can be formally verified using
**PSL**[@wiki_psl] instead.

The promise of formal verification is to secure designs by discovering bugs
that other methods such as testbench simulations might miss.


# Goals

The main goals of this project is twofold:

- Investigate and configure the available open-source tooling currently
  available for formal verification using **VHDL** and **PSL** ([@yosys], [@ghdl],
  [@symbiyosys]). Then using these tools to formally verify the **TEIS**
  VGA IP-component to the fullest extent possible in the time frame possible.
- Document the process as a reproducible CASE document, including a brief
  overview of the theory. Also to describe limitations and problems with the
  methodology.


# Project requirement specification

A proposed requirement specification is presented in @tbl:req_pro. This is to
be seen as minimum and time permitting expanded.

+--------------------+-------------------------------------------------------------------------------------+----+
| **Requirement ID** | **Description**                                                                     | OK |
+--------------------+-------------------------------------------------------------------------------------+----+
| **1**              | Report with theoretical background and summary of PSL, tooling.                     |    |
+--------------------+-------------------------------------------------------------------------------------+----+
| **2**              | A reproducible CASE document describing for formal verification of a VGA Component. |    |
+--------------------+-------------------------------------------------------------------------------------+----+
| **3**              | CASE shall include tooling setup.                                                   |    |
+--------------------+-------------------------------------------------------------------------------------+----+
| **4**              | CASE shall include a brief description of tools and PSL language used.              |    |
+--------------------+-------------------------------------------------------------------------------------+----+

:Requirement specification  {#tbl:req_pro}


# Time plan

In @tbl:time is outlined a time plan estimate for the project.

+-----------+-----------------------------------------------------------------------------+----------------------------+
| **Week**  | **Task**                                                                    | **Estimated Time (hours)** |
+-----------+-----------------------------------------------------------------------------+----------------------------+
| **1**     | Research into theory: formal methods and PSL.                               | 40                         |
+-----------+-----------------------------------------------------------------------------+----------------------------+
| **2**     | Tooling exploration, configuration and documentation, starting verification | 40                         |
+-----------+-----------------------------------------------------------------------------+----------------------------+
| **3**     | Formal verification of the VGA component                                    | 40                         |
+-----------+-----------------------------------------------------------------------------+----------------------------+
| **4**     | Finalizing report and case documentation                                    | 40                         |
+-----------+-----------------------------------------------------------------------------+----------------------------+
| **Total** |                                                                             | 160                        |
+-----------+-----------------------------------------------------------------------------+----------------------------+

:Time plan outline {#tbl:time}


# References

<div id="refs"></div>
