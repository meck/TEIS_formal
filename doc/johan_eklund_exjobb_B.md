---
title: "Construction of a CASE for formal verification"
date: 2021-06-26
subtitle: "Using open-source tools, VHDL and PSL"
titlepage: true
abstract: |
  TODO
---



# Requirement specification

The requirement specification for the pre-study is presented in
@tbl:req_spec_pre and the main requirement specification is presented in
@tbl:req_spec.

TODO

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
| **Förstudien slut (ska   |                           |            |
| godkännas före nästa     |                           |            |
| steg)**                  |                           |            |
+--------------------------+---------------------------+------------+

:Pre-study requirement specification {#tbl:req_spec_pre}


+---------------------------+---------------------------+------------+
| **Krav**                  | **Beskrivning**           | **Utfört** |
+---------------------------+---------------------------+------------+
| ***Konstruktionskod***    |                           |            |
+---------------------------+---------------------------+------------+
| 1                         | Som är definierat i VHDL- | JA         |
|                           | och C-kursen              |            |
+---------------------------+---------------------------+------------+
| ***Dokumentationskrav och |                           |            |
| struktur på mapparna***   |                           |            |
+---------------------------+---------------------------+------------+
| 2                         | Leverans med strukturerad |            |
|                           | standardrapport           |            |
|                           |                           |            |
|                           | 1.  Rapport (**OBS**      |            |
|                           |     filnamn:              |            |
|                           |     fo                    |            |
|                           | rnamn_efternamn_exjobb_B) |            |
|                           |                           |            |
|                           |     a.  Leverans i        |            |
|                           |         formatet Word,    |            |
|                           |         svenska eller     |            |
|                           |         engelska.         |            |
|                           |                           |            |
|                           |     b.  Max 30 sidor      |            |
+---------------------------+---------------------------+------------+
| 3                         | Presentation av resultat; | N/A        |
|                           | Skapa en film, max 10     |            |
|                           | minuter (lägg upp den på  |            |
|                           | Youtube),                 |            |
|                           |                           |            |
|                           | 1)  Introducera dig själv |            |
|                           |                           |            |
|                           | 2)  Översikt av projektet |            |
|                           |                           |            |
|                           | 3)  Visa HW/SW            |            |
|                           |                           |            |
|                           | 4)  Demonstrera systemet  |            |
|                           |                           |            |
|                           | 5)  Gärna slutsatser av   |            |
|                           |     projektet (vad var    |            |
|                           |     bra, problem med      |            |
|                           |     mera)                 |            |
|                           |                           |            |
|                           | 6)  Trevligt om taggen    |            |
|                           |     "TEIS" läggs till, då |            |
|                           |     blir det enkelt att   |            |
|                           |     få fram alla filmerna |            |
|                           |     från                  |            |
|                           |     TEIS-utbildningen.    |            |
|                           |                           |            |
|                           | Det finns inga krav på    |            |
|                           | kvalitén på filmen, men   |            |
|                           | det är bra träning att    |            |
|                           | presentera ett projekt    |            |
|                           | som är genomfört.         |            |
|                           |                           |            |
|                           | **OBS! Om du inte vill    |            |
|                           | att den ska publiceras,   |            |
|                           | skriv det tydligt efter   |            |
|                           | filmlänken.**             |            |
+---------------------------+---------------------------+------------+
| ***Leveranskrav***        |                           |            |
+---------------------------+---------------------------+------------+
| 4                         | Slutleveransen kan        |            |
|                           | innehålla följande mappar |            |
|                           | med följande dokument:    |            |
|                           |                           |            |
|                           | -   **[Mappen             |            |
|                           |     Dokumentation]{.ul}** |            |
|                           |                           |            |
|                           |     -   Rapporter         |            |
|                           |                           |            |
|                           |     -   Fristående        |            |
|                           |         bilagor som kod,  |            |
|                           |         kretsschema och   |            |
|                           |         datablad          |            |
|                           |                           |            |
|                           | -   **[Mappen             |            |
|                           |     Kons                  |            |
|                           | truktionsunderlag]{.ul}** |            |
|                           |                           |            |
|                           |     -   Arkiverat Quartus |            |
|                           |         projekt,          |            |
|                           |                           |            |
|                           |     -   IP-komponenter i  |            |
|                           |         en map            |            |
|                           |                           |            |
|                           | -   **[Mappen             |            |
|                           |     Ko                    |            |
|                           | nfigureringsfiler]{.ul}** |            |
|                           |                           |            |
|                           |                           |            |
|                           |    -   configuration.sof, |            |
|                           |         pof               |            |
|                           |                           |            |
|                           | -   **[Mappen             |            |
|                           |     Demoexempel]{.ul}**   |            |
|                           |                           |            |
|                           |     -   Kan vara en       |            |
|                           |         testarkitektur.   |            |
|                           |         Kan vara samma    |            |
|                           |         som testbenches.  |            |
|                           |                           |            |
|                           | -   **[Mappen             |            |
|                           |     Testbenches]{.ul}**   |            |
|                           |                           |            |
|                           |     -   SW program för    |            |
|                           |         att validera      |            |
|                           |         konstruktionen    |            |
|                           |                           |            |
|                           | -   **Mappen diverse**    |            |
|                           |                           |            |
|                           |     -   Datablad på       |            |
|                           |         kretsar med mera  |            |
|                           |                           |            |
|                           | Leveransen ska ske till   |            |
|                           | plattformen Itslearning.  |            |
|                           | Namnet på filen ska vara  |            |
|                           | "forn                     |            |
|                           | amn_efternamn_exjobb.zip" |            |
|                           | (en fil).                 |            |
+---------------------------+---------------------------+------------+
| 5                         | Leveransen bedöms ut      |            |
|                           | följande steg (kan vara i |            |
|                           | olika ordning):           |            |
|                           |                           |            |
|                           | -   VHDL                  |            |
|                           |                           |            |
|                           | -   C                     |            |
|                           |                           |            |
|                           | -   Arkitektur            |            |
|                           |                           |            |
|                           | -   Dokumentation         |            |
|                           |     (Tekniska rapporten)  |            |
|                           |                           |            |
|                           | Varje steg kan max 5      |            |
|                           | komplettering göras om    |            |
|                           | inte kunden (läraren)     |            |
|                           | anser något annat. Om     |            |
|                           | antalet kompletteringar   |            |
|                           | överstiger 5 gånger för   |            |
|                           | en granskning (t.ex.      |            |
|                           | VHDL), kräver kunden en   |            |
|                           | ny leverans av ett nytt   |            |
|                           | projekt.                  |            |
+---------------------------+---------------------------+------------+
| UK/G/VG                   | Betyg sätts utifrån en    |            |
|                           | samlad bedömning från de  |            |
|                           | som examinerar de olika   |            |
|                           | stegen.                   |            |
+---------------------------+---------------------------+------------+

:Requirement specification {#tbl:req_spec}


# Design requirement specification

The requirement specification for the project is shown in @tbl:req_pro

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


# Project plan

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

## Result

The work on the CASE document was halted mostly due to **LIA** related work
and some obstacles in the tooling, but was finished after the conclusion of the
**LIA**.

The total time budget was exceeded by approximately 10 hours, for a total of
170 hours. At a rate of **800 SEK** the project would incur a cost of **144000 SEK**


# Construction of CASE

## Preparatory research

The first part of the work consisted of studying and understanding the theory
behind the methods and tooling used. This work consisted of reading the
available documentation of the used tools and also some relevant blog posts
from people whom have used these tools, see @ghdl @yosys @symbiyosys
@yosys-ghdl @zipCpu_blog. 

Some studying of the PSL language was also undertaken using resources such as
@psl_doulos and @psl_tutorial


## Tooling setup

As the tooling involved consists of multiple Linux based programs some time was
spent configuring up a reproduceable environment to facilitate easy setup for
anyone wanting to run the examples in the CASE.


##  Examples

Next multiple examples was developed and explored for possible inclusion in the
CASE. The of including a formal verification of the TEIS VGA component was not
achieved due to issues explained a later chapter, It was replaced by a formal
verification example of the TEIS "Simple CPU"


### Counter Component

In order to demonstrate the basic functionally of the tools a simple example
with a generic counter component was developed. This shows some basic tool
setup and the basics of assertions and assumptions.


### TEIS VGA Component and Issues

One of the goals of the project was to formally verify the TEIS VGA Component.
However this proved difficult as the tooling (GHDL in particular) support for
multiple clocks was immature. This was investigated and reported to the GHDL
project [@ghdl_issue] and a initial fix was implemented, but to correctly use
multiple clocks further work is needed. For this reason further work this
example was canceled.



### TEIS Simple CPU Component

Instead of the VGA Component example another example using the "TEIS Simple
CPU" was constructed in order to show some more advanced features of the tools.


## Requirements

The partly completed requirement specification for the project is shown in
@tbl:req_com

+--------------------+-------------------------------------------------------------------------------------+--------+
| **Requirement ID** | **Description**                                                                     | OK     |
+--------------------+-------------------------------------------------------------------------------------+--------+
| **1**              | Report with theoretical background and summary of PSL, tooling.                     | OK     |
+--------------------+-------------------------------------------------------------------------------------+--------+
| **2**              | A reproducible CASE document describing for formal verification of a VGA Component. | Partly |
+--------------------+-------------------------------------------------------------------------------------+--------+
| **3**              | CASE shall include tooling setup.                                                   | OK     |
+--------------------+-------------------------------------------------------------------------------------+--------+
| **4**              | CASE shall include a brief description of tools and PSL language used.              | OK     |
+--------------------+-------------------------------------------------------------------------------------+--------+

:Completed requirement specification  {#tbl:req_com}


# Conclusions

This was a very interesting and challenging project, the goal of in the CASE
document include a formal verification of a VGA component was not reached
because of the issues described earlier.

The CASE document hopefully shows some advantages and disadvantages of the
technique of formal verification and is a description of the current state of
the open source tools.

The author hopes that the document might be used as starting point for anyone
interested in formal verification. 

## Possible Improvements

TODO

\pagebreak

# References {-}

<div id="refs"></div>
