% ------------------------------------------------------------------------------------ %
% Copyright (c) 2014 Varnerlab,  
% School of Chemical and Biomolecular Engineering,  
% Cornell University, Ithaca NY 14853 USA. 
% - 
% Permission is hereby granted, free of charge, to any person obtaining a copy 
% of this software and associated documentation files (the "Software"), to deal 
% in the Software without restriction, including without limitation the rights 
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
% copies of the Software, and to permit persons to whom the Software is  
% furnished to do so, subject to the following conditions: 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software. 
% - 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
% THE SOFTWARE. 
% ------------------------------------------------------------------------------------ %
function DF = DataFile(TSTART,TSTOP,Ts,INDEX)
% ---------------------------------------------------------------------- %
% DataFile.m was generated using the UNIVERSAL code generation system.
% Username: 
% Type: MASS_ACTION_MODEL 
% 
% Arguments: 
% TSTART  - Time start 
% TSTOP  - Time stop 
% Ts - Time step 
% INDEX - Parameter set index (for ensemble calculations) 
% DF  - Data file instance 
% ---------------------------------------------------------------------- %

% Stoichiometric matrix --
STM = load('./network/Network.dat');

% Parameters list --
kV = [
	 1.0	;	 %  1 k_1 C3 --> C3-H20
	 1.0	;	 %  2 k_2 C3-H20 --> C3
	 1.0	;	 %  3 k_3 C3-H20+FactorB --> C3-H20-FB
	 1.0	;	 %  4 k_4 C3-H20-FB --> C3-H20+FactorB
	 1.0	;	 %  5 k_5 C3-H20-FB+FactorD --> C3-H20-FB-FD
	 1.0	;	 %  6 k_6 C3-H20-FB-FD --> C3-H20-FB+FactorD
	 1.0	;	 %  7 k_7 C3-H20-FB-FD --> C3Bb-H20+FactorD
	 1.0	;	 %  8 k_8 C3Bb-H20+C3 --> C3Bb-H20-C3
	 1.0	;	 %  9 k_9 C3Bb-H20-C3 --> C3Bb-H20+C3a+C3b
	 1.0	;	 %  10 k_10 C3Bb-H20 --> C3-H20+Bb
	 1.0	;	 %  11 k_11 C3-H20+Bb --> C3Bb-H20
	 1.0	;	 %  12 k_12 C3b+S --> C3b-S
	 1.0	;	 %  13 k_13 C3b-S --> C3b+S
	 1.0	;	 %  14 k_14 C3b-S+FactorB --> C3b-S-FB
	 1.0	;	 %  15 k_15 C3b-S-FB --> C3b-S+FactorB
	 1.0	;	 %  16 k_16 C3b-S-FB+FactorD --> C3b-S-FB-FD
	 1.0	;	 %  17 k_17 C3b-S-FB-FD --> C3b-S-FB+FactorD
	 1.0	;	 %  18 k_18 C3b-S-FB-FD --> C3bBb-S+FBF+FactorD
	 1.0	;	 %  19 k_19 C3bBb-S+FactorP --> C3bBb-S-FP
	 1.0	;	 %  20 k_20 C3bBb-S --> C3b-S+Bb
	 1.0	;	 %  21 k_21 C3b-S+Bb --> C3bBb-S
	 1.0	;	 %  22 k_22 C3bBb-S --> C3bBb+S
	 1.0	;	 %  23 k_23 FactorP+S --> FP-S
	 1.0	;	 %  24 k_24 FP-S --> FactorP+S
	 1.0	;	 %  25 k_25 C3b+FP-S --> C3b-FP-S
	 1.0	;	 %  26 k_26 C3b-FP-S --> C3b+FP-S
	 1.0	;	 %  27 k_27 C3b-FP-S+FactorB --> C3b-FP-S-FB
	 1.0	;	 %  28 k_28 C3b-FP-S-FB --> C3b-FP-S+FactorB
	 1.0	;	 %  29 k_29 C3b-FP-S-FB+FactorD --> C3b-FP-S-FB-FD
	 1.0	;	 %  30 k_30 C3b-FP-S-FB-FD --> C3b-FP-S-FB+FactorD
	 1.0	;	 %  31 k_31 C3b-FP-S-FB-FD --> C3bBb-S-FP+FactorD+FBF
	 1.0	;	 %  32 k_32 C3bBb-S-FP+C3 --> C3-C3bBb-S-FP
	 1.0	;	 %  33 k_33 C3-C3bBb-S-FP --> C3bBb-S-FP+C3
	 1.0	;	 %  34 k_34 C3-C3bBb-S-FP --> C3b+C3a+C3bBb-S-FP
	 1.0	;	 %  35 k_35 C3b+C3a+C3bBb-S-FP --> C3-C3bBb-S-FP
	 1.0	;	 %  36 k_36 C3bBb-S+C3 --> C3-C3bBb-S
	 1.0	;	 %  37 k_37 C3-C3bBb-S --> C3bBb-S+C3
	 1.0	;	 %  38 k_38 C3-C3bBb-S --> C3b+C3a+C3bBb-S
	 1.0	;	 %  39 k_39 C3b+C3a+C3bBb-S --> C3-C3bBb-S
	 1.0	;	 %  40 k_40 C3bBb-S-FP+C3b --> C3bBbC3b-S-FP
	 1.0	;	 %  41 k_41 C3bBbC3b-S-FP --> C3bBb-S-FP+C3b
	 1.0	;	 %  42 k_42 C3bBb-S+C3b --> C3bBbC3b-S
	 1.0	;	 %  43 k_43 C3bBbC3b-S --> C3bBb-S+C3b
	 1.0	;	 %  44 k_44 C3bBbC3b-S+C5 --> C3bBbC3b-S-C5
	 1.0	;	 %  45 k_45 C3bBbC3b-S-C5 --> C3bBbC3b-S+C5
	 1.0	;	 %  46 k_46 C3bBbC3b-S-FP+C5 --> C3bBbC3b-S-FP-C5
	 1.0	;	 %  47 k_47 C3bBbC3b-S-FP-C5 --> C3bBbC3b-S-FP+C5
	 1.0	;	 %  48 k_48 C3bBbC3b-S-C5 --> C3bBbC3b-S+C5a+C5b
	 1.0	;	 %  49 k_49 C3bBbC3b-S+C5a+C5b --> C3bBbC3b-S-C5
	 1.0	;	 %  50 k_50 C3bBbC3b-S-FP-C5 --> C3bBbC3b-S-FP+C5a+C5b
	 1.0	;	 %  51 k_51 C3bBbC3b-S-FP+C5a+C5b --> C3bBbC3b-S-FP-C5
	 1.0	;	 %  52 k_52 C5b+S --> C5b-S
	 1.0	;	 %  53 k_53 C5b-S --> C5b+S
	 1.0	;	 %  54 k_54 C5b-S+C6 --> C5b-S-C6
	 1.0	;	 %  55 k_55 C5b-S-C6 --> C5b-S+C6
	 1.0	;	 %  56 k_56 C5b-S-C6+C7 --> C5b-S-C6-C7
	 1.0	;	 %  57 k_57 C5b-S-C6-C7 --> C5b-S-C6+C7
	 1.0	;	 %  58 k_58 C5b-S-C6-C7+C8 --> C5b-S-C6-C7-C8
	 1.0	;	 %  59 k_59 C5b-S-C6-C7-C8 --> C5b-S-C6-C7+C8
	 1.0	;	 %  60 k_60 C5b-S-C6-C7-C8+C9 --> C5b-S-C6-C7-C8-C9
	 1.0	;	 %  61 k_61 C5b-S-C6-C7-C8-C9 --> C5b-S-C6-C7-C8+C9
	 1.0	;	 %  62 k_62 C3b+FactorH --> C3b-FH
	 1.0	;	 %  63 k_63 C3b-FH --> C3b+FactorH
	 1.0	;	 %  64 k_64 C3b-FH+FactorI --> C3b-FH-FI
	 1.0	;	 %  65 k_65 C3b-FH-FI --> C3b-FH+FactorI
	 1.0	;	 %  66 k_66 C3b-FH-FI --> iC3b+FactorI+FactorH
	 1.0	;	 %  67 k_67 iC3b+FactorI+FactorH --> C3b-FH-FI
	 1.0	;	 %  68 k_68 C5b-S-C6-C7+PS --> C5b-S-C6-C7-PS
	 1.0	;	 %  69 k_69 C5b-S-C6-C7-PS --> C5b-S-C6-C7+PS
	 1.0	;	 %  70 k_70 C5b-S-C6-C7-C8+Clu --> C5b-S-C6-C7-C8-Clu
	 1.0	;	 %  71 k_71 C5b-S-C6-C7-C8-Clu --> C5b-S-C6-C7-C8+Clu
	 1.0	;	 %  72 k_72 [] --> C3
	 1.0	;	 %  73 k_73 C3 --> []
	 1.0	;	 %  74 k_74 [] --> C5
	 1.0	;	 %  75 k_75 C5 --> []
	 1.0	;	 %  76 k_76 [] --> C6
	 1.0	;	 %  77 k_77 C6 --> []
	 1.0	;	 %  78 k_78 [] --> C7
	 1.0	;	 %  79 k_79 C7 --> []
	 1.0	;	 %  80 k_80 [] --> C8
	 1.0	;	 %  81 k_81 C8 --> []
	 1.0	;	 %  82 k_82 [] --> C9
	 1.0	;	 %  83 k_83 C9 --> []
	 1.0	;	 %  84 k_84 [] --> C4bp
	 1.0	;	 %  85 k_85 C4bp --> []
	 1.0	;	 %  86 k_86 [] --> PS
	 1.0	;	 %  87 k_87 PS --> []
	 1.0	;	 %  88 k_88 [] --> FactorB
	 1.0	;	 %  89 k_89 FactorB --> []
	 1.0	;	 %  90 k_90 [] --> FactorD
	 1.0	;	 %  91 k_91 FactorD --> []
	 1.0	;	 %  92 k_92 [] --> FactorH
	 1.0	;	 %  93 k_93 FactorH --> []
	 1.0	;	 %  94 k_94 [] --> FactorI
	 1.0	;	 %  95 k_95 FactorI --> []
	 1.0	;	 %  96 k_96 [] --> FactorP
	 1.0	;	 %  97 k_97 FactorP --> []
	 1.0	;	 %  98 k_98 [] --> Clu
	 1.0	;	 %  99 k_99 Clu --> []
	 1.0	;	 %  100 k_100 C3 --> []
	 1.0	;	 %  101 k_101 [] --> C3
	 1.0	;	 %  102 k_102 C5 --> []
	 1.0	;	 %  103 k_103 [] --> C5
	 1.0	;	 %  104 k_104 C6 --> []
	 1.0	;	 %  105 k_105 [] --> C6
	 1.0	;	 %  106 k_106 C7 --> []
	 1.0	;	 %  107 k_107 [] --> C7
	 1.0	;	 %  108 k_108 C8 --> []
	 1.0	;	 %  109 k_109 [] --> C8
	 1.0	;	 %  110 k_110 C9 --> []
	 1.0	;	 %  111 k_111 [] --> C9
	 1.0	;	 %  112 k_112 C4bp --> []
	 1.0	;	 %  113 k_113 [] --> C4bp
	 1.0	;	 %  114 k_114 PS --> []
	 1.0	;	 %  115 k_115 [] --> PS
	 1.0	;	 %  116 k_116 C3Bb --> []
	 1.0	;	 %  117 k_117 [] --> C3Bb
	 1.0	;	 %  118 k_118 FactorB --> []
	 1.0	;	 %  119 k_119 [] --> FactorB
	 1.0	;	 %  120 k_120 FactorD --> []
	 1.0	;	 %  121 k_121 [] --> FactorD
	 1.0	;	 %  122 k_122 FactorH --> []
	 1.0	;	 %  123 k_123 [] --> FactorH
	 1.0	;	 %  124 k_124 FactorI --> []
	 1.0	;	 %  125 k_125 [] --> FactorI
	 1.0	;	 %  126 k_126 FactorP --> []
	 1.0	;	 %  127 k_127 [] --> FactorP
	 1.0	;	 %  128 k_128 Clu --> []
	 1.0	;	 %  129 k_129 [] --> Clu
	 1.0	;	 %  130 k_130 FBF --> []
	 1.0	;	 %  131 k_131 [] --> FBF
	 1.0	;	 %  132 k_132 C3a --> []
	 1.0	;	 %  133 k_133 [] --> C3a
	 1.0	;	 %  134 k_134 C3b --> []
	 1.0	;	 %  135 k_135 [] --> C3b
	 1.0	;	 %  136 k_136 C5a --> []
	 1.0	;	 %  137 k_137 [] --> C5a
	 1.0	;	 %  138 k_138 C5b --> []
	 1.0	;	 %  139 k_139 [] --> C5b
	 1.0	;	 %  140 k_140 Bb --> []
	 1.0	;	 %  141 k_141 [] --> Bb
];

% Initial conditions --
IC = [
	0.0	;	%	1	C3-H20
	0.0	;	%	2	C3
	0.0	;	%	3	C3-H20-FB
	0.0	;	%	4	FactorB
	0.0	;	%	5	C3-H20-FB-FD
	0.0	;	%	6	FactorD
	0.0	;	%	7	C3Bb-H20
	0.0	;	%	8	C3Bb-H20-C3
	0.0	;	%	9	C3a
	0.0	;	%	10	C3b
	0.0	;	%	11	Bb
	0.0	;	%	12	C3b-S
	0.0	;	%	13	S
	0.0	;	%	14	C3b-S-FB
	0.0	;	%	15	C3b-S-FB-FD
	0.0	;	%	16	C3bBb-S
	0.0	;	%	17	FBF
	0.0	;	%	18	C3bBb-S-FP
	0.0	;	%	19	FactorP
	0.0	;	%	20	C3bBb
	0.0	;	%	21	FP-S
	0.0	;	%	22	C3b-FP-S
	0.0	;	%	23	C3b-FP-S-FB
	0.0	;	%	24	C3b-FP-S-FB-FD
	0.0	;	%	25	C3-C3bBb-S-FP
	0.0	;	%	26	C3-C3bBb-S
	0.0	;	%	27	C3bBbC3b-S-FP
	0.0	;	%	28	C3bBbC3b-S
	0.0	;	%	29	C3bBbC3b-S-C5
	0.0	;	%	30	C5
	0.0	;	%	31	C3bBbC3b-S-FP-C5
	0.0	;	%	32	C5a
	0.0	;	%	33	C5b
	0.0	;	%	34	C5b-S
	0.0	;	%	35	C5b-S-C6
	0.0	;	%	36	C6
	0.0	;	%	37	C5b-S-C6-C7
	0.0	;	%	38	C7
	0.0	;	%	39	C5b-S-C6-C7-C8
	0.0	;	%	40	C8
	0.0	;	%	41	C5b-S-C6-C7-C8-C9
	0.0	;	%	42	C9
	0.0	;	%	43	C3b-FH
	0.0	;	%	44	FactorH
	0.0	;	%	45	C3b-FH-FI
	0.0	;	%	46	FactorI
	0.0	;	%	47	iC3b
	0.0	;	%	48	C5b-S-C6-C7-PS
	0.0	;	%	49	PS
	0.0	;	%	50	C5b-S-C6-C7-C8-Clu
	0.0	;	%	51	Clu
	0.0	;	%	52	C4bp
	0.0	;	%	53	C3Bb
];


% Initialize the measurement selection matrix. Default is *all* the states -- 
MEASUREMENT_INDEX_VECTOR = [1:NSTATES];

% Get the system dimension - 
NRATES = length(kV);
NSTATES = length(IC);

% =========== DO NOT EDIT BELOW THIS LINE ========================== %
DF.STOICHIOMETRIC_MATRIX          =   STM;
DF.INITIAL_CONDITION_VECTOR       =   IC;
DF.PARAMETER_VECTOR               =   kV;
DF.MEASUREMENT_SELECTION_VECTOR   =   MEASUREMENT_INDEX_VECTOR;
DF.NUMBER_PARAMETERS              =   NPARAMETERS;
DF.NUMBER_OF_STATES               =   NSTATES;
DF.NUMBER_OF_RATES                =   NRATES;
% ================================================================== %

return;
