# Example project: heatexchanger 
## _'How do I heat or cool a stream without changing its composition?'_

The files in this repository correspond to the __SimuSage__ example project __\'heatexchanger\'__. It is intended to exemplarily demonstrate how the heating and cooling of a stream can be performed with __SimuSage__ without changing its composition. 

Furthermore, two modes are introduced for the unit operation for the heating and cooling of a stream: 
- In the TempIn mode the temperature of the output stream has to be provided based on which the enthalpy difference "output" minus "input" is determined.
- In the EnthIn mode the enthalpy difference is set, and the temperature is calculated iteratively.

A detailed step by step guide to this example project can be found in the __SimuSage V1 User\'s Manual__.  

Please notice that you need a valid Simusage installation to run the program. Please also notice that you need a "thermochemical data file" (.cst file) and a "Simusage stream definition file"(.ssd file) to run the model. These files can be constructed with the information supplied in the __SimuSage V1 User\'s Manual__.

If you have access to __SimuSage__ and you need help please make contact with GTT-Technologies by email (info@gtt-technologies.de).
