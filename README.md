# a2000Keyboard
## Amiga 2000 Mechanical Keyboard Clone

This project aims to create an Open Source Amiga 2000 keyboard. It is based on an Amiga 2000 Cherry keyboard. 

https://deskthority.net/wiki/Commodore_Amiga_2000

The PCB was cloned by Robert ( Peepo ) Taylor and TheBrew. Robert Taylor has kindly agreed to Open Source the Gerber files which he created. 

Once Printed and built, the PCB looks like this example. This one was built using Gateron Blue Switches. 

![The Assembled PCB with Gateron Blue Switche](withBlueSwitches.jpg)



The reconstructed keyboard looks like this:

![](reconstructed.JPG)





## Repo Contents

The Gerber files for the keyboard are in the zip file: **Cherry_v2_Gerbers.zip**. These Gerber files are for a clone of the original PCB only. They will be useful to you only if you wish to replace the PCB on your existing Cherry A2000 keyboard. 

The ROM images are in the romImages directory. You will need to burn these to an EPROM using a ROM burner such as a TL866II Plus. Use Intel 2732A @DIP24 as the IC type.

a2000CherryBOM.xlsx is the Bill Of Materials for this project. If you just wish to build a new PCB to replace a damaged PCB in an existing A2000 Cherry keyboard then you will not need all of the items in the Bill Of Materials. In fact, you will likely need only items from the first tab "From Mouser". You should be able to upload the BOM to Mouser using their import BOM tool. 

https://www.mouser.co.uk/bom/

