LAB4 - FPGA based Digital Design

The System Top Entity - 

INPUTS:
- signals `X`,`Y`
- control signal `ALUFN`
ALUFN[4:3] choose the selected module (01 : AdderSub ,10 : Shifter, 11 : Logic)
 and each module act differently with control of ALUFN[2:0].
- ENA, RST, CLK
-----------------------------------------------------------------------------------------------------------------
OUTPUTS: 
- Flags `Z`(Zero), `C`(Carry), `N`(Negative), `V`(Overflow)
 we can see the result of each of the flags on the light bulbs.
- ALUout - The system output according to the module selected.
- PWM 
-----------------------------------------------------------------------------------------------------------------
 AdderSub 
This module performs according to its ALUFN input. To do operation between 2 signals X, Y with equal lengths by FA. in addition, DEC/INC operation is performed on the Y signal, and NEG operation is performed on the X signal and zeros vector.
-----------------------------------------------------------------------------------------------------------------
Shifter
This module performs according to the ALUFN input a barrel-shifter-based shift, where if ALUFN[2:0] = 000 then we will shift to the left and if ALUFN[2:0] = 001 we will shift to the right.
-----------------------------------------------------------------------------------------------------------------
Logic
This module is required to perform various logical operations on the X, Y signals  according to ALUFN input that decide which logic-operation do considering the 3 last bits in ALUFN_i (ALUFN_i[2:0]).
ALUFN_i[2:0] = "000" its NOT(Y) ; ALUFN_i[2:0] = "001" its Y OR X ; ALUFN_i[2:0] = "010" its Y AND X ; ALUFN_i[2:0] = "011" its Y XOR X ; ALUFN_i[2:0] = "100" its Y NOR X ; ALUFN_i[2:0] = "101" its Y NAND X ; ALUFN_i[2:0] = "111" its Y XNOR X
-----------------------------------------------------------------------------------------------------------------
ALU
This module is the module that wraps the entire system, it receives the transition inputs and transfers them according to the appropriate module and classifies the outputs accordingly.
-----------------------------------------------------------------------------------------------------------------
SDC – synchronous digital circuit
This module is the module that performs with rise and fall of clock and dictating to the system when to extract the outputs including the PWN output.
-----------------------------------------------------------------------------------------------------------------
FullAdder
This module is the module that wraps the entire system. It's a digital circuit that performs addition of numbers.  use to assist the AdderSub component to calculate and execution all the operators.
-----------------------------------------------------------------------------------------------------------------
HEXdeocde
This module translate the signal from binary to hex
-----------------------------------------------------------------------------------------------------------------
PLL
This module block the clock instead of 50MHz to 2MHz
-----------------------------------------------------------------------------------------------------------------
GPIO
This module used in FPGA development. integrates multiple components to interact with switches (SW), keys (KEY), 7-segment displays (HEX), LEDs, and a PWM output. It also includes interaction with a top-level ALU module and decoders for 7-segment displays.


