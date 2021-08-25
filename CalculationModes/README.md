# Example project: calcmodes1 
## _'How do I use PbGttReactor\'s CalcMode property?'_

The files in this repository correspond to the __SimuSage__ example project __\'calcmodes1\'__. It is intended to exemplarily demonstrate how the different calculation modes of the equilibrium reactor in __SimuSage__ can be operated.  

__SimuSage\'s__ equilibrium reactor PbGttReactor supports three different calculation modes:
- TempIn, which corresponds to the isothermal calculation mode
- EnthIn, which corresponds to the enthalpy difference (heat duty) target mode (temperature is the target variable) 
- VolIn, which corresponds to the total volume target mode (pressure is the target variable)

The example program shows how the CalcMode properties can be used interchangeably for one equilibrium reactor. 

A detailed step by step guide to this example project can be found in the __SimuSage V1 User\'s Manual__.  

Please notice that you need a valid Simusage installation to run the program. Please also notice that you need a "thermochemical data file" (.cst file) and a "Simusage stream definition file"(.ssd file) to run the model. These files can be constructed with the information supplied in the __SimuSage V1 User\'s Manual__.

If you have access to __SimuSage__ and you need help please make contact with GTT-Technologies by email (info@gtt-technologies.de).
