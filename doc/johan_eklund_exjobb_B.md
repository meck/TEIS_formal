---
title: "Formal Verification of an HLS component"
date: TODO
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
| 1                         | Som är definierat i VHDL- |            |
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
| 3                         | Presentation av resultat; |            |
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


# Definitions

TODO

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

# Result

TODO


# Construction

TODO

# Analysis

TODO

# Conclusions

TODO

## Possible Improvements


TODO


# References

<div id="refs"></div>

# Attachments {-}

## Appendix A
