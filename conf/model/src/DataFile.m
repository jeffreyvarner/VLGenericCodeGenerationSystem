function DF = DataFile(TSTART,TSTOP,Ts,INDEX)
% ---------------------------------------------------------------------- %
% DataFile.m was generated using the UNIVERSAL code generation system.
% Username: 
% Type: CELL_FREE_MODEL 
% 
% Arguments: 
% TSTART  - Time start 
% TSTOP  - Time stop 
% Ts - Time step 
% INDEX - Parameter set index (for ensemble calculations) 
% DF  - Data file instance 
% ---------------------------------------------------------------------- %

% Parameters list --
kV = [
	 % Reaction: 1 ywdH_BG10604_1.2.1.3::FORWARD -- 
	 1.0	;	 %  1 k_1_cat
	 0.1	;	 %  2 K_1_AC
	 0.1	;	 %  3 K_1_NADH

	 % Reaction: 2 ywdH_BG10604_1.2.1.3::REVERSE -- 
	 1.0	;	 %  4 k_2_cat
	 0.1	;	 %  5 K_2_ACETALDEHYDE
	 0.1	;	 %  6 K_2_NAD

	 % Reaction: 3 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  7 k_3_cat
	 0.1	;	 %  8 K_3_TDP
	 0.1	;	 %  9 K_3_ATP

	 % Reaction: 4 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  10 k_4_cat
	 0.1	;	 %  11 K_4_TTP
	 0.1	;	 %  12 K_4_ADP

	 % Reaction: 5 yloD_BG13386_2.7.4.8::FORWARD -- 
	 1.0	;	 %  13 k_5_cat
	 0.1	;	 %  14 K_5_ATP
	 0.1	;	 %  15 K_5_GMP

	 % Reaction: 6 yloD_BG13386_2.7.4.8::REVERSE -- 
	 1.0	;	 %  16 k_6_cat
	 0.1	;	 %  17 K_6_ADP
	 0.1	;	 %  18 K_6_GDP

	 % Reaction: 7 panC_2.7.1.33::FORWARD -- 
	 1.0	;	 %  19 k_7_cat
	 0.1	;	 %  20 K_7_PANT
	 0.1	;	 %  21 K_7_bALA
	 0.1	;	 %  22 K_7_ATP

	 % Reaction: 8 panC_2.7.1.33::REVERSE -- 
	 1.0	;	 %  23 k_8_cat
	 0.1	;	 %  24 K_8_AMP
	 0.1	;	 %  25 K_8_PPI
	 0.1	;	 %  26 K_8_PNTO

	 % Reaction: 9 nuo::FORWARD -- 
	 1.0	;	 %  27 k_9_cat
	 0.1	;	 %  28 K_9_NADH
	 0.1	;	 %  29 K_9_Q1

	 % Reaction: 10 nuo::REVERSE -- 
	 1.0	;	 %  30 k_10_cat
	 0.1	;	 %  31 K_10_NAD
	 0.1	;	 %  32 K_10_Q2
	 0.1	;	 %  33 K_10_HEXT

	 % Reaction: 11 SULFUR_TRANSPORT::FORWARD -- 
	 1.0	;	 %  34 k_11_cat
	 0.1	;	 %  35 K_11_SLFxt

	 % Reaction: 12 SULFUR_TRANSPORT::REVERSE -- 
	 1.0	;	 %  36 k_12_cat
	 0.1	;	 %  37 K_12_SLF

	 % Reaction: 13 citZ_BG10855_2.3.3.1::FORWARD -- 
	 1.0	;	 %  38 k_13_cat
	 0.1	;	 %  39 K_13_Acetyl-CoA
	 0.1	;	 %  40 K_13_OAA

	 % Reaction: 14 citZ_BG10855_2.3.3.1::REVERSE -- 
	 1.0	;	 %  41 k_14_cat
	 0.1	;	 %  42 K_14_CIT
	 0.1	;	 %  43 K_14_CoA

	 % Reaction: 15 no_bsuorf_3.1.1.31::FORWARD -- 
	 1.0	;	 %  44 k_15_cat
	 0.1	;	 %  45 K_15_G15L6P

	 % Reaction: 16 no_bsuorf_3.1.1.31::REVERSE -- 
	 1.0	;	 %  46 k_16_cat
	 0.1	;	 %  47 K_16_6PDG

	 % Reaction: 17 tkt_BG11247_2.2.1.1::FORWARD -- 
	 1.0	;	 %  48 k_17_cat
	 0.1	;	 %  49 K_17_R5P
	 0.1	;	 %  50 K_17_X5P

	 % Reaction: 18 tkt_BG11247_2.2.1.1::REVERSE -- 
	 1.0	;	 %  51 k_18_cat
	 0.1	;	 %  52 K_18_S7P
	 0.1	;	 %  53 K_18_GA3P

	 % Reaction: 19 yhcV_BG11600_1.1.1.205::FORWARD -- 
	 1.0	;	 %  54 k_19_cat
	 0.1	;	 %  55 K_19_IMP
	 0.1	;	 %  56 K_19_NAD

	 % Reaction: 20 yhcV_BG11600_1.1.1.205::REVERSE -- 
	 1.0	;	 %  57 k_20_cat
	 0.1	;	 %  58 K_20_XMP
	 0.1	;	 %  59 K_20_NADH

	 % Reaction: 21 yjmC_BG13206_1.1.1.37::FORWARD -- 
	 1.0	;	 %  60 k_21_cat
	 0.1	;	 %  61 K_21_MAL
	 0.1	;	 %  62 K_21_NAD

	 % Reaction: 22 yjmC_BG13206_1.1.1.37::REVERSE -- 
	 1.0	;	 %  63 k_22_cat
	 0.1	;	 %  64 K_22_OAA
	 0.1	;	 %  65 K_22_NADH

	 % Reaction: 23 nrdE_BG11404_1.17.4.1::FORWARD -- 
	 1.0	;	 %  66 k_23_cat
	 0.1	;	 %  67 K_23_GDP
	 0.1	;	 %  68 K_23_RTRD

	 % Reaction: 24 nrdE_BG11404_1.17.4.1::REVERSE -- 
	 1.0	;	 %  69 k_24_cat
	 0.1	;	 %  70 K_24_OTRD
	 0.1	;	 %  71 K_24_dGDP

	 % Reaction: 25 ilvD_BG11532_4.2.1.9::FORWARD -- 
	 1.0	;	 %  72 k_25_cat
	 0.1	;	 %  73 K_25_DIOH-ISOVALERATE

	 % Reaction: 26 ilvD_BG11532_4.2.1.9::REVERSE -- 
	 1.0	;	 %  74 k_26_cat
	 0.1	;	 %  75 K_26_2-KETO-ISOVALERATE

	 % Reaction: 27 _need_to_assign::FORWARD -- 
	 1.0	;	 %  76 k_27_cat
	 0.1	;	 %  77 K_27_RU5P

	 % Reaction: 28 _need_to_assign::REVERSE -- 
	 1.0	;	 %  78 k_28_cat
	 0.1	;	 %  79 K_28_A5P

	 % Reaction: 29 gmk_BG13386_2.7.4.8::FORWARD -- 
	 1.0	;	 %  80 k_29_cat
	 0.1	;	 %  81 K_29_ATP
	 0.1	;	 %  82 K_29_GMP

	 % Reaction: 30 gmk_BG13386_2.7.4.8::REVERSE -- 
	 1.0	;	 %  83 k_30_cat
	 0.1	;	 %  84 K_30_ADP
	 0.1	;	 %  85 K_30_GDP

	 % Reaction: 31 atpD_BG10821_3.6.3.14::FORWARD -- 
	 1.0	;	 %  86 k_31_cat
	 0.1	;	 %  87 K_31_ADP
	 0.1	;	 %  88 K_31_PI
	 0.1	;	 %  89 K_31_HEXT

	 % Reaction: 32 atpD_BG10821_3.6.3.14::REVERSE -- 
	 1.0	;	 %  90 k_32_cat
	 0.1	;	 %  91 K_32_ATP

	 % Reaction: 33 cydD_BG11928_1.10.3.-::FORWARD -- 
	 1.0	;	 %  92 k_33_cat
	 0.1	;	 %  93 K_33_Q2
	 0.1	;	 %  94 K_33_O2

	 % Reaction: 34 cydD_BG11928_1.10.3.-::REVERSE -- 
	 1.0	;	 %  95 k_34_cat
	 0.1	;	 %  96 K_34_Q1
	 0.1	;	 %  97 K_34_HEXT

	 % Reaction: 35 aroB_BG10285_4.2.3.4::FORWARD -- 
	 1.0	;	 %  98 k_35_cat
	 0.1	;	 %  99 K_35_3-DEOXY-D_ARBINO-HEPT-2-ULOSONATE

	 % Reaction: 36 aroB_BG10285_4.2.3.4::REVERSE -- 
	 1.0	;	 %  100 k_36_cat
	 0.1	;	 %  101 K_36_DEHYDROQUINATE
	 0.1	;	 %  102 K_36_PI

	 % Reaction: 37 purL_BG10705_6.3.5.3::FORWARD -- 
	 1.0	;	 %  103 k_37_cat
	 0.1	;	 %  104 K_37_FGAR
	 0.1	;	 %  105 K_37_ATP
	 0.1	;	 %  106 K_37_GLN

	 % Reaction: 38 purL_BG10705_6.3.5.3::REVERSE -- 
	 1.0	;	 %  107 k_38_cat
	 0.1	;	 %  108 K_38_GLU
	 0.1	;	 %  109 K_38_ADP
	 0.1	;	 %  110 K_38_PI
	 0.1	;	 %  111 K_38_FGAM

	 % Reaction: 39 folA_yacE_BG10141_4.1.2.25::FORWARD -- 
	 1.0	;	 %  112 k_39_cat
	 0.1	;	 %  113 K_39_DIHYDRO-NEO-PTERIN

	 % Reaction: 40 folA_yacE_BG10141_4.1.2.25::REVERSE -- 
	 1.0	;	 %  114 k_40_cat
	 0.1	;	 %  115 K_40_GLYCOLALDEHYDE
	 0.1	;	 %  116 K_40_AMINO-OH-HYDROXYMETHYL-DIHYDROPTERIDINE

	 % Reaction: 41 thyA_BG11190_2.1.1.45::FORWARD -- 
	 1.0	;	 %  117 k_41_cat
	 0.1	;	 %  118 K_41_METHYLENE-THF
	 0.1	;	 %  119 K_41_dUMP

	 % Reaction: 42 thyA_BG11190_2.1.1.45::REVERSE -- 
	 1.0	;	 %  120 k_42_cat
	 0.1	;	 %  121 K_42_dTMP
	 0.1	;	 %  122 K_42_DIHYDROFOLATE

	 % Reaction: 43 R01377_4.1.1.43::FORWARD -- 
	 1.0	;	 %  123 k_43_cat
	 0.1	;	 %  124 K_43_PHENYL-PYRUVATE

	 % Reaction: 44 R01377_4.1.1.43::REVERSE -- 
	 1.0	;	 %  125 k_44_cat
	 0.1	;	 %  126 K_44_PHENYL-ACETALDEHYDE
	 0.1	;	 %  127 K_44_CO2

	 % Reaction: 45 proG_BG10841_1.5.1.2::FORWARD -- 
	 1.0	;	 %  128 k_45_cat
	 0.1	;	 %  129 K_45_PYYCX
	 0.1	;	 %  130 K_45_NADPH

	 % Reaction: 46 proG_BG10841_1.5.1.2::REVERSE -- 
	 1.0	;	 %  131 k_46_cat
	 0.1	;	 %  132 K_46_PRO
	 0.1	;	 %  133 K_46_NAD

	 % Reaction: 47 CO2_transfer::FORWARD -- 
	 1.0	;	 %  134 k_47_cat
	 0.1	;	 %  135 K_47_CO2

	 % Reaction: 48 CO2_transfer::REVERSE -- 
	 1.0	;	 %  136 k_48_cat
	 0.1	;	 %  137 K_48_CO2xt

	 % Reaction: 49 sucC_BG12680_6.2.1.5::FORWARD -- 
	 1.0	;	 %  138 k_49_cat
	 0.1	;	 %  139 K_49_ADP
	 0.1	;	 %  140 K_49_PI
	 0.1	;	 %  141 K_49_SUCCCoA

	 % Reaction: 50 sucC_BG12680_6.2.1.5::REVERSE -- 
	 1.0	;	 %  142 k_50_cat
	 0.1	;	 %  143 K_50_SUCC
	 0.1	;	 %  144 K_50_ATP
	 0.1	;	 %  145 K_50_CoA

	 % Reaction: 51 _need_to_do::FORWARD -- 
	 1.0	;	 %  146 k_51_cat
	 0.1	;	 %  147 K_51_R5P

	 % Reaction: 52 _need_to_do::REVERSE -- 
	 1.0	;	 %  148 k_52_cat
	 0.1	;	 %  149 K_52_CYTD
	 0.1	;	 %  150 K_52_PI

	 % Reaction: 53 yrhB_BG12291_4.4.1.1::FORWARD -- 
	 1.0	;	 %  151 k_53_cat
	 0.1	;	 %  152 K_53_2-OXOBUTANOATE
	 0.1	;	 %  153 K_53_CYS
	 0.1	;	 %  154 K_53_NH3

	 % Reaction: 54 yrhB_BG12291_4.4.1.1::REVERSE -- 
	 1.0	;	 %  155 k_54_cat
	 0.1	;	 %  156 K_54_L-CYSTATHIONINE

	 % Reaction: 55 hack::FORWARD -- 
	 1.0	;	 %  157 k_55_cat
	 0.1	;	 %  158 K_55_ADP

	 % Reaction: 56 hack::REVERSE -- 
	 1.0	;	 %  159 k_56_cat
	 0.1	;	 %  160 K_56_AMP
	 0.1	;	 %  161 K_56_PI

	 % Reaction: 57 prs_BG10114_2.7.6.1::FORWARD -- 
	 1.0	;	 %  162 k_57_cat
	 0.1	;	 %  163 K_57_ATP
	 0.1	;	 %  164 K_57_R5P

	 % Reaction: 58 prs_BG10114_2.7.6.1::REVERSE -- 
	 1.0	;	 %  165 k_58_cat
	 0.1	;	 %  166 K_58_AMP
	 0.1	;	 %  167 K_58_PRPP

	 % Reaction: 59 _need_to_do::FORWARD -- 
	 1.0	;	 %  168 k_59_cat
	 0.1	;	 %  169 K_59_UMP
	 0.1	;	 %  170 K_59_ATP

	 % Reaction: 60 _need_to_do::REVERSE -- 
	 1.0	;	 %  171 k_60_cat
	 0.1	;	 %  172 K_60_ADP
	 0.1	;	 %  173 K_60_UDP

	 % Reaction: 61 sdhABC_BG1035(123)_1.3.99.1::FORWARD -- 
	 1.0	;	 %  174 k_61_cat
	 0.1	;	 %  175 K_61_SUCC
	 0.1	;	 %  176 K_61_FAD

	 % Reaction: 62 sdhABC_BG1035(123)_1.3.99.1::REVERSE -- 
	 1.0	;	 %  177 k_62_cat
	 0.1	;	 %  178 K_62_FADH
	 0.1	;	 %  179 K_62_FUM

	 % Reaction: 63 purC_BG10703_6.3.2.6::FORWARD -- 
	 1.0	;	 %  180 k_63_cat
	 0.1	;	 %  181 K_63_CAIR
	 0.1	;	 %  182 K_63_ATP
	 0.1	;	 %  183 K_63_ASP

	 % Reaction: 64 purC_BG10703_6.3.2.6::REVERSE -- 
	 1.0	;	 %  184 k_64_cat
	 0.1	;	 %  185 K_64_ADP
	 0.1	;	 %  186 K_64_PI
	 0.1	;	 %  187 K_64_SAICAR

	 % Reaction: 65 hisJ_ytvP_BG13931_3.1.3.15::FORWARD -- 
	 1.0	;	 %  188 k_65_cat
	 0.1	;	 %  189 K_65_L-HISTIDINOL-P

	 % Reaction: 66 hisJ_ytvP_BG13931_3.1.3.15::REVERSE -- 
	 1.0	;	 %  190 k_66_cat
	 0.1	;	 %  191 K_66_HISTIDINOL
	 0.1	;	 %  192 K_66_PI

	 % Reaction: 67 ywaA_ipa-0r_BG10546_2.6.1.42::FORWARD -- 
	 1.0	;	 %  193 k_67_cat
	 0.1	;	 %  194 K_67_2-KETO-3-METHYL-VALERATE
	 0.1	;	 %  195 K_67_GLU

	 % Reaction: 68 ywaA_ipa-0r_BG10546_2.6.1.42::REVERSE -- 
	 1.0	;	 %  196 k_68_cat
	 0.1	;	 %  197 K_68_ILE
	 0.1	;	 %  198 K_68_OGA

	 % Reaction: 69 eda::FORWARD -- 
	 1.0	;	 %  199 k_69_cat
	 0.1	;	 %  200 K_69_2KD6PG

	 % Reaction: 70 eda::REVERSE -- 
	 1.0	;	 %  201 k_70_cat
	 0.1	;	 %  202 K_70_PYR
	 0.1	;	 %  203 K_70_GA3P

	 % Reaction: 71 thrC_thrB_BG10461_4.2.3.1::FORWARD -- 
	 1.0	;	 %  204 k_71_cat
	 0.1	;	 %  205 K_71_O-PHOSPHO-L-HOMOSERINE

	 % Reaction: 72 thrC_thrB_BG10461_4.2.3.1::REVERSE -- 
	 1.0	;	 %  206 k_72_cat
	 0.1	;	 %  207 K_72_PI
	 0.1	;	 %  208 K_72_THR

	 % Reaction: 73 trpB_BG10290_4.2.1.20::FORWARD -- 
	 1.0	;	 %  209 k_73_cat
	 0.1	;	 %  210 K_73_INDOLE-3-GLYCEROL-P
	 0.1	;	 %  211 K_73_SER

	 % Reaction: 74 trpB_BG10290_4.2.1.20::REVERSE -- 
	 1.0	;	 %  212 k_74_cat
	 0.1	;	 %  213 K_74_TRP
	 0.1	;	 %  214 K_74_GA3P

	 % Reaction: 75 yweB_BG10621_1.4.1.2::FORWARD -- 
	 1.0	;	 %  215 k_75_cat
	 0.1	;	 %  216 K_75_OGA
	 0.1	;	 %  217 K_75_NH3
	 0.1	;	 %  218 K_75_NADH

	 % Reaction: 76 yweB_BG10621_1.4.1.2::REVERSE -- 
	 1.0	;	 %  219 k_76_cat
	 0.1	;	 %  220 K_76_GLU
	 0.1	;	 %  221 K_76_NAD

	 % Reaction: 77 ywfG_BG10631_2.6.1.1::FORWARD -- 
	 1.0	;	 %  222 k_77_cat
	 0.1	;	 %  223 K_77_OGA
	 0.1	;	 %  224 K_77_ASP

	 % Reaction: 78 ywfG_BG10631_2.6.1.1::REVERSE -- 
	 1.0	;	 %  225 k_78_cat
	 0.1	;	 %  226 K_78_OAA
	 0.1	;	 %  227 K_78_GLU

	 % Reaction: 79 ribB::FORWARD -- 
	 1.0	;	 %  228 k_79_cat
	 0.1	;	 %  229 K_79_RU5P

	 % Reaction: 80 ribB::REVERSE -- 
	 1.0	;	 %  230 k_80_cat
	 0.1	;	 %  231 K_80_DBP
	 0.1	;	 %  232 K_80_FOR

	 % Reaction: 81 tkt_BG11247_2.2.1.1::FORWARD -- 
	 1.0	;	 %  233 k_81_cat
	 0.1	;	 %  234 K_81_X5P
	 0.1	;	 %  235 K_81_E4P

	 % Reaction: 82 adhB_BG11902_1.1.1.1::FORWARD -- 
	 1.0	;	 %  236 k_82_cat
	 0.1	;	 %  237 K_82_ACETALDEHYDE
	 0.1	;	 %  238 K_82_NADH

	 % Reaction: 83 adhB_BG11902_1.1.1.1::REVERSE -- 
	 1.0	;	 %  239 k_83_cat
	 0.1	;	 %  240 K_83_ETH
	 0.1	;	 %  241 K_83_NAD

	 % Reaction: 84 R02536_1.2.1.5::FORWARD -- 
	 1.0	;	 %  242 k_84_cat
	 0.1	;	 %  243 K_84_PHENYLACETATE
	 0.1	;	 %  244 K_84_NADH

	 % Reaction: 85 R02536_1.2.1.5::REVERSE -- 
	 1.0	;	 %  245 k_85_cat
	 0.1	;	 %  246 K_85_PHENYL-ACETALDEHYDE
	 0.1	;	 %  247 K_85_NAD

	 % Reaction: 86 ureA_BG11981_3.5.1.5::FORWARD -- 
	 1.0	;	 %  248 k_86_cat
	 0.1	;	 %  249 K_86_UREA

	 % Reaction: 87 ureA_BG11981_3.5.1.5::REVERSE -- 
	 1.0	;	 %  250 k_87_cat
	 0.1	;	 %  251 K_87_CO2
	 0.1	;	 %  252 K_87_NH3

	 % Reaction: 88 R02536_1.2.1.39::FORWARD -- 
	 1.0	;	 %  253 k_88_cat
	 0.1	;	 %  254 K_88_PHENYL-ACETALDEHYDE
	 0.1	;	 %  255 K_88_NAD

	 % Reaction: 89 R02536_1.2.1.39::REVERSE -- 
	 1.0	;	 %  256 k_89_cat
	 0.1	;	 %  257 K_89_PHENYLACETATE
	 0.1	;	 %  258 K_89_NADH

	 % Reaction: 90 HEXT_transfer::FORWARD -- 
	 1.0	;	 %  259 k_90_cat
	 0.1	;	 %  260 K_90_Hxt

	 % Reaction: 91 HEXT_transfer::REVERSE -- 
	 1.0	;	 %  261 k_91_cat
	 0.1	;	 %  262 K_91_HEXT

	 % Reaction: 92 acuA_BG10369_2.3.1.-::FORWARD -- 
	 1.0	;	 %  263 k_92_cat
	 0.1	;	 %  264 K_92_LYS
	 0.1	;	 %  265 K_92_Acetyl-CoA

	 % Reaction: 93 acuA_BG10369_2.3.1.-::REVERSE -- 
	 1.0	;	 %  266 k_93_cat
	 0.1	;	 %  267 K_93_N6-ACETYL-L-LYSINE
	 0.1	;	 %  268 K_93_CoA

	 % Reaction: 94 ctaC_BG1O21(5-8)_1.9.3.1::FORWARD -- 
	 1.0	;	 %  269 k_94_cat
	 0.1	;	 %  270 K_94_Fo-c
	 0.1	;	 %  271 K_94_O2

	 % Reaction: 95 ctaC_BG1O21(5-8)_1.9.3.1::REVERSE -- 
	 1.0	;	 %  272 k_95_cat
	 0.1	;	 %  273 K_95_Fi-c
	 0.1	;	 %  274 K_95_HEXT

	 % Reaction: 96 pdhA_BG1O207_1.2.4.1::FORWARD -- 
	 1.0	;	 %  275 k_96_cat
	 0.1	;	 %  276 K_96_PYR
	 0.1	;	 %  277 K_96_CoA
	 0.1	;	 %  278 K_96_NAD

	 % Reaction: 97 pdhA_BG1O207_1.2.4.1::REVERSE -- 
	 1.0	;	 %  279 k_97_cat
	 0.1	;	 %  280 K_97_NADH
	 0.1	;	 %  281 K_97_CO2
	 0.1	;	 %  282 K_97_Acetyl-CoA

	 % Reaction: 98 argH_BG12571_4.3.2.1::FORWARD -- 
	 1.0	;	 %  283 k_98_cat
	 0.1	;	 %  284 K_98_FUM
	 0.1	;	 %  285 K_98_ARG

	 % Reaction: 99 argH_BG12571_4.3.2.1::REVERSE -- 
	 1.0	;	 %  286 k_99_cat
	 0.1	;	 %  287 K_99_NOSUCC

	 % Reaction: 100 ylaM_BG13350_3.5.1.2::FORWARD -- 
	 1.0	;	 %  288 k_100_cat
	 0.1	;	 %  289 K_100_ATP
	 0.1	;	 %  290 K_100_GLU
	 0.1	;	 %  291 K_100_NH3

	 % Reaction: 101 ylaM_BG13350_3.5.1.2::REVERSE -- 
	 1.0	;	 %  292 k_101_cat
	 0.1	;	 %  293 K_101_ADP
	 0.1	;	 %  294 K_101_GLN
	 0.1	;	 %  295 K_101_PI

	 % Reaction: 102 ykeA_BG10841_1.5.1.2::FORWARD -- 
	 1.0	;	 %  296 k_102_cat
	 0.1	;	 %  297 K_102_PRO
	 0.1	;	 %  298 K_102_NADP

	 % Reaction: 103 ykeA_BG10841_1.5.1.2::REVERSE -- 
	 1.0	;	 %  299 k_103_cat
	 0.1	;	 %  300 K_103_PYYCX
	 0.1	;	 %  301 K_103_NADPH

	 % Reaction: 104 panB_2.1.2.11::FORWARD -- 
	 1.0	;	 %  302 k_104_cat
	 0.1	;	 %  303 K_104_OIVAL
	 0.1	;	 %  304 K_104_METHYLENE-THF

	 % Reaction: 105 panB_2.1.2.11::REVERSE -- 
	 1.0	;	 %  305 k_105_cat
	 0.1	;	 %  306 K_105_AKP
	 0.1	;	 %  307 K_105_THF

	 % Reaction: 106 hisF_BG12600_4.1.3.-::FORWARD -- 
	 1.0	;	 %  308 k_106_cat
	 0.1	;	 %  309 K_106_PHOSPHORIBULOSYL-FORMIMINO-AICAR-P
	 0.1	;	 %  310 K_106_GLN

	 % Reaction: 107 hisF_BG12600_4.1.3.-::REVERSE -- 
	 1.0	;	 %  311 k_107_cat
	 0.1	;	 %  312 K_107_GLU
	 0.1	;	 %  313 K_107_AICAR
	 0.1	;	 %  314 K_107_D-ERYTHRO-IMIDAZOLE-GLYCEROL-P

	 % Reaction: 108 _2.7.4.11::FORWARD -- 
	 1.0	;	 %  315 k_108_cat
	 0.1	;	 %  316 K_108_dAMP
	 0.1	;	 %  317 K_108_ATP

	 % Reaction: 109 _2.7.4.11::REVERSE -- 
	 1.0	;	 %  318 k_109_cat
	 0.1	;	 %  319 K_109_dADP
	 0.1	;	 %  320 K_109_ADP

	 % Reaction: 110 aroJ_BG10292_2.6.1.5::FORWARD -- 
	 1.0	;	 %  321 k_110_cat
	 0.1	;	 %  322 K_110_PHENYL-PYRUVATE
	 0.1	;	 %  323 K_110_GLU

	 % Reaction: 111 aroJ_BG10292_2.6.1.5::REVERSE -- 
	 1.0	;	 %  324 k_111_cat
	 0.1	;	 %  325 K_111_OGA
	 0.1	;	 %  326 K_111_PHE

	 % Reaction: 112 sucD_BG12681_6.2.1.5::FORWARD -- 
	 1.0	;	 %  327 k_112_cat
	 0.1	;	 %  328 K_112_ADP
	 0.1	;	 %  329 K_112_PI
	 0.1	;	 %  330 K_112_SUCCCoA

	 % Reaction: 113 sucD_BG12681_6.2.1.5::REVERSE -- 
	 1.0	;	 %  331 k_113_cat
	 0.1	;	 %  332 K_113_SUCC
	 0.1	;	 %  333 K_113_ATP
	 0.1	;	 %  334 K_113_CoA

	 % Reaction: 114 yjcJ_BG13163_4.4.1.8::FORWARD -- 
	 1.0	;	 %  335 k_114_cat
	 0.1	;	 %  336 K_114_L-CYSTATHIONINE

	 % Reaction: 115 yjcJ_BG13163_4.4.1.8::REVERSE -- 
	 1.0	;	 %  337 k_115_cat
	 0.1	;	 %  338 K_115_HCYS
	 0.1	;	 %  339 K_115_NH3
	 0.1	;	 %  340 K_115_PYR

	 % Reaction: 116 yrhA_BG12290_2.5.1.47::FORWARD -- 
	 1.0	;	 %  341 k_116_cat
	 0.1	;	 %  342 K_116_ACETYLSERINE
	 0.1	;	 %  343 K_116_HS

	 % Reaction: 117 yrhA_BG12290_2.5.1.47::REVERSE -- 
	 1.0	;	 %  344 k_117_cat
	 0.1	;	 %  345 K_117_CYS
	 0.1	;	 %  346 K_117_AC

	 % Reaction: 118 citA_BG10854_2.3.3.1::FORWARD -- 
	 1.0	;	 %  347 k_118_cat
	 0.1	;	 %  348 K_118_Acetyl-CoA
	 0.1	;	 %  349 K_118_OAA

	 % Reaction: 119 citA_BG10854_2.3.3.1::REVERSE -- 
	 1.0	;	 %  350 k_119_cat
	 0.1	;	 %  351 K_119_CIT
	 0.1	;	 %  352 K_119_CoA

	 % Reaction: 120 yjcJ_BG13163_4.4.1.8::FORWARD -- 
	 1.0	;	 %  353 k_120_cat
	 0.1	;	 %  354 K_120_L-CYSTATHIONINE

	 % Reaction: 121 yjcJ_BG13163_4.4.1.8::REVERSE -- 
	 1.0	;	 %  355 k_121_cat
	 0.1	;	 %  356 K_121_PYR
	 0.1	;	 %  357 K_121_NH3
	 0.1	;	 %  358 K_121_HCYS

	 % Reaction: 122 adhA_BG12562_1.1.1.2::FORWARD -- 
	 1.0	;	 %  359 k_122_cat
	 0.1	;	 %  360 K_122_ACETALDEHYDE
	 0.1	;	 %  361 K_122_NADPH

	 % Reaction: 123 adhA_BG12562_1.1.1.2::REVERSE -- 
	 1.0	;	 %  362 k_123_cat
	 0.1	;	 %  363 K_123_ETH
	 0.1	;	 %  364 K_123_NADP

	 % Reaction: 124 pntB::FORWARD -- 
	 1.0	;	 %  365 k_124_cat
	 0.1	;	 %  366 K_124_NADP
	 0.1	;	 %  367 K_124_NADH
	 0.1	;	 %  368 K_124_HEXT

	 % Reaction: 125 pntB::REVERSE -- 
	 1.0	;	 %  369 k_125_cat
	 0.1	;	 %  370 K_125_NADPH
	 0.1	;	 %  371 K_125_NAD

	 % Reaction: 126 aroD_BG11522_1.1.1.25::FORWARD -- 
	 1.0	;	 %  372 k_126_cat
	 0.1	;	 %  373 K_126_NADPH
	 0.1	;	 %  374 K_126_3-DEHYDRO-SHIKIMATE

	 % Reaction: 127 aroD_BG11522_1.1.1.25::REVERSE -- 
	 1.0	;	 %  375 k_127_cat
	 0.1	;	 %  376 K_127_NADP
	 0.1	;	 %  377 K_127_SHIKIMATE

	 % Reaction: 128 gntZ_BG10651_1.1.1.44::FORWARD -- 
	 1.0	;	 %  378 k_128_cat
	 0.1	;	 %  379 K_128_6PDG
	 0.1	;	 %  380 K_128_NADP

	 % Reaction: 129 gntZ_BG10651_1.1.1.44::REVERSE -- 
	 1.0	;	 %  381 k_129_cat
	 0.1	;	 %  382 K_129_RU5P
	 0.1	;	 %  383 K_129_CO2
	 0.1	;	 %  384 K_129_NADPH

	 % Reaction: 130 gpsA_BG11366_1.1.1.94::FORWARD -- 
	 1.0	;	 %  385 k_130_cat
	 0.1	;	 %  386 K_130_GL3P
	 0.1	;	 %  387 K_130_NADP

	 % Reaction: 131 gpsA_BG11366_1.1.1.94::REVERSE -- 
	 1.0	;	 %  388 k_131_cat
	 0.1	;	 %  389 K_131_DHAP
	 0.1	;	 %  390 K_131_NADPH

	 % Reaction: 132 _2.7.4.8::FORWARD -- 
	 1.0	;	 %  391 k_132_cat
	 0.1	;	 %  392 K_132_dGMP
	 0.1	;	 %  393 K_132_ATP

	 % Reaction: 133 _2.7.4.8::REVERSE -- 
	 1.0	;	 %  394 k_133_cat
	 0.1	;	 %  395 K_133_dGDP
	 0.1	;	 %  396 K_133_ADP

	 % Reaction: 134 yqgN_BG11681_6.3.3.2::FORWARD -- 
	 1.0	;	 %  397 k_134_cat
	 0.1	;	 %  398 K_134_5-FORMYL-THF
	 0.1	;	 %  399 K_134_ATP

	 % Reaction: 135 yjcI_BG13163_4.4.1.8::FORWARD -- 
	 1.0	;	 %  400 k_135_cat
	 0.1	;	 %  401 K_135_PYR
	 0.1	;	 %  402 K_135_NH3
	 0.1	;	 %  403 K_135_HS

	 % Reaction: 136 yjcI_BG13163_4.4.1.8::REVERSE -- 
	 1.0	;	 %  404 k_136_cat
	 0.1	;	 %  405 K_136_CYS

	 % Reaction: 137 coaA_2.7.1.33::FORWARD -- 
	 1.0	;	 %  406 k_137_cat
	 0.1	;	 %  407 K_137_PNTO
	 0.1	;	 %  408 K_137_ATP
	 0.1	;	 %  409 K_137_CTP
	 0.1	;	 %  410 K_137_CYS

	 % Reaction: 138 coaA_2.7.1.33::REVERSE -- 
	 1.0	;	 %  411 k_138_cat
	 0.1	;	 %  412 K_138_ADP
	 0.1	;	 %  413 K_138_CMP
	 0.1	;	 %  414 K_138_PPI
	 0.1	;	 %  415 K_138_CO2
	 0.1	;	 %  416 K_138_CoA

	 % Reaction: 139 _need_to_do::FORWARD -- 
	 1.0	;	 %  417 k_139_cat
	 0.1	;	 %  418 K_139_URI
	 0.1	;	 %  419 K_139_ATP

	 % Reaction: 140 _need_to_do::REVERSE -- 
	 1.0	;	 %  420 k_140_cat
	 0.1	;	 %  421 K_140_ADP
	 0.1	;	 %  422 K_140_UMP

	 % Reaction: 141 citG_BG10384_4.2.1.2::FORWARD -- 
	 1.0	;	 %  423 k_141_cat
	 0.1	;	 %  424 K_141_FUM

	 % Reaction: 142 citG_BG10384_4.2.1.2::REVERSE -- 
	 1.0	;	 %  425 k_142_cat
	 0.1	;	 %  426 K_142_MAL

	 % Reaction: 143 malS_BG12614_1.1.1.40::FORWARD -- 
	 1.0	;	 %  427 k_143_cat
	 0.1	;	 %  428 K_143_MAL
	 0.1	;	 %  429 K_143_NADP

	 % Reaction: 144 malS_BG12614_1.1.1.40::REVERSE -- 
	 1.0	;	 %  430 k_144_cat
	 0.1	;	 %  431 K_144_PYR
	 0.1	;	 %  432 K_144_NADPH
	 0.1	;	 %  433 K_144_CO2

	 % Reaction: 145 pgm_BG10898_5.4.2.1::FORWARD -- 
	 1.0	;	 %  434 k_145_cat
	 0.1	;	 %  435 K_145_3PG

	 % Reaction: 146 pgm_BG10898_5.4.2.1::REVERSE -- 
	 1.0	;	 %  436 k_146_cat
	 0.1	;	 %  437 K_146_2PG

	 % Reaction: 147 trpE_BG10287_4.1.3.27::FORWARD -- 
	 1.0	;	 %  438 k_147_cat
	 0.1	;	 %  439 K_147_CHOR
	 0.1	;	 %  440 K_147_GLN

	 % Reaction: 148 trpE_BG10287_4.1.3.27::REVERSE -- 
	 1.0	;	 %  441 k_148_cat
	 0.1	;	 %  442 K_148_ANTHRANILATE
	 0.1	;	 %  443 K_148_PYR
	 0.1	;	 %  444 K_148_GLU

	 % Reaction: 149 UTP_SYNTHESIS::FORWARD -- 
	 1.0	;	 %  445 k_149_cat
	 0.1	;	 %  446 K_149_ATP
	 0.1	;	 %  447 K_149_NH3
	 0.1	;	 %  448 K_149_PRPP
	 0.1	;	 %  449 K_149_ASP
	 0.1	;	 %  450 K_149_NAD

	 % Reaction: 150 UTP_SYNTHESIS::REVERSE -- 
	 1.0	;	 %  451 k_150_cat
	 0.1	;	 %  452 K_150_NADH
	 0.1	;	 %  453 K_150_UTP
	 0.1	;	 %  454 K_150_ADP
	 0.1	;	 %  455 K_150_PI

	 % Reaction: 151 edd::FORWARD -- 
	 1.0	;	 %  456 k_151_cat
	 0.1	;	 %  457 K_151_6PDG

	 % Reaction: 152 edd::REVERSE -- 
	 1.0	;	 %  458 k_152_cat
	 0.1	;	 %  459 K_152_2KD6PG

	 % Reaction: 153 ywlF_BG10942_5.3.1.6::FORWARD -- 
	 1.0	;	 %  460 k_153_cat
	 0.1	;	 %  461 K_153_RU5P

	 % Reaction: 154 ywlF_BG10942_5.3.1.6::REVERSE -- 
	 1.0	;	 %  462 k_154_cat
	 0.1	;	 %  463 K_154_R5P

	 % Reaction: 155 adk_BG10446_2.7.4.3::FORWARD -- 
	 1.0	;	 %  464 k_155_cat
	 0.1	;	 %  465 K_155_AMP
	 0.1	;	 %  466 K_155_ATP

	 % Reaction: 156 adk_BG10446_2.7.4.3::REVERSE -- 
	 1.0	;	 %  467 k_156_cat
	 0.1	;	 %  468 K_156_ADP

	 % Reaction: 157 hisC_BG10292_2.6.1.5::FORWARD -- 
	 1.0	;	 %  469 k_157_cat
	 0.1	;	 %  470 K_157_PHENYL-PYRUVATE
	 0.1	;	 %  471 K_157_GLU

	 % Reaction: 158 hisC_BG10292_2.6.1.5::REVERSE -- 
	 1.0	;	 %  472 k_158_cat
	 0.1	;	 %  473 K_158_OGA
	 0.1	;	 %  474 K_158_PHE

	 % Reaction: 159 asnH_BG11116_6.3.5.4::FORWARD -- 
	 1.0	;	 %  475 k_159_cat
	 0.1	;	 %  476 K_159_GLN
	 0.1	;	 %  477 K_159_ASP
	 0.1	;	 %  478 K_159_ATP

	 % Reaction: 160 asnH_BG11116_6.3.5.4::REVERSE -- 
	 1.0	;	 %  479 k_160_cat
	 0.1	;	 %  480 K_160_GLU
	 0.1	;	 %  481 K_160_ASN
	 0.1	;	 %  482 K_160_PPI
	 0.1	;	 %  483 K_160_AMP

	 % Reaction: 161 _need_to_do::FORWARD -- 
	 1.0	;	 %  484 k_161_cat
	 0.1	;	 %  485 K_161_UMP

	 % Reaction: 162 _need_to_do::REVERSE -- 
	 1.0	;	 %  486 k_162_cat
	 0.1	;	 %  487 K_162_PI
	 0.1	;	 %  488 K_162_URI

	 % Reaction: 163 iolJ_BG11125_4.1.2.13::FORWARD -- 
	 1.0	;	 %  489 k_163_cat
	 0.1	;	 %  490 K_163_F16BP

	 % Reaction: 164 iolJ_BG11125_4.1.2.13::REVERSE -- 
	 1.0	;	 %  491 k_164_cat
	 0.1	;	 %  492 K_164_GA3P
	 0.1	;	 %  493 K_164_DHAP

	 % Reaction: 165 purB_BG10702_4.3.2.2::FORWARD -- 
	 1.0	;	 %  494 k_165_cat
	 0.1	;	 %  495 K_165_SAICAR

	 % Reaction: 166 purB_BG10702_4.3.2.2::REVERSE -- 
	 1.0	;	 %  496 k_166_cat
	 0.1	;	 %  497 K_166_FUM
	 0.1	;	 %  498 K_166_AICAR

	 % Reaction: 167 gltB_BG12594_1.4.1.13::FORWARD -- 
	 1.0	;	 %  499 k_167_cat
	 0.1	;	 %  500 K_167_GLN
	 0.1	;	 %  501 K_167_OGA
	 0.1	;	 %  502 K_167_NADPH

	 % Reaction: 168 gltB_BG12594_1.4.1.13::REVERSE -- 
	 1.0	;	 %  503 k_168_cat
	 0.1	;	 %  504 K_168_GLU
	 0.1	;	 %  505 K_168_NADP

	 % Reaction: 169 asnO_BG12240_6.3.5.4::FORWARD -- 
	 1.0	;	 %  506 k_169_cat
	 0.1	;	 %  507 K_169_GLN
	 0.1	;	 %  508 K_169_ASP
	 0.1	;	 %  509 K_169_ATP

	 % Reaction: 170 asnO_BG12240_6.3.5.4::REVERSE -- 
	 1.0	;	 %  510 k_170_cat
	 0.1	;	 %  511 K_170_GLU
	 0.1	;	 %  512 K_170_ASN
	 0.1	;	 %  513 K_170_PPI
	 0.1	;	 %  514 K_170_AMP

	 % Reaction: 171 pckA_BG11841_4.1.1.49::FORWARD -- 
	 1.0	;	 %  515 k_171_cat
	 0.1	;	 %  516 K_171_ATP
	 0.1	;	 %  517 K_171_OAA

	 % Reaction: 172 pckA_BG11841_4.1.1.49::REVERSE -- 
	 1.0	;	 %  518 k_172_cat
	 0.1	;	 %  519 K_172_ADP
	 0.1	;	 %  520 K_172_PEP
	 0.1	;	 %  521 K_172_CO2

	 % Reaction: 173 _SPONTANEOUS_::FORWARD -- 
	 1.0	;	 %  522 k_173_cat
	 0.1	;	 %  523 K_173_5-FORMYL-THF

	 % Reaction: 174 _SPONTANEOUS_::REVERSE -- 
	 1.0	;	 %  524 k_174_cat
	 0.1	;	 %  525 K_174_10-FORMYL-THF

	 % Reaction: 175 ybqJ_BG12753_3.5.1.2::FORWARD -- 
	 1.0	;	 %  526 k_175_cat
	 0.1	;	 %  527 K_175_ATP
	 0.1	;	 %  528 K_175_GLU
	 0.1	;	 %  529 K_175_NH3

	 % Reaction: 176 ybqJ_BG12753_3.5.1.2::REVERSE -- 
	 1.0	;	 %  530 k_176_cat
	 0.1	;	 %  531 K_176_ADP
	 0.1	;	 %  532 K_176_GLN
	 0.1	;	 %  533 K_176_PI

	 % Reaction: 177 yqkJ_BG11764_1.1.1.38::FORWARD -- 
	 1.0	;	 %  534 k_177_cat
	 0.1	;	 %  535 K_177_MAL
	 0.1	;	 %  536 K_177_NAD

	 % Reaction: 178 yqkJ_BG11764_1.1.1.38::REVERSE -- 
	 1.0	;	 %  537 k_178_cat
	 0.1	;	 %  538 K_178_PYR
	 0.1	;	 %  539 K_178_NADH
	 0.1	;	 %  540 K_178_CO2

	 % Reaction: 179 purU_ykkE_BG13237_3.5.1.10::FORWARD -- 
	 1.0	;	 %  541 k_179_cat
	 0.1	;	 %  542 K_179_10-FORMYL-THF

	 % Reaction: 180 purU_ykkE_BG13237_3.5.1.10::REVERSE -- 
	 1.0	;	 %  543 k_180_cat
	 0.1	;	 %  544 K_180_THF
	 0.1	;	 %  545 K_180_FOR

	 % Reaction: 181 fbaA_BG10412_4.1.2.13::FORWARD -- 
	 1.0	;	 %  546 k_181_cat
	 0.1	;	 %  547 K_181_F16BP

	 % Reaction: 182 fbaA_BG10412_4.1.2.13::REVERSE -- 
	 1.0	;	 %  548 k_182_cat
	 0.1	;	 %  549 K_182_GA3P
	 0.1	;	 %  550 K_182_DHAP

	 % Reaction: 183 alsS_BG10471_2.2.2.6::FORWARD -- 
	 1.0	;	 %  551 k_183_cat
	 0.1	;	 %  552 K_183_PYR

	 % Reaction: 184 alsS_BG10471_2.2.2.6::REVERSE -- 
	 1.0	;	 %  553 k_184_cat
	 0.1	;	 %  554 K_184_2-ACETO-LACTATE
	 0.1	;	 %  555 K_184_CO2

	 % Reaction: 185 ywfG_BG10631_2.6.1.1::FORWARD -- 
	 1.0	;	 %  556 k_185_cat
	 0.1	;	 %  557 K_185_PHENYL-PYRUVATE
	 0.1	;	 %  558 K_185_GLU

	 % Reaction: 186 ywfG_BG10631_2.6.1.1::REVERSE -- 
	 1.0	;	 %  559 k_186_cat
	 0.1	;	 %  560 K_186_OGA
	 0.1	;	 %  561 K_186_PHE

	 % Reaction: 187 dapG_lssD_BG10784_2.7.2.4::FORWARD -- 
	 1.0	;	 %  562 k_187_cat
	 0.1	;	 %  563 K_187_ASP
	 0.1	;	 %  564 K_187_ATP

	 % Reaction: 188 dapG_lssD_BG10784_2.7.2.4::REVERSE -- 
	 1.0	;	 %  565 k_188_cat
	 0.1	;	 %  566 K_188_L-BETA-ASPARTYL-P
	 0.1	;	 %  567 K_188_ADP

	 % Reaction: 189 gpsA_BG11366_1.1.1.94::FORWARD -- 
	 1.0	;	 %  568 k_189_cat
	 0.1	;	 %  569 K_189_GL3P
	 0.1	;	 %  570 K_189_NAD

	 % Reaction: 190 gpsA_BG11366_1.1.1.94::REVERSE -- 
	 1.0	;	 %  571 k_190_cat
	 0.1	;	 %  572 K_190_DHAP
	 0.1	;	 %  573 K_190_NADH

	 % Reaction: 191 yqeC_BG11631_1.1.1.44::FORWARD -- 
	 1.0	;	 %  574 k_191_cat
	 0.1	;	 %  575 K_191_6PDG
	 0.1	;	 %  576 K_191_NADP

	 % Reaction: 192 yqeC_BG11631_1.1.1.44::REVERSE -- 
	 1.0	;	 %  577 k_192_cat
	 0.1	;	 %  578 K_192_RU5P
	 0.1	;	 %  579 K_192_CO2
	 0.1	;	 %  580 K_192_NADPH

	 % Reaction: 193 NH3_TRANSPORT::FORWARD -- 
	 1.0	;	 %  581 k_193_cat
	 0.1	;	 %  582 K_193_NH3xt

	 % Reaction: 194 NH3_TRANSPORT::REVERSE -- 
	 1.0	;	 %  583 k_194_cat
	 0.1	;	 %  584 K_194_NH3

	 % Reaction: 195 _need_to_do::FORWARD -- 
	 1.0	;	 %  585 k_195_cat
	 0.1	;	 %  586 K_195_CYTD

	 % Reaction: 196 _need_to_do::REVERSE -- 
	 1.0	;	 %  587 k_196_cat
	 0.1	;	 %  588 K_196_URI
	 0.1	;	 %  589 K_196_NH3

	 % Reaction: 197 aspB_BG11513_2.6.1.1::FORWARD -- 
	 1.0	;	 %  590 k_197_cat
	 0.1	;	 %  591 K_197_OGA
	 0.1	;	 %  592 K_197_ASP

	 % Reaction: 198 aspB_BG11513_2.6.1.1::REVERSE -- 
	 1.0	;	 %  593 k_198_cat
	 0.1	;	 %  594 K_198_OAA
	 0.1	;	 %  595 K_198_GLU

	 % Reaction: 199 hack::FORWARD -- 
	 1.0	;	 %  596 k_199_cat
	 0.1	;	 %  597 K_199_ATP

	 % Reaction: 200 hack::REVERSE -- 
	 1.0	;	 %  598 k_200_cat
	 0.1	;	 %  599 K_200_ADP
	 0.1	;	 %  600 K_200_PI

	 % Reaction: 201 odhAB_BG10272_1.2.4.2::FORWARD -- 
	 1.0	;	 %  601 k_201_cat
	 0.1	;	 %  602 K_201_OGA
	 0.1	;	 %  603 K_201_NAD
	 0.1	;	 %  604 K_201_CoA

	 % Reaction: 202 odhAB_BG10272_1.2.4.2::REVERSE -- 
	 1.0	;	 %  605 k_202_cat
	 0.1	;	 %  606 K_202_CO2
	 0.1	;	 %  607 K_202_NADH
	 0.1	;	 %  608 K_202_SUCCCoA

	 % Reaction: 203 _NEED_TO_ASSIGN::FORWARD -- 
	 1.0	;	 %  609 k_203_cat
	 0.1	;	 %  610 K_203_3PG
	 0.1	;	 %  611 K_203_NAD
	 0.1	;	 %  612 K_203_GLU

	 % Reaction: 204 _NEED_TO_ASSIGN::REVERSE -- 
	 1.0	;	 %  613 k_204_cat
	 0.1	;	 %  614 K_204_SER
	 0.1	;	 %  615 K_204_NADH
	 0.1	;	 %  616 K_204_OGA
	 0.1	;	 %  617 K_204_PI

	 % Reaction: 205 aroK_aroI_BG10457_2.7.1.71::FORWARD -- 
	 1.0	;	 %  618 k_205_cat
	 0.1	;	 %  619 K_205_SHIKIMATE
	 0.1	;	 %  620 K_205_ATP

	 % Reaction: 206 aroK_aroI_BG10457_2.7.1.71::REVERSE -- 
	 1.0	;	 %  621 k_206_cat
	 0.1	;	 %  622 K_206_SHIKIMATE-5P
	 0.1	;	 %  623 K_206_ADP

	 % Reaction: 207 metC_BG12616_2.1.1.14::FORWARD -- 
	 1.0	;	 %  624 k_207_cat
	 0.1	;	 %  625 K_207_HCYS
	 0.1	;	 %  626 K_207_METHYLENE-THF

	 % Reaction: 208 metC_BG12616_2.1.1.14::REVERSE -- 
	 1.0	;	 %  627 k_208_cat
	 0.1	;	 %  628 K_208_MET
	 0.1	;	 %  629 K_208_THF

	 % Reaction: 209 asd_BG10783_1.2.1.11::FORWARD -- 
	 1.0	;	 %  630 k_209_cat
	 0.1	;	 %  631 K_209_NADPH
	 0.1	;	 %  632 K_209_L-BETA-ASPARTYL-P

	 % Reaction: 210 asd_BG10783_1.2.1.11::REVERSE -- 
	 1.0	;	 %  633 k_210_cat
	 0.1	;	 %  634 K_210_NADP
	 0.1	;	 %  635 K_210_PI
	 0.1	;	 %  636 K_210_ASPSALD

	 % Reaction: 211 ctrA_BG10410_6.3.4.2::FORWARD -- 
	 1.0	;	 %  637 k_211_cat
	 0.1	;	 %  638 K_211_ATP
	 0.1	;	 %  639 K_211_UTP
	 0.1	;	 %  640 K_211_NH3

	 % Reaction: 212 ctrA_BG10410_6.3.4.2::REVERSE -- 
	 1.0	;	 %  641 k_212_cat
	 0.1	;	 %  642 K_212_ADP
	 0.1	;	 %  643 K_212_PI
	 0.1	;	 %  644 K_212_CTP

	 % Reaction: 213 trpF_BG10289_5.3.1.24::FORWARD -- 
	 1.0	;	 %  645 k_213_cat
	 0.1	;	 %  646 K_213_|N-(5-PHOSPHORIBOSYL)-ANTHRANILATE|

	 % Reaction: 214 trpF_BG10289_5.3.1.24::REVERSE -- 
	 1.0	;	 %  647 k_214_cat
	 0.1	;	 %  648 K_214_CARBOXYPHENYLAMINO-DEOXYRIBULOSE-P

	 % Reaction: 215 yhdR_BG13024_2.6.1.1::FORWARD -- 
	 1.0	;	 %  649 k_215_cat
	 0.1	;	 %  650 K_215_ASP
	 0.1	;	 %  651 K_215_OGA

	 % Reaction: 216 yhdR_BG13024_2.6.1.1::REVERSE -- 
	 1.0	;	 %  652 k_216_cat
	 0.1	;	 %  653 K_216_OAA
	 0.1	;	 %  654 K_216_GLU

	 % Reaction: 217 _NEED_TO_DO::FORWARD -- 
	 1.0	;	 %  655 k_217_cat
	 0.1	;	 %  656 K_217_IMP
	 0.1	;	 %  657 K_217_ASP
	 0.1	;	 %  658 K_217_GTP

	 % Reaction: 218 _NEED_TO_DO::REVERSE -- 
	 1.0	;	 %  659 k_218_cat
	 0.1	;	 %  660 K_218_ASUCC
	 0.1	;	 %  661 K_218_PI
	 0.1	;	 %  662 K_218_GDP

	 % Reaction: 219 folD_BG11711_3.5.4.9::FORWARD -- 
	 1.0	;	 %  663 k_219_cat
	 0.1	;	 %  664 K_219_5_10-METHENYL-THF

	 % Reaction: 220 folD_BG11711_3.5.4.9::REVERSE -- 
	 1.0	;	 %  665 k_220_cat
	 0.1	;	 %  666 K_220_10-FORMYL-THF

	 % Reaction: 221 cysK_BG10136_2.5.1.47::FORWARD -- 
	 1.0	;	 %  667 k_221_cat
	 0.1	;	 %  668 K_221_ACETYLSERINE
	 0.1	;	 %  669 K_221_HS

	 % Reaction: 222 cysK_BG10136_2.5.1.47::REVERSE -- 
	 1.0	;	 %  670 k_222_cat
	 0.1	;	 %  671 K_222_CYS
	 0.1	;	 %  672 K_222_AC

	 % Reaction: 223 alsS_BG10471_2.2.1.6::FORWARD -- 
	 1.0	;	 %  673 k_223_cat
	 0.1	;	 %  674 K_223_PYR
	 0.1	;	 %  675 K_223_2-OXOBUTANOATE

	 % Reaction: 224 alsS_BG10471_2.2.1.6::REVERSE -- 
	 1.0	;	 %  676 k_224_cat
	 0.1	;	 %  677 K_224_2-ACETO-2-HYDROXY-BUTYRATE
	 0.1	;	 %  678 K_224_CO2

	 % Reaction: 225 ribC_BG11495_2.7.1.26::FORWARD -- 
	 1.0	;	 %  679 k_225_cat
	 0.1	;	 %  680 K_225_ATP
	 0.1	;	 %  681 K_225_RIBOFLAVIN

	 % Reaction: 226 ribC_BG11495_2.7.1.26::REVERSE -- 
	 1.0	;	 %  682 k_226_cat
	 0.1	;	 %  683 K_226_ADP
	 0.1	;	 %  684 K_226_FMN

	 % Reaction: 227 guaA_BG10647_6.3.5.2::FORWARD -- 
	 1.0	;	 %  685 k_227_cat
	 0.1	;	 %  686 K_227_ATP
	 0.1	;	 %  687 K_227_XMP
	 0.1	;	 %  688 K_227_GLN

	 % Reaction: 228 guaA_BG10647_6.3.5.2::REVERSE -- 
	 1.0	;	 %  689 k_228_cat
	 0.1	;	 %  690 K_228_AMP
	 0.1	;	 %  691 K_228_PPI
	 0.1	;	 %  692 K_228_GMP
	 0.1	;	 %  693 K_228_GLU

	 % Reaction: 229 ywfG_BG10631_2.6.1.1::FORWARD -- 
	 1.0	;	 %  694 k_229_cat
	 0.1	;	 %  695 K_229_P-HYDROXY-PHENYLPYRUVATE
	 0.1	;	 %  696 K_229_GLU

	 % Reaction: 230 ywfG_BG10631_2.6.1.1::REVERSE -- 
	 1.0	;	 %  697 k_230_cat
	 0.1	;	 %  698 K_230_OGA
	 0.1	;	 %  699 K_230_TYR

	 % Reaction: 231 nrdE_BG11404_1.17.4.1::FORWARD -- 
	 1.0	;	 %  700 k_231_cat
	 0.1	;	 %  701 K_231_CDP
	 0.1	;	 %  702 K_231_RTRD

	 % Reaction: 232 nrdE_BG11404_1.17.4.1::REVERSE -- 
	 1.0	;	 %  703 k_232_cat
	 0.1	;	 %  704 K_232_OTRD
	 0.1	;	 %  705 K_232_dCDP

	 % Reaction: 233 _SPONT_OR_UNKNOWN_::FORWARD -- 
	 1.0	;	 %  706 k_233_cat
	 0.1	;	 %  707 K_233_2-OXOBUTANOATE
	 0.1	;	 %  708 K_233_PI
	 0.1	;	 %  709 K_233_O2

	 % Reaction: 234 _SPONT_OR_UNKNOWN_::REVERSE -- 
	 1.0	;	 %  710 k_234_cat
	 0.1	;	 %  711 K_234_PROPIONYL-PHOSPHATE
	 0.1	;	 %  712 K_234_CO2

	 % Reaction: 235 proA_BG10964_1.2.1.41::FORWARD -- 
	 1.0	;	 %  713 k_235_cat
	 0.1	;	 %  714 K_235_L-GLUTAMATE-5P
	 0.1	;	 %  715 K_235_NADPH

	 % Reaction: 236 proA_BG10964_1.2.1.41::REVERSE -- 
	 1.0	;	 %  716 k_236_cat
	 0.1	;	 %  717 K_236_PYYCX
	 0.1	;	 %  718 K_236_NADP
	 0.1	;	 %  719 K_236_PI

	 % Reaction: 237 guaB_BG10073_1.1.1.205::FORWARD -- 
	 1.0	;	 %  720 k_237_cat
	 0.1	;	 %  721 K_237_IMP
	 0.1	;	 %  722 K_237_NAD

	 % Reaction: 238 guaB_BG10073_1.1.1.205::REVERSE -- 
	 1.0	;	 %  723 k_238_cat
	 0.1	;	 %  724 K_238_XMP
	 0.1	;	 %  725 K_238_NADH

	 % Reaction: 239 mtrA_BG10277_3.5.4.16::FORWARD -- 
	 1.0	;	 %  726 k_239_cat
	 0.1	;	 %  727 K_239_GTP

	 % Reaction: 240 mtrA_BG10277_3.5.4.16::REVERSE -- 
	 1.0	;	 %  728 k_240_cat
	 0.1	;	 %  729 K_240_FOR
	 0.1	;	 %  730 K_240_DIHYDRONEOPTERIN-P3

	 % Reaction: 241 pgi_BG12366_5.3.1.9::FORWARD -- 
	 1.0	;	 %  731 k_241_cat
	 0.1	;	 %  732 K_241_G6P

	 % Reaction: 242 pgi_BG12366_5.3.1.9::REVERSE -- 
	 1.0	;	 %  733 k_242_cat
	 0.1	;	 %  734 K_242_F6P

	 % Reaction: 243 relA_2.7.6.5::FORWARD -- 
	 1.0	;	 %  735 k_243_cat
	 0.1	;	 %  736 K_243_GTP
	 0.1	;	 %  737 K_243_ATP

	 % Reaction: 244 relA_2.7.6.5::REVERSE -- 
	 1.0	;	 %  738 k_244_cat
	 0.1	;	 %  739 K_244_ppGTP
	 0.1	;	 %  740 K_244_AMP

	 % Reaction: 245 ypcA_BG11435_1.4.1.2::FORWARD -- 
	 1.0	;	 %  741 k_245_cat
	 0.1	;	 %  742 K_245_OGA
	 0.1	;	 %  743 K_245_NH3
	 0.1	;	 %  744 K_245_NADH

	 % Reaction: 246 ypcA_BG11435_1.4.1.2::REVERSE -- 
	 1.0	;	 %  745 k_246_cat
	 0.1	;	 %  746 K_246_GLU
	 0.1	;	 %  747 K_246_NAD

	 % Reaction: 247 recS_recQ_BG11407_3.6.1.-::FORWARD -- 
	 1.0	;	 %  748 k_247_cat
	 0.1	;	 %  749 K_247_DIHYDRONEOPTERIN-P3

	 % Reaction: 248 recS_recQ_BG11407_3.6.1.-::REVERSE -- 
	 1.0	;	 %  750 k_248_cat
	 0.1	;	 %  751 K_248_DIHYDRONEOPTERIN-P
	 0.1	;	 %  752 K_248_PPI

	 % Reaction: 249 yclM_BG12033_2.7.2.4::FORWARD -- 
	 1.0	;	 %  753 k_249_cat
	 0.1	;	 %  754 K_249_ASP
	 0.1	;	 %  755 K_249_ATP

	 % Reaction: 250 yclM_BG12033_2.7.2.4::REVERSE -- 
	 1.0	;	 %  756 k_250_cat
	 0.1	;	 %  757 K_250_L-BETA-ASPARTYL-P
	 0.1	;	 %  758 K_250_ADP

	 % Reaction: 251 yrhE_BG12294_1.2.1.2::FORWARD -- 
	 1.0	;	 %  759 k_251_cat
	 0.1	;	 %  760 K_251_FOR
	 0.1	;	 %  761 K_251_NAD

	 % Reaction: 252 yrhE_BG12294_1.2.1.2::REVERSE -- 
	 1.0	;	 %  762 k_252_cat
	 0.1	;	 %  763 K_252_CO2
	 0.1	;	 %  764 K_252_NADH

	 % Reaction: 253 ackA_BG10813_2.7.2.1::FORWARD -- 
	 1.0	;	 %  765 k_253_cat
	 0.1	;	 %  766 K_253_ACP
	 0.1	;	 %  767 K_253_ADP

	 % Reaction: 254 ackA_BG10813_2.7.2.1::REVERSE -- 
	 1.0	;	 %  768 k_254_cat
	 0.1	;	 %  769 K_254_AC
	 0.1	;	 %  770 K_254_ATP

	 % Reaction: 255 trpD_BG10288_2.4.2.18::FORWARD -- 
	 1.0	;	 %  771 k_255_cat
	 0.1	;	 %  772 K_255_ANTHRANILATE
	 0.1	;	 %  773 K_255_PRPP

	 % Reaction: 256 trpD_BG10288_2.4.2.18::REVERSE -- 
	 1.0	;	 %  774 k_256_cat
	 0.1	;	 %  775 K_256_|N-(5-PHOSPHORIBOSYL)-ANTHRANILATE|
	 0.1	;	 %  776 K_256_PPI

	 % Reaction: 257 leuC_BG11949_4.2.1.33::FORWARD -- 
	 1.0	;	 %  777 k_257_cat
	 0.1	;	 %  778 K_257_3-CARBOXY-3-HYDROXY-ISOCAPROATE

	 % Reaction: 258 leuC_BG11949_4.2.1.33::REVERSE -- 
	 1.0	;	 %  779 k_258_cat
	 0.1	;	 %  780 K_258_2-D-THREO-HYDROXY-3-CARBOXY-ISOCAPROATE

	 % Reaction: 259 PPI_HACK::FORWARD -- 
	 1.0	;	 %  781 k_259_cat
	 0.1	;	 %  782 K_259_PPIxt

	 % Reaction: 260 PPI_HACK::REVERSE -- 
	 1.0	;	 %  783 k_260_cat
	 0.1	;	 %  784 K_260_PPI

	 % Reaction: 261 tmk_BG10092_2.7.4.9::FORWARD -- 
	 1.0	;	 %  785 k_261_cat
	 0.1	;	 %  786 K_261_dUDP
	 0.1	;	 %  787 K_261_ADP

	 % Reaction: 262 tmk_BG10092_2.7.4.9::REVERSE -- 
	 1.0	;	 %  788 k_262_cat
	 0.1	;	 %  789 K_262_dUMP
	 0.1	;	 %  790 K_262_ATP

	 % Reaction: 263 citB_BG10478_4.2.1.3::FORWARD -- 
	 1.0	;	 %  791 k_263_cat
	 0.1	;	 %  792 K_263_CIT

	 % Reaction: 264 citB_BG10478_4.2.1.3::REVERSE -- 
	 1.0	;	 %  793 k_264_cat
	 0.1	;	 %  794 K_264_ICIT

	 % Reaction: 265 aroF_BG10284_4.6.1.4::FORWARD -- 
	 1.0	;	 %  795 k_265_cat
	 0.1	;	 %  796 K_265_3-ENOLPYRUVYL-SHIKIMATE-5P

	 % Reaction: 266 aroF_BG10284_4.6.1.4::REVERSE -- 
	 1.0	;	 %  797 k_266_cat
	 0.1	;	 %  798 K_266_PI
	 0.1	;	 %  799 K_266_CHOR

	 % Reaction: 267 GDP_HACK::FORWARD -- 
	 1.0	;	 %  800 k_267_cat
	 0.1	;	 %  801 K_267_GDPxt

	 % Reaction: 268 GDP_HACK::REVERSE -- 
	 1.0	;	 %  802 k_268_cat
	 0.1	;	 %  803 K_268_GDP

	 % Reaction: 269 glnA_BG10425_6.3.1.2::FORWARD -- 
	 1.0	;	 %  804 k_269_cat
	 0.1	;	 %  805 K_269_ATP
	 0.1	;	 %  806 K_269_GLU
	 0.1	;	 %  807 K_269_NH3

	 % Reaction: 270 glnA_BG10425_6.3.1.2::REVERSE -- 
	 1.0	;	 %  808 k_270_cat
	 0.1	;	 %  809 K_270_ADP
	 0.1	;	 %  810 K_270_GLN
	 0.1	;	 %  811 K_270_PI

	 % Reaction: 271 citC_BG10856_1.1.1.42::FORWARD -- 
	 1.0	;	 %  812 k_271_cat
	 0.1	;	 %  813 K_271_ICIT
	 0.1	;	 %  814 K_271_NADP

	 % Reaction: 272 citC_BG10856_1.1.1.42::REVERSE -- 
	 1.0	;	 %  815 k_272_cat
	 0.1	;	 %  816 K_272_OGA
	 0.1	;	 %  817 K_272_CO2
	 0.1	;	 %  818 K_272_NADPH

	 % Reaction: 273 ytsJ_BG13922_1.1.1.38::FORWARD -- 
	 1.0	;	 %  819 k_273_cat
	 0.1	;	 %  820 K_273_MAL
	 0.1	;	 %  821 K_273_NAD

	 % Reaction: 274 ytsJ_BG13922_1.1.1.38::REVERSE -- 
	 1.0	;	 %  822 k_274_cat
	 0.1	;	 %  823 K_274_PYR
	 0.1	;	 %  824 K_274_NADH
	 0.1	;	 %  825 K_274_CO2

	 % Reaction: 275 hcrA_BG10662_1.5.1.12::FORWARD -- 
	 1.0	;	 %  826 k_275_cat
	 0.1	;	 %  827 K_275_PYYCX
	 0.1	;	 %  828 K_275_NADP

	 % Reaction: 276 hcrA_BG10662_1.5.1.12::REVERSE -- 
	 1.0	;	 %  829 k_276_cat
	 0.1	;	 %  830 K_276_GLU
	 0.1	;	 %  831 K_276_NADPH

	 % Reaction: 277 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  832 k_277_cat
	 0.1	;	 %  833 K_277_dUDP
	 0.1	;	 %  834 K_277_ATP

	 % Reaction: 278 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  835 k_278_cat
	 0.1	;	 %  836 K_278_dUTP
	 0.1	;	 %  837 K_278_ADP

	 % Reaction: 279 yqhS_BG11707_4.2.1.10::FORWARD -- 
	 1.0	;	 %  838 k_279_cat
	 0.1	;	 %  839 K_279_DEHYDROQUINATE

	 % Reaction: 280 yqhS_BG11707_4.2.1.10::REVERSE -- 
	 1.0	;	 %  840 k_280_cat
	 0.1	;	 %  841 K_280_3-DEHYDRO-SHIKIMATE

	 % Reaction: 281 glpK_2.7.1.30::FORWARD -- 
	 1.0	;	 %  842 k_281_cat
	 0.1	;	 %  843 K_281_GL
	 0.1	;	 %  844 K_281_ATP

	 % Reaction: 282 glpK_2.7.1.30::REVERSE -- 
	 1.0	;	 %  845 k_282_cat
	 0.1	;	 %  846 K_282_GL3P
	 0.1	;	 %  847 K_282_ADP

	 % Reaction: 283 ureB_BG11982_3.5.1.5::FORWARD -- 
	 1.0	;	 %  848 k_283_cat
	 0.1	;	 %  849 K_283_UREA

	 % Reaction: 284 ureB_BG11982_3.5.1.5::REVERSE -- 
	 1.0	;	 %  850 k_284_cat
	 0.1	;	 %  851 K_284_NH3
	 0.1	;	 %  852 K_284_CO2

	 % Reaction: 285 ndhF_BG10949_1.6.5.3::FORWARD -- 
	 1.0	;	 %  853 k_285_cat
	 0.1	;	 %  854 K_285_NADH
	 0.1	;	 %  855 K_285_Q1

	 % Reaction: 286 ndhF_BG10949_1.6.5.3::REVERSE -- 
	 1.0	;	 %  856 k_286_cat
	 0.1	;	 %  857 K_286_NAD
	 0.1	;	 %  858 K_286_Q2

	 % Reaction: 287 lysC_BG10350_2.7.2.4::FORWARD -- 
	 1.0	;	 %  859 k_287_cat
	 0.1	;	 %  860 K_287_ASP
	 0.1	;	 %  861 K_287_ATP

	 % Reaction: 288 lysC_BG10350_2.7.2.4::REVERSE -- 
	 1.0	;	 %  862 k_288_cat
	 0.1	;	 %  863 K_288_L-BETA-ASPARTYL-P
	 0.1	;	 %  864 K_288_ADP

	 % Reaction: 289 sul_BG10140_2.5.1.15::FORWARD -- 
	 1.0	;	 %  865 k_289_cat
	 0.1	;	 %  866 K_289_4-AMINOBENZOATE
	 0.1	;	 %  867 K_289_DIHYDROPTERIN-CH2OH-PP

	 % Reaction: 290 sul_BG10140_2.5.1.15::REVERSE -- 
	 1.0	;	 %  868 k_290_cat
	 0.1	;	 %  869 K_290_7_8-DIHYDROPTEROATE
	 0.1	;	 %  870 K_290_PPI

	 % Reaction: 291 aceA::FORWARD -- 
	 1.0	;	 %  871 k_291_cat
	 0.1	;	 %  872 K_291_ICIT

	 % Reaction: 292 aceA::REVERSE -- 
	 1.0	;	 %  873 k_292_cat
	 0.1	;	 %  874 K_292_GLX
	 0.1	;	 %  875 K_292_SUCC

	 % Reaction: 293 rocA_BG10622_1.5.1.12::FORWARD -- 
	 1.0	;	 %  876 k_293_cat
	 0.1	;	 %  877 K_293_GLU
	 0.1	;	 %  878 K_293_NADPH

	 % Reaction: 294 rocA_BG10622_1.5.1.12::REVERSE -- 
	 1.0	;	 %  879 k_294_cat
	 0.1	;	 %  880 K_294_L-GLUTAMTE-5-SA
	 0.1	;	 %  881 K_294_NADP

	 % Reaction: 295 ribA_BG10520_3.5.4.25::FORWARD -- 
	 1.0	;	 %  882 k_295_cat
	 0.1	;	 %  883 K_295_GTP

	 % Reaction: 296 ribA_BG10520_3.5.4.25::REVERSE -- 
	 1.0	;	 %  884 k_296_cat
	 0.1	;	 %  885 K_296_C01304
	 0.1	;	 %  886 K_296_FOR
	 0.1	;	 %  887 K_296_PPI

	 % Reaction: 297 qcrA_BG11325_1.10.2.2::FORWARD -- 
	 1.0	;	 %  888 k_297_cat
	 0.1	;	 %  889 K_297_Q2
	 0.1	;	 %  890 K_297_Fi-c

	 % Reaction: 298 qcrA_BG11325_1.10.2.2::REVERSE -- 
	 1.0	;	 %  891 k_298_cat
	 0.1	;	 %  892 K_298_Q1
	 0.1	;	 %  893 K_298_Fo-c
	 0.1	;	 %  894 K_298_HEXT

	 % Reaction: 299 pheB_BG10913_5.4.99.5::FORWARD -- 
	 1.0	;	 %  895 k_299_cat
	 0.1	;	 %  896 K_299_CHOR

	 % Reaction: 300 pheB_BG10913_5.4.99.5::REVERSE -- 
	 1.0	;	 %  897 k_300_cat
	 0.1	;	 %  898 K_300_PREPHENATE

	 % Reaction: 301 rocA_BG10622_1.5.1.12::FORWARD -- 
	 1.0	;	 %  899 k_301_cat
	 0.1	;	 %  900 K_301_GLU
	 0.1	;	 %  901 K_301_NADH

	 % Reaction: 302 rocA_BG10622_1.5.1.12::REVERSE -- 
	 1.0	;	 %  902 k_302_cat
	 0.1	;	 %  903 K_302_PYYCX
	 0.1	;	 %  904 K_302_NAD

	 % Reaction: 303 pheA_BG10914_4.2.1.51::FORWARD -- 
	 1.0	;	 %  905 k_303_cat
	 0.1	;	 %  906 K_303_PREPHENATE

	 % Reaction: 304 pheA_BG10914_4.2.1.51::REVERSE -- 
	 1.0	;	 %  907 k_304_cat
	 0.1	;	 %  908 K_304_PHENYL-PYRUVATE
	 0.1	;	 %  909 K_304_CO2

	 % Reaction: 305 yhdR_BG13024_2.6.1.1::FORWARD -- 
	 1.0	;	 %  910 k_305_cat
	 0.1	;	 %  911 K_305_OGA
	 0.1	;	 %  912 K_305_ASP

	 % Reaction: 306 yhdR_BG13024_2.6.1.1::REVERSE -- 
	 1.0	;	 %  913 k_306_cat
	 0.1	;	 %  914 K_306_OAA
	 0.1	;	 %  915 K_306_GLU

	 % Reaction: 307 rocD_BG10722_2.6.1.13::FORWARD -- 
	 1.0	;	 %  916 k_307_cat
	 0.1	;	 %  917 K_307_L-GLUTAMTE-5-SA
	 0.1	;	 %  918 K_307_GLU

	 % Reaction: 308 rocD_BG10722_2.6.1.13::REVERSE -- 
	 1.0	;	 %  919 k_308_cat
	 0.1	;	 %  920 K_308_OGA
	 0.1	;	 %  921 K_308_ORN

	 % Reaction: 309 alsS_BG10471_2.2.1.6::FORWARD -- 
	 1.0	;	 %  922 k_309_cat
	 0.1	;	 %  923 K_309_PYR

	 % Reaction: 310 alsS_BG10471_2.2.1.6::REVERSE -- 
	 1.0	;	 %  924 k_310_cat
	 0.1	;	 %  925 K_310_2-ACETOLACTATE
	 0.1	;	 %  926 K_310_CO2

	 % Reaction: 311 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  927 k_311_cat
	 0.1	;	 %  928 K_311_UDP
	 0.1	;	 %  929 K_311_ATP

	 % Reaction: 312 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  930 k_312_cat
	 0.1	;	 %  931 K_312_UTP
	 0.1	;	 %  932 K_312_ADP

	 % Reaction: 313 PTS::FORWARD -- 
	 1.0	;	 %  933 k_313_cat
	 0.1	;	 %  934 K_313_GLC
	 0.1	;	 %  935 K_313_PEP

	 % Reaction: 314 PTS::REVERSE -- 
	 1.0	;	 %  936 k_314_cat
	 0.1	;	 %  937 K_314_G6P
	 0.1	;	 %  938 K_314_PYR

	 % Reaction: 315 ackA_BG10813_2.7.2.1::FORWARD -- 
	 1.0	;	 %  939 k_315_cat
	 0.1	;	 %  940 K_315_ADP
	 0.1	;	 %  941 K_315_PROPIONYL-PHOSPHATE

	 % Reaction: 316 ackA_BG10813_2.7.2.1::REVERSE -- 
	 1.0	;	 %  942 k_316_cat
	 0.1	;	 %  943 K_316_ATP
	 0.1	;	 %  944 K_316_PROPANOATE

	 % Reaction: 317 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  945 k_317_cat
	 0.1	;	 %  946 K_317_CTP
	 0.1	;	 %  947 K_317_ADP

	 % Reaction: 318 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  948 k_318_cat
	 0.1	;	 %  949 K_318_ATP
	 0.1	;	 %  950 K_318_CDP

	 % Reaction: 319 _SPONT_::FORWARD -- 
	 1.0	;	 %  951 k_319_cat
	 0.1	;	 %  952 K_319_L-GLUTAMTE-5-SA

	 % Reaction: 320 _SPONT_::REVERSE -- 
	 1.0	;	 %  953 k_320_cat
	 0.1	;	 %  954 K_320_PYYCX

	 % Reaction: 321 ndk_BBG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  955 k_321_cat
	 0.1	;	 %  956 K_321_UTP
	 0.1	;	 %  957 K_321_ADP

	 % Reaction: 322 ndk_BBG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  958 k_322_cat
	 0.1	;	 %  959 K_322_ATP
	 0.1	;	 %  960 K_322_UDP

	 % Reaction: 323 PI_transfer::FORWARD -- 
	 1.0	;	 %  961 k_323_cat
	 0.1	;	 %  962 K_323_PIxt

	 % Reaction: 324 PI_transfer::REVERSE -- 
	 1.0	;	 %  963 k_324_cat
	 0.1	;	 %  964 K_324_PI

	 % Reaction: 325 thrB_thrA_BG10462_2.7.1.39::FORWARD -- 
	 1.0	;	 %  965 k_325_cat
	 0.1	;	 %  966 K_325_HSER
	 0.1	;	 %  967 K_325_ATP

	 % Reaction: 326 thrB_thrA_BG10462_2.7.1.39::REVERSE -- 
	 1.0	;	 %  968 k_326_cat
	 0.1	;	 %  969 K_326_O-PHOSPHO-L-HOMOSERINE
	 0.1	;	 %  970 K_326_ADP

	 % Reaction: 327 tyrA_BG10293_1.3.1.12::FORWARD -- 
	 1.0	;	 %  971 k_327_cat
	 0.1	;	 %  972 K_327_PREPHENATE
	 0.1	;	 %  973 K_327_NAD

	 % Reaction: 328 tyrA_BG10293_1.3.1.12::REVERSE -- 
	 1.0	;	 %  974 k_328_cat
	 0.1	;	 %  975 K_328_P-HYDROXY-PHENYLPYRUVATE
	 0.1	;	 %  976 K_328_CO2
	 0.1	;	 %  977 K_328_NADH

	 % Reaction: 329 gltA_BG10811_1.4.1.13::FORWARD -- 
	 1.0	;	 %  978 k_329_cat
	 0.1	;	 %  979 K_329_GLN
	 0.1	;	 %  980 K_329_OGA
	 0.1	;	 %  981 K_329_NADPH

	 % Reaction: 330 gltA_BG10811_1.4.1.13::REVERSE -- 
	 1.0	;	 %  982 k_330_cat
	 0.1	;	 %  983 K_330_GLU
	 0.1	;	 %  984 K_330_NADP

	 % Reaction: 331 yflL_BG12947_3.6.1.7::FORWARD -- 
	 1.0	;	 %  985 k_331_cat
	 0.1	;	 %  986 K_331_G13P

	 % Reaction: 332 yflL_BG12947_3.6.1.7::REVERSE -- 
	 1.0	;	 %  987 k_332_cat
	 0.1	;	 %  988 K_332_3PG
	 0.1	;	 %  989 K_332_PI

	 % Reaction: 333 ywjI_BG10415_3.1.3.11::FORWARD -- 
	 1.0	;	 %  990 k_333_cat
	 0.1	;	 %  991 K_333_F16BP

	 % Reaction: 334 ywjI_BG10415_3.1.3.11::REVERSE -- 
	 1.0	;	 %  992 k_334_cat
	 0.1	;	 %  993 K_334_F6P
	 0.1	;	 %  994 K_334_PI

	 % Reaction: 335 hisD_BG12599_1.1.1.23::FORWARD -- 
	 1.0	;	 %  995 k_335_cat
	 0.1	;	 %  996 K_335_HISTIDINAL
	 0.1	;	 %  997 K_335_NAD

	 % Reaction: 336 hisD_BG12599_1.1.1.23::REVERSE -- 
	 1.0	;	 %  998 k_336_cat
	 0.1	;	 %  999 K_336_HIS
	 0.1	;	 %  1000 K_336_NADH

	 % Reaction: 337 alr_BG10950_5.1.1.1::FORWARD -- 
	 1.0	;	 %  1001 k_337_cat
	 0.1	;	 %  1002 K_337_ALA

	 % Reaction: 338 alr_BG10950_5.1.1.1::REVERSE -- 
	 1.0	;	 %  1003 k_338_cat
	 0.1	;	 %  1004 K_338_D-ALANINE

	 % Reaction: 339 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1005 k_339_cat
	 0.1	;	 %  1006 K_339_TMP
	 0.1	;	 %  1007 K_339_ATP

	 % Reaction: 340 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1008 k_340_cat
	 0.1	;	 %  1009 K_340_TDP
	 0.1	;	 %  1010 K_340_ADP

	 % Reaction: 341 ydaP_BG12063_1.2.3.3::FORWARD -- 
	 1.0	;	 %  1011 k_341_cat
	 0.1	;	 %  1012 K_341_PYR
	 0.1	;	 %  1013 K_341_PI
	 0.1	;	 %  1014 K_341_O2

	 % Reaction: 342 ydaP_BG12063_1.2.3.3::REVERSE -- 
	 1.0	;	 %  1015 k_342_cat
	 0.1	;	 %  1016 K_342_ACP
	 0.1	;	 %  1017 K_342_CO2

	 % Reaction: 343 proJ_BG12658_2.7.2.11::FORWARD -- 
	 1.0	;	 %  1018 k_343_cat
	 0.1	;	 %  1019 K_343_GLU
	 0.1	;	 %  1020 K_343_ATP

	 % Reaction: 344 proJ_BG12658_2.7.2.11::REVERSE -- 
	 1.0	;	 %  1021 k_344_cat
	 0.1	;	 %  1022 K_344_L-GLUTAMATE-5P
	 0.1	;	 %  1023 K_344_ADP

	 % Reaction: 345 ribH_BG10521_2.5.1.9(B)::FORWARD -- 
	 1.0	;	 %  1024 k_345_cat
	 0.1	;	 %  1025 K_345_DRL

	 % Reaction: 346 ribH_BG10521_2.5.1.9(B)::REVERSE -- 
	 1.0	;	 %  1026 k_346_cat
	 0.1	;	 %  1027 K_346_RIBOFLAVIN
	 0.1	;	 %  1028 K_346_RAU

	 % Reaction: 347 trpA_BG10291_4.2.1.20::FORWARD -- 
	 1.0	;	 %  1029 k_347_cat
	 0.1	;	 %  1030 K_347_INDOLE-3-GLYCEROL-P
	 0.1	;	 %  1031 K_347_SER

	 % Reaction: 348 trpA_BG10291_4.2.1.20::REVERSE -- 
	 1.0	;	 %  1032 k_348_cat
	 0.1	;	 %  1033 K_348_TRP
	 0.1	;	 %  1034 K_348_GA3P

	 % Reaction: 349 lysA_BG10510_4.1.1.20::FORWARD -- 
	 1.0	;	 %  1035 k_349_cat
	 0.1	;	 %  1036 K_349_DIAMPIM

	 % Reaction: 350 lysA_BG10510_4.1.1.20::REVERSE -- 
	 1.0	;	 %  1037 k_350_cat
	 0.1	;	 %  1038 K_350_CO2
	 0.1	;	 %  1039 K_350_LYS

	 % Reaction: 351 ribH::FORWARD -- 
	 1.0	;	 %  1040 k_351_cat
	 0.1	;	 %  1041 K_351_DBP
	 0.1	;	 %  1042 K_351_APD

	 % Reaction: 352 ribH::REVERSE -- 
	 1.0	;	 %  1043 k_352_cat
	 0.1	;	 %  1044 K_352_DRL
	 0.1	;	 %  1045 K_352_PI

	 % Reaction: 353 ilvC_BG10672_1.1.1.86::FORWARD -- 
	 1.0	;	 %  1046 k_353_cat
	 0.1	;	 %  1047 K_353_2-ACETO-2-HYDROXY-BUTYRATE
	 0.1	;	 %  1048 K_353_NADPH

	 % Reaction: 354 ilvC_BG10672_1.1.1.86::REVERSE -- 
	 1.0	;	 %  1049 k_354_cat
	 0.1	;	 %  1050 K_354_1-KETO-2-METHYLVALERATE
	 0.1	;	 %  1051 K_354_NADP

	 % Reaction: 355 ywjH_BG10413_2.2.1.2::FORWARD -- 
	 1.0	;	 %  1052 k_355_cat
	 0.1	;	 %  1053 K_355_S7P
	 0.1	;	 %  1054 K_355_GA3P

	 % Reaction: 356 ywjH_BG10413_2.2.1.2::REVERSE -- 
	 1.0	;	 %  1055 k_356_cat
	 0.1	;	 %  1056 K_356_E4P
	 0.1	;	 %  1057 K_356_F6P

	 % Reaction: 357 comEB_BG10481_3.5.4.12::FORWARD -- 
	 1.0	;	 %  1058 k_357_cat
	 0.1	;	 %  1059 K_357_dUMP
	 0.1	;	 %  1060 K_357_NH3

	 % Reaction: 358 comEB_BG10481_3.5.4.12::REVERSE -- 
	 1.0	;	 %  1061 k_358_cat
	 0.1	;	 %  1062 K_358_dCMP

	 % Reaction: 359 panE_1.1.1.169::FORWARD -- 
	 1.0	;	 %  1063 k_359_cat
	 0.1	;	 %  1064 K_359_AKP
	 0.1	;	 %  1065 K_359_NADPH

	 % Reaction: 360 panE_1.1.1.169::REVERSE -- 
	 1.0	;	 %  1066 k_360_cat
	 0.1	;	 %  1067 K_360_NADP
	 0.1	;	 %  1068 K_360_PANT

	 % Reaction: 361 ansB_BG10301_4.3.1.1::FORWARD -- 
	 1.0	;	 %  1069 k_361_cat
	 0.1	;	 %  1070 K_361_FUM
	 0.1	;	 %  1071 K_361_NH3

	 % Reaction: 362 ansB_BG10301_4.3.1.1::REVERSE -- 
	 1.0	;	 %  1072 k_362_cat
	 0.1	;	 %  1073 K_362_ASP

	 % Reaction: 363 ansA_BG10300_3.5.1.1::FORWARD -- 
	 1.0	;	 %  1074 k_363_cat
	 0.1	;	 %  1075 K_363_ASN

	 % Reaction: 364 ansA_BG10300_3.5.1.1::REVERSE -- 
	 1.0	;	 %  1076 k_364_cat
	 0.1	;	 %  1077 K_364_ASP
	 0.1	;	 %  1078 K_364_NH3

	 % Reaction: 365 purH_BG10710_2.1.2.3::FORWARD -- 
	 1.0	;	 %  1079 k_365_cat
	 0.1	;	 %  1080 K_365_AICAR
	 0.1	;	 %  1081 K_365_10-FORMYL-THF

	 % Reaction: 366 purH_BG10710_2.1.2.3::REVERSE -- 
	 1.0	;	 %  1082 k_366_cat
	 0.1	;	 %  1083 K_366_THF
	 0.1	;	 %  1084 K_366_PRFICA

	 % Reaction: 367 nrdE_BG11404_1.17.4.1::FORWARD -- 
	 1.0	;	 %  1085 k_367_cat
	 0.1	;	 %  1086 K_367_UDP
	 0.1	;	 %  1087 K_367_RTRD

	 % Reaction: 368 nrdE_BG11404_1.17.4.1::REVERSE -- 
	 1.0	;	 %  1088 k_368_cat
	 0.1	;	 %  1089 K_368_OTRD
	 0.1	;	 %  1090 K_368_dUDP

	 % Reaction: 369 yybQ_BG10014_3.6.1.1::FORWARD -- 
	 1.0	;	 %  1091 k_369_cat
	 0.1	;	 %  1092 K_369_PPI

	 % Reaction: 370 yybQ_BG10014_3.6.1.1::REVERSE -- 
	 1.0	;	 %  1093 k_370_cat
	 0.1	;	 %  1094 K_370_PI

	 % Reaction: 371 hisG_BG12601_2.4.2.17::FORWARD -- 
	 1.0	;	 %  1095 k_371_cat
	 0.1	;	 %  1096 K_371_ATP
	 0.1	;	 %  1097 K_371_PRPP

	 % Reaction: 372 hisG_BG12601_2.4.2.17::REVERSE -- 
	 1.0	;	 %  1098 k_372_cat
	 0.1	;	 %  1099 K_372_PHOSPHORIBOSYL-ATP
	 0.1	;	 %  1100 K_372_PPI

	 % Reaction: 373 cmk_BG11004_2.7.4.14::FORWARD -- 
	 1.0	;	 %  1101 k_373_cat
	 0.1	;	 %  1102 K_373_ATP
	 0.1	;	 %  1103 K_373_dCMP

	 % Reaction: 374 cmk_BG11004_2.7.4.14::REVERSE -- 
	 1.0	;	 %  1104 k_374_cat
	 0.1	;	 %  1105 K_374_ADP
	 0.1	;	 %  1106 K_374_dCDP

	 % Reaction: 375 HEX::FORWARD -- 
	 1.0	;	 %  1107 k_375_cat
	 0.1	;	 %  1108 K_375_GLC
	 0.1	;	 %  1109 K_375_ATP

	 % Reaction: 376 HEX::REVERSE -- 
	 1.0	;	 %  1110 k_376_cat
	 0.1	;	 %  1111 K_376_G6P
	 0.1	;	 %  1112 K_376_ADP

	 % Reaction: 377 O2_transfer::FORWARD -- 
	 1.0	;	 %  1113 k_377_cat
	 0.1	;	 %  1114 K_377_O2xt

	 % Reaction: 378 O2_transfer::REVERSE -- 
	 1.0	;	 %  1115 k_378_cat
	 0.1	;	 %  1116 K_378_O2

	 % Reaction: 379 purM_BG10708_6.3.3.1::FORWARD -- 
	 1.0	;	 %  1117 k_379_cat
	 0.1	;	 %  1118 K_379_FGAM
	 0.1	;	 %  1119 K_379_ATP

	 % Reaction: 380 purM_BG10708_6.3.3.1::REVERSE -- 
	 1.0	;	 %  1120 k_380_cat
	 0.1	;	 %  1121 K_380_ADP
	 0.1	;	 %  1122 K_380_PI
	 0.1	;	 %  1123 K_380_AIR

	 % Reaction: 381 AMP_HACK::FORWARD -- 
	 1.0	;	 %  1124 k_381_cat
	 0.1	;	 %  1125 K_381_AMPxt

	 % Reaction: 382 AMP_HACK::REVERSE -- 
	 1.0	;	 %  1126 k_382_cat
	 0.1	;	 %  1127 K_382_AMP

	 % Reaction: 383 purQ_BG10706_6.3.5.3::FORWARD -- 
	 1.0	;	 %  1128 k_383_cat
	 0.1	;	 %  1129 K_383_FGAR
	 0.1	;	 %  1130 K_383_ATP
	 0.1	;	 %  1131 K_383_GLN

	 % Reaction: 384 purQ_BG10706_6.3.5.3::REVERSE -- 
	 1.0	;	 %  1132 k_384_cat
	 0.1	;	 %  1133 K_384_GLU
	 0.1	;	 %  1134 K_384_ADP
	 0.1	;	 %  1135 K_384_PI
	 0.1	;	 %  1136 K_384_FGAM

	 % Reaction: 385 ribG_BG10518_1.1.1.193::FORWARD -- 
	 1.0	;	 %  1137 k_385_cat
	 0.1	;	 %  1138 K_385_C01268
	 0.1	;	 %  1139 K_385_NADPH

	 % Reaction: 386 ribG_BG10518_1.1.1.193::REVERSE -- 
	 1.0	;	 %  1140 k_386_cat
	 0.1	;	 %  1141 K_386_APD
	 0.1	;	 %  1142 K_386_NADP
	 0.1	;	 %  1143 K_386_PI

	 % Reaction: 387 purK_BG10701_4.1.1.21::FORWARD -- 
	 1.0	;	 %  1144 k_387_cat
	 0.1	;	 %  1145 K_387_AIR
	 0.1	;	 %  1146 K_387_CO2
	 0.1	;	 %  1147 K_387_ATP

	 % Reaction: 388 purK_BG10701_4.1.1.21::REVERSE -- 
	 1.0	;	 %  1148 k_388_cat
	 0.1	;	 %  1149 K_388_NCAIR
	 0.1	;	 %  1150 K_388_ADP
	 0.1	;	 %  1151 K_388_PI

	 % Reaction: 389 yjcI_BG13162_2.5.1.48::FORWARD -- 
	 1.0	;	 %  1152 k_389_cat
	 0.1	;	 %  1153 K_389_CYS
	 0.1	;	 %  1154 K_389_O-SUCCINYL-L-HOMOSERINE

	 % Reaction: 390 yjcI_BG13162_2.5.1.48::REVERSE -- 
	 1.0	;	 %  1155 k_390_cat
	 0.1	;	 %  1156 K_390_SUCC
	 0.1	;	 %  1157 K_390_L-CYSTATHIONINE

	 % Reaction: 391 purF_BG10707_2.4.2.14::FORWARD -- 
	 1.0	;	 %  1158 k_391_cat
	 0.1	;	 %  1159 K_391_PRPP
	 0.1	;	 %  1160 K_391_GLN

	 % Reaction: 392 purF_BG10707_2.4.2.14::REVERSE -- 
	 1.0	;	 %  1161 k_392_cat
	 0.1	;	 %  1162 K_392_PPI
	 0.1	;	 %  1163 K_392_GLU
	 0.1	;	 %  1164 K_392_PRAM

	 % Reaction: 393 _NEED_TO_DO::FORWARD -- 
	 1.0	;	 %  1165 k_393_cat
	 0.1	;	 %  1166 K_393_GLY
	 0.1	;	 %  1167 K_393_THF
	 0.1	;	 %  1168 K_393_NAD

	 % Reaction: 394 _NEED_TO_DO::REVERSE -- 
	 1.0	;	 %  1169 k_394_cat
	 0.1	;	 %  1170 K_394_METHYLENE-THF
	 0.1	;	 %  1171 K_394_NH3
	 0.1	;	 %  1172 K_394_CO2
	 0.1	;	 %  1173 K_394_NADH

	 % Reaction: 395 PRODUCTION::FORWARD -- 
	 1.0	;	 %  1174 k_395_cat
	 0.1	;	 %  1175 K_395_ALA
	 0.1	;	 %  1176 K_395_ASN
	 0.1	;	 %  1177 K_395_ARG
	 0.1	;	 %  1178 K_395_ASP
	 0.1	;	 %  1179 K_395_GLU
	 0.1	;	 %  1180 K_395_GLN
	 0.1	;	 %  1181 K_395_GLY
	 0.1	;	 %  1182 K_395_HIS
	 0.1	;	 %  1183 K_395_ILE
	 0.1	;	 %  1184 K_395_LEU
	 0.1	;	 %  1185 K_395_LYS
	 0.1	;	 %  1186 K_395_MET
	 0.1	;	 %  1187 K_395_PHE
	 0.1	;	 %  1188 K_395_PRO
	 0.1	;	 %  1189 K_395_SER
	 0.1	;	 %  1190 K_395_THR
	 0.1	;	 %  1191 K_395_TRP
	 0.1	;	 %  1192 K_395_TYR
	 0.1	;	 %  1193 K_395_VAL
	 0.1	;	 %  1194 K_395_ATP
	 0.1	;	 %  1195 K_395_GTP

	 % Reaction: 396 PRODUCTION::REVERSE -- 
	 1.0	;	 %  1196 k_396_cat
	 0.1	;	 %  1197 K_396_AMP
	 0.1	;	 %  1198 K_396_GDP
	 0.1	;	 %  1199 K_396_PPI
	 0.1	;	 %  1200 K_396_PI
	 0.1	;	 %  1201 K_396_PRODUCT

	 % Reaction: 397 purD_BG10711_6.3.4.13::FORWARD -- 
	 1.0	;	 %  1202 k_397_cat
	 0.1	;	 %  1203 K_397_ATP
	 0.1	;	 %  1204 K_397_PRAM
	 0.1	;	 %  1205 K_397_GLY

	 % Reaction: 398 purD_BG10711_6.3.4.13::REVERSE -- 
	 1.0	;	 %  1206 k_398_cat
	 0.1	;	 %  1207 K_398_ADP
	 0.1	;	 %  1208 K_398_PI
	 0.1	;	 %  1209 K_398_GAR

	 % Reaction: 399 asnB_BG11831_6.3.5.4::FORWARD -- 
	 1.0	;	 %  1210 k_399_cat
	 0.1	;	 %  1211 K_399_GLN
	 0.1	;	 %  1212 K_399_ASP
	 0.1	;	 %  1213 K_399_ATP

	 % Reaction: 400 asnB_BG11831_6.3.5.4::REVERSE -- 
	 1.0	;	 %  1214 k_400_cat
	 0.1	;	 %  1215 K_400_GLU
	 0.1	;	 %  1216 K_400_ASN
	 0.1	;	 %  1217 K_400_PPI
	 0.1	;	 %  1218 K_400_AMP

	 % Reaction: 401 panD_4.1.1.11::FORWARD -- 
	 1.0	;	 %  1219 k_401_cat
	 0.1	;	 %  1220 K_401_ASP

	 % Reaction: 402 panD_4.1.1.11::REVERSE -- 
	 1.0	;	 %  1221 k_402_cat
	 0.1	;	 %  1222 K_402_CO2
	 0.1	;	 %  1223 K_402_bALA

	 % Reaction: 403 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1224 k_403_cat
	 0.1	;	 %  1225 K_403_GDP
	 0.1	;	 %  1226 K_403_ATP

	 % Reaction: 404 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1227 k_404_cat
	 0.1	;	 %  1228 K_404_GTP
	 0.1	;	 %  1229 K_404_ADP

	 % Reaction: 405 _UNKNOWN_3.6.1.40::FORWARD -- 
	 1.0	;	 %  1230 k_405_cat
	 0.1	;	 %  1231 K_405_ppGTP

	 % Reaction: 406 _UNKNOWN_3.6.1.40::REVERSE -- 
	 1.0	;	 %  1232 k_406_cat
	 0.1	;	 %  1233 K_406_ppGDP
	 0.1	;	 %  1234 K_406_PI

	 % Reaction: 407 yflL_BG12947_3.6.1.7::FORWARD -- 
	 1.0	;	 %  1235 k_407_cat
	 0.1	;	 %  1236 K_407_ACP

	 % Reaction: 408 yflL_BG12947_3.6.1.7::REVERSE -- 
	 1.0	;	 %  1237 k_408_cat
	 0.1	;	 %  1238 K_408_AC
	 0.1	;	 %  1239 K_408_PI

	 % Reaction: 409 _UNKNOWN_3.1.7.2::FORWARD -- 
	 1.0	;	 %  1240 k_409_cat
	 0.1	;	 %  1241 K_409_ppGDP

	 % Reaction: 410 _UNKNOWN_3.1.7.2::REVERSE -- 
	 1.0	;	 %  1242 k_410_cat
	 0.1	;	 %  1243 K_410_GDP
	 0.1	;	 %  1244 K_410_PPI

	 % Reaction: 411 lctE_BG19003_1.1.1.27::FORWARD -- 
	 1.0	;	 %  1245 k_411_cat
	 0.1	;	 %  1246 K_411_PYR
	 0.1	;	 %  1247 K_411_NADH

	 % Reaction: 412 lctE_BG19003_1.1.1.27::REVERSE -- 
	 1.0	;	 %  1248 k_412_cat
	 0.1	;	 %  1249 K_412_LAC
	 0.1	;	 %  1250 K_412_NAD

	 % Reaction: 413 ribC_BG11495_2.7.7.2::FORWARD -- 
	 1.0	;	 %  1251 k_413_cat
	 0.1	;	 %  1252 K_413_ATP
	 0.1	;	 %  1253 K_413_FMN

	 % Reaction: 414 ribC_BG11495_2.7.7.2::REVERSE -- 
	 1.0	;	 %  1254 k_414_cat
	 0.1	;	 %  1255 K_414_PPI
	 0.1	;	 %  1256 K_414_FAD

	 % Reaction: 415 yqjI_BG11738_1.1.1.44::FORWARD -- 
	 1.0	;	 %  1257 k_415_cat
	 0.1	;	 %  1258 K_415_6PDG
	 0.1	;	 %  1259 K_415_NADP

	 % Reaction: 416 yqjI_BG11738_1.1.1.44::REVERSE -- 
	 1.0	;	 %  1260 k_416_cat
	 0.1	;	 %  1261 K_416_RU5P
	 0.1	;	 %  1262 K_416_CO2
	 0.1	;	 %  1263 K_416_NADPH

	 % Reaction: 417 aroC_BG10538_4.2.1.10::FORWARD -- 
	 1.0	;	 %  1264 k_417_cat
	 0.1	;	 %  1265 K_417_DEHYDROQUINATE

	 % Reaction: 418 aroC_BG10538_4.2.1.10::REVERSE -- 
	 1.0	;	 %  1266 k_418_cat
	 0.1	;	 %  1267 K_418_3-DEHYDRO-SHIKIMATE

	 % Reaction: 419 cysE_BG10155_2.3.1.30::FORWARD -- 
	 1.0	;	 %  1268 k_419_cat
	 0.1	;	 %  1269 K_419_Acetyl-CoA
	 0.1	;	 %  1270 K_419_SER

	 % Reaction: 420 cysE_BG10155_2.3.1.30::REVERSE -- 
	 1.0	;	 %  1271 k_420_cat
	 0.1	;	 %  1272 K_420_CoA
	 0.1	;	 %  1273 K_420_ACETYLSERINE

	 % Reaction: 421 _UNKNOWN_::FORWARD -- 
	 1.0	;	 %  1274 k_421_cat
	 0.1	;	 %  1275 K_421_ACETOIN
	 0.1	;	 %  1276 K_421_NADH

	 % Reaction: 422 _UNKNOWN_::REVERSE -- 
	 1.0	;	 %  1277 k_422_cat
	 0.1	;	 %  1278 K_422_2_3-BUTANEDIOL
	 0.1	;	 %  1279 K_422_NAD

	 % Reaction: 423 ywkA_BG11312_1.1.1.38::FORWARD -- 
	 1.0	;	 %  1280 k_423_cat
	 0.1	;	 %  1281 K_423_MAL
	 0.1	;	 %  1282 K_423_NAD

	 % Reaction: 424 ywkA_BG11312_1.1.1.38::REVERSE -- 
	 1.0	;	 %  1283 k_424_cat
	 0.1	;	 %  1284 K_424_PYR
	 0.1	;	 %  1285 K_424_NADH
	 0.1	;	 %  1286 K_424_CO2

	 % Reaction: 425 ywaA_ipa-0r_BG10546_2.6.1.42::FORWARD -- 
	 1.0	;	 %  1287 k_425_cat
	 0.1	;	 %  1288 K_425_2K-4CH3-PENTANOATE
	 0.1	;	 %  1289 K_425_GLU

	 % Reaction: 426 ywaA_ipa-0r_BG10546_2.6.1.42::REVERSE -- 
	 1.0	;	 %  1290 k_426_cat
	 0.1	;	 %  1291 K_426_LEU
	 0.1	;	 %  1292 K_426_OGA

	 % Reaction: 427 _NEED_TO_DO::FORWARD -- 
	 1.0	;	 %  1293 k_427_cat
	 0.1	;	 %  1294 K_427_ASUCC

	 % Reaction: 428 _NEED_TO_DO::REVERSE -- 
	 1.0	;	 %  1295 k_428_cat
	 0.1	;	 %  1296 K_428_FUM
	 0.1	;	 %  1297 K_428_AMP

	 % Reaction: 429 yoxE_BG11049_1.5.1.2::FORWARD -- 
	 1.0	;	 %  1298 k_429_cat
	 0.1	;	 %  1299 K_429_PRO
	 0.1	;	 %  1300 K_429_NADP

	 % Reaction: 430 yoxE_BG11049_1.5.1.2::REVERSE -- 
	 1.0	;	 %  1301 k_430_cat
	 0.1	;	 %  1302 K_430_PYYCX
	 0.1	;	 %  1303 K_430_NADPH

	 % Reaction: 431 hisI_BG12063_3.5.4.19::FORWARD -- 
	 1.0	;	 %  1304 k_431_cat
	 0.1	;	 %  1305 K_431_PHOSPHORIBOSYL-AMP

	 % Reaction: 432 hisI_BG12063_3.5.4.19::REVERSE -- 
	 1.0	;	 %  1306 k_432_cat
	 0.1	;	 %  1307 K_432_PHOSPHORIBOSYL-FORMIMINO-AICAR-P

	 % Reaction: 433 ywaA_ipa-0r_BG10546_2.6.1.42::FORWARD -- 
	 1.0	;	 %  1308 k_433_cat
	 0.1	;	 %  1309 K_433_2-KETO-ISOVALERATE
	 0.1	;	 %  1310 K_433_GLU

	 % Reaction: 434 ywaA_ipa-0r_BG10546_2.6.1.42::REVERSE -- 
	 1.0	;	 %  1311 k_434_cat
	 0.1	;	 %  1312 K_434_VAL
	 0.1	;	 %  1313 K_434_OGA

	 % Reaction: 435 trpC_BG11038_4.1.1.48::FORWARD -- 
	 1.0	;	 %  1314 k_435_cat
	 0.1	;	 %  1315 K_435_CARBOXYPHENYLAMINO-DEOXYRIBULOSE-P

	 % Reaction: 436 trpC_BG11038_4.1.1.48::REVERSE -- 
	 1.0	;	 %  1316 k_436_cat
	 0.1	;	 %  1317 K_436_INDOLE-3-GLYCEROL-P
	 0.1	;	 %  1318 K_436_CO2

	 % Reaction: 437 tmk_BG10092_2.7.4.9::FORWARD -- 
	 1.0	;	 %  1319 k_437_cat
	 0.1	;	 %  1320 K_437_dTMP
	 0.1	;	 %  1321 K_437_ATP

	 % Reaction: 438 tmk_BG10092_2.7.4.9::REVERSE -- 
	 1.0	;	 %  1322 k_438_cat
	 0.1	;	 %  1323 K_438_ADP
	 0.1	;	 %  1324 K_438_dTDP

	 % Reaction: 439 tpi_BG10897_5.3.1.1::FORWARD -- 
	 1.0	;	 %  1325 k_439_cat
	 0.1	;	 %  1326 K_439_GA3P

	 % Reaction: 440 tpi_BG10897_5.3.1.1::REVERSE -- 
	 1.0	;	 %  1327 k_440_cat
	 0.1	;	 %  1328 K_440_DHAP

	 % Reaction: 441 dfrA_tmp_BG10795_1.5.1.3::FORWARD -- 
	 1.0	;	 %  1329 k_441_cat
	 0.1	;	 %  1330 K_441_NADPH
	 0.1	;	 %  1331 K_441_DIHYDROFOLATE

	 % Reaction: 442 dfrA_tmp_BG10795_1.5.1.3::REVERSE -- 
	 1.0	;	 %  1332 k_442_cat
	 0.1	;	 %  1333 K_442_NADP
	 0.1	;	 %  1334 K_442_THF

	 % Reaction: 443 citH_BG11386_1.1.1.37::FORWARD -- 
	 1.0	;	 %  1335 k_443_cat
	 0.1	;	 %  1336 K_443_MAL
	 0.1	;	 %  1337 K_443_NAD

	 % Reaction: 444 citH_BG11386_1.1.1.37::REVERSE -- 
	 1.0	;	 %  1338 k_444_cat
	 0.1	;	 %  1339 K_444_OAA
	 0.1	;	 %  1340 K_444_NADH

	 % Reaction: 445 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1341 k_445_cat
	 0.1	;	 %  1342 K_445_dADP
	 0.1	;	 %  1343 K_445_ATP

	 % Reaction: 446 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1344 k_446_cat
	 0.1	;	 %  1345 K_446_dATP
	 0.1	;	 %  1346 K_446_ADP

	 % Reaction: 447 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1347 k_447_cat
	 0.1	;	 %  1348 K_447_dADP
	 0.1	;	 %  1349 K_447_ATP

	 % Reaction: 448 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1350 k_448_cat
	 0.1	;	 %  1351 K_448_ADP
	 0.1	;	 %  1352 K_448_dATP

	 % Reaction: 449 carA_BG10195_6.3.5.5::FORWARD -- 
	 1.0	;	 %  1353 k_449_cat
	 0.1	;	 %  1354 K_449_ATP
	 0.1	;	 %  1355 K_449_GLN
	 0.1	;	 %  1356 K_449_CO2

	 % Reaction: 450 carA_BG10195_6.3.5.5::REVERSE -- 
	 1.0	;	 %  1357 k_450_cat
	 0.1	;	 %  1358 K_450_ADP
	 0.1	;	 %  1359 K_450_PI
	 0.1	;	 %  1360 K_450_GLU
	 0.1	;	 %  1361 K_450_CAP

	 % Reaction: 451 hom_tdm_BG10460_1.1.1.3::FORWARD -- 
	 1.0	;	 %  1362 k_451_cat
	 0.1	;	 %  1363 K_451_NADPH
	 0.1	;	 %  1364 K_451_ASPSALD

	 % Reaction: 452 hom_tdm_BG10460_1.1.1.3::REVERSE -- 
	 1.0	;	 %  1365 k_452_cat
	 0.1	;	 %  1366 K_452_NADP
	 0.1	;	 %  1367 K_452_HSER

	 % Reaction: 453 FADH::FORWARD -- 
	 1.0	;	 %  1368 k_453_cat
	 0.1	;	 %  1369 K_453_FADH
	 0.1	;	 %  1370 K_453_Q1

	 % Reaction: 454 FADH::REVERSE -- 
	 1.0	;	 %  1371 k_454_cat
	 0.1	;	 %  1372 K_454_FAD
	 0.1	;	 %  1373 K_454_Q2

	 % Reaction: 455 yqjO_BG11744_1.5.1.2::FORWARD -- 
	 1.0	;	 %  1374 k_455_cat
	 0.1	;	 %  1375 K_455_PRO
	 0.1	;	 %  1376 K_455_NADP

	 % Reaction: 456 yqjO_BG11744_1.5.1.2::REVERSE -- 
	 1.0	;	 %  1377 k_456_cat
	 0.1	;	 %  1378 K_456_NADPH
	 0.1	;	 %  1379 K_456_PYYCX

	 % Reaction: 457 gapA_BG10827_1.2.1.12::FORWARD -- 
	 1.0	;	 %  1380 k_457_cat
	 0.1	;	 %  1381 K_457_GA3P
	 0.1	;	 %  1382 K_457_PI
	 0.1	;	 %  1383 K_457_NAD

	 % Reaction: 458 gapA_BG10827_1.2.1.12::REVERSE -- 
	 1.0	;	 %  1384 k_458_cat
	 0.1	;	 %  1385 K_458_G13P
	 0.1	;	 %  1386 K_458_NADH

	 % Reaction: 459 thyB_BG10794_2.1.1.45::FORWARD -- 
	 1.0	;	 %  1387 k_459_cat
	 0.1	;	 %  1388 K_459_METHYLENE-THF
	 0.1	;	 %  1389 K_459_dUMP

	 % Reaction: 460 thyB_BG10794_2.1.1.45::REVERSE -- 
	 1.0	;	 %  1390 k_460_cat
	 0.1	;	 %  1391 K_460_dTMP
	 0.1	;	 %  1392 K_460_DIHYDROFOLATE

	 % Reaction: 461 DIAMPIM_SYNTHESIS::FORWARD -- 
	 1.0	;	 %  1393 k_461_cat
	 0.1	;	 %  1394 K_461_PYR
	 0.1	;	 %  1395 K_461_SUCCCoA
	 0.1	;	 %  1396 K_461_NADPH
	 0.1	;	 %  1397 K_461_ASPSALD
	 0.1	;	 %  1398 K_461_GLU

	 % Reaction: 462 recS_recQ_BG11407_3.6.1.-::FORWARD -- 
	 1.0	;	 %  1399 k_462_cat
	 0.1	;	 %  1400 K_462_DIHYDRONEOPTERIN-P

	 % Reaction: 463 recS_recQ_BG11407_3.6.1.-::REVERSE -- 
	 1.0	;	 %  1401 k_463_cat
	 0.1	;	 %  1402 K_463_DIHYDRO-NEO-PTERIN
	 0.1	;	 %  1403 K_463_PI

	 % Reaction: 464 pgk_BG11062_2.7.2.3::FORWARD -- 
	 1.0	;	 %  1404 k_464_cat
	 0.1	;	 %  1405 K_464_ADP
	 0.1	;	 %  1406 K_464_G13P

	 % Reaction: 465 pgk_BG11062_2.7.2.3::REVERSE -- 
	 1.0	;	 %  1407 k_465_cat
	 0.1	;	 %  1408 K_465_ATP
	 0.1	;	 %  1409 K_465_3PG

	 % Reaction: 466 ycgT_BG12018_1.8.1.9::FORWARD -- 
	 1.0	;	 %  1410 k_466_cat
	 0.1	;	 %  1411 K_466_OTRD

	 % Reaction: 467 ycgT_BG12018_1.8.1.9::REVERSE -- 
	 1.0	;	 %  1412 k_467_cat
	 0.1	;	 %  1413 K_467_RTRD

	 % Reaction: 468 purE_BG10700_4.1.1.21::FORWARD -- 
	 1.0	;	 %  1414 k_468_cat
	 0.1	;	 %  1415 K_468_NCAIR

	 % Reaction: 469 purE_BG10700_4.1.1.21::REVERSE -- 
	 1.0	;	 %  1416 k_469_cat
	 0.1	;	 %  1417 K_469_CAIR

	 % Reaction: 470 mmgD_BG11322_2.3.3.1::FORWARD -- 
	 1.0	;	 %  1418 k_470_cat
	 0.1	;	 %  1419 K_470_Acetyl-CoA
	 0.1	;	 %  1420 K_470_OAA

	 % Reaction: 471 mmgD_BG11322_2.3.3.1::REVERSE -- 
	 1.0	;	 %  1421 k_471_cat
	 0.1	;	 %  1422 K_471_CIT
	 0.1	;	 %  1423 K_471_CoA

	 % Reaction: 472 pntA::FORWARD -- 
	 1.0	;	 %  1424 k_472_cat
	 0.1	;	 %  1425 K_472_NADPH
	 0.1	;	 %  1426 K_472_NAD

	 % Reaction: 473 pntA::REVERSE -- 
	 1.0	;	 %  1427 k_473_cat
	 0.1	;	 %  1428 K_473_NADP
	 0.1	;	 %  1429 K_473_NADH

	 % Reaction: 474 leuB_leuC_BG10675_1.1.1.85::FORWARD -- 
	 1.0	;	 %  1430 k_474_cat
	 0.1	;	 %  1431 K_474_2-D-THREO-HYDROXY-3-CARBOXY-ISOCAPROATE
	 0.1	;	 %  1432 K_474_NAD

	 % Reaction: 475 leuB_leuC_BG10675_1.1.1.85::REVERSE -- 
	 1.0	;	 %  1433 k_475_cat
	 0.1	;	 %  1434 K_475_2K-4CH3-PENTANOATE
	 0.1	;	 %  1435 K_475_NADH
	 0.1	;	 %  1436 K_475_CO2

	 % Reaction: 476 ribB_BG10519_2.5.1.9(B)::FORWARD -- 
	 1.0	;	 %  1437 k_476_cat
	 0.1	;	 %  1438 K_476_DRL

	 % Reaction: 477 ribB_BG10519_2.5.1.9(B)::REVERSE -- 
	 1.0	;	 %  1439 k_477_cat
	 0.1	;	 %  1440 K_477_RIBOFLAVIN
	 0.1	;	 %  1441 K_477_RAU

	 % Reaction: 478 proB_BG10963_2.7.2.11::FORWARD -- 
	 1.0	;	 %  1442 k_478_cat
	 0.1	;	 %  1443 K_478_GLU
	 0.1	;	 %  1444 K_478_ATP

	 % Reaction: 479 proB_BG10963_2.7.2.11::REVERSE -- 
	 1.0	;	 %  1445 k_479_cat
	 0.1	;	 %  1446 K_479_L-GLUTAMATE-5P
	 0.1	;	 %  1447 K_479_ADP

	 % Reaction: 480 acsA_BG10370_6.2.1.1::FORWARD -- 
	 1.0	;	 %  1448 k_480_cat
	 0.1	;	 %  1449 K_480_Acetyl-CoA
	 0.1	;	 %  1450 K_480_PPI
	 0.1	;	 %  1451 K_480_AMP

	 % Reaction: 481 acsA_BG10370_6.2.1.1::REVERSE -- 
	 1.0	;	 %  1452 k_481_cat
	 0.1	;	 %  1453 K_481_ATP
	 0.1	;	 %  1454 K_481_AC
	 0.1	;	 %  1455 K_481_CoA

	 % Reaction: 482 glyA_glyC_ipc-34d_BG10944_2.1.2.1::FORWARD -- 
	 1.0	;	 %  1456 k_482_cat
	 0.1	;	 %  1457 K_482_METHYLENE-THF
	 0.1	;	 %  1458 K_482_GLY

	 % Reaction: 483 glyA_glyC_ipc-34d_BG10944_2.1.2.1::REVERSE -- 
	 1.0	;	 %  1459 k_483_cat
	 0.1	;	 %  1460 K_483_SER
	 0.1	;	 %  1461 K_483_THF

	 % Reaction: 484 ureC_BG11983_3.5.1.5::FORWARD -- 
	 1.0	;	 %  1462 k_484_cat
	 0.1	;	 %  1463 K_484_UREA

	 % Reaction: 485 ureC_BG11983_3.5.1.5::REVERSE -- 
	 1.0	;	 %  1464 k_485_cat
	 0.1	;	 %  1465 K_485_NH3
	 0.1	;	 %  1466 K_485_CO2

	 % Reaction: 486 _need_to_do::FORWARD -- 
	 1.0	;	 %  1467 k_486_cat
	 0.1	;	 %  1468 K_486_CYTD
	 0.1	;	 %  1469 K_486_GTP

	 % Reaction: 487 _need_to_do::REVERSE -- 
	 1.0	;	 %  1470 k_487_cat
	 0.1	;	 %  1471 K_487_GDP
	 0.1	;	 %  1472 K_487_CMP

	 % Reaction: 488 pta_BG10634_2.3.1.8::FORWARD -- 
	 1.0	;	 %  1473 k_488_cat
	 0.1	;	 %  1474 K_488_Acetyl-CoA
	 0.1	;	 %  1475 K_488_PI

	 % Reaction: 489 pta_BG10634_2.3.1.8::REVERSE -- 
	 1.0	;	 %  1476 k_489_cat
	 0.1	;	 %  1477 K_489_CoA
	 0.1	;	 %  1478 K_489_ACP

	 % Reaction: 490 aroH_BG10286_5.4.99.5::FORWARD -- 
	 1.0	;	 %  1479 k_490_cat
	 0.1	;	 %  1480 K_490_CHOR

	 % Reaction: 491 aroH_BG10286_5.4.99.5::REVERSE -- 
	 1.0	;	 %  1481 k_491_cat
	 0.1	;	 %  1482 K_491_PREPHENATE

	 % Reaction: 492 pps_BG12657_2.7.9.2::FORWARD -- 
	 1.0	;	 %  1483 k_492_cat
	 0.1	;	 %  1484 K_492_ATP
	 0.1	;	 %  1485 K_492_PYR

	 % Reaction: 493 pps_BG12657_2.7.9.2::REVERSE -- 
	 1.0	;	 %  1486 k_493_cat
	 0.1	;	 %  1487 K_493_AMP
	 0.1	;	 %  1488 K_493_PEP
	 0.1	;	 %  1489 K_493_PI

	 % Reaction: 494 argF_BG10197_2.1.3.3::FORWARD -- 
	 1.0	;	 %  1490 k_494_cat
	 0.1	;	 %  1491 K_494_CITR
	 0.1	;	 %  1492 K_494_PI

	 % Reaction: 495 argF_BG10197_2.1.3.3::REVERSE -- 
	 1.0	;	 %  1493 k_495_cat
	 0.1	;	 %  1494 K_495_ORN
	 0.1	;	 %  1495 K_495_CAP

	 % Reaction: 496 ythA_BG13857_1.10.3.-::FORWARD -- 
	 1.0	;	 %  1496 k_496_cat
	 0.1	;	 %  1497 K_496_Q2
	 0.1	;	 %  1498 K_496_O2

	 % Reaction: 497 ythA_BG13857_1.10.3.-::REVERSE -- 
	 1.0	;	 %  1499 k_497_cat
	 0.1	;	 %  1500 K_497_Q1
	 0.1	;	 %  1501 K_497_HEXT

	 % Reaction: 498 ytcI_BG13834_6.2.1.1::FORWARD -- 
	 1.0	;	 %  1502 k_498_cat
	 0.1	;	 %  1503 K_498_Acetyl-CoA
	 0.1	;	 %  1504 K_498_PPI
	 0.1	;	 %  1505 K_498_AMP

	 % Reaction: 499 ytcI_BG13834_6.2.1.1::REVERSE -- 
	 1.0	;	 %  1506 k_499_cat
	 0.1	;	 %  1507 K_499_ATP
	 0.1	;	 %  1508 K_499_AC
	 0.1	;	 %  1509 K_499_CoA

	 % Reaction: 500 purN_BG10709_2.1.2.2::FORWARD -- 
	 1.0	;	 %  1510 k_500_cat
	 0.1	;	 %  1511 K_500_10-FORMYL-THF

	 % Reaction: 501 purN_BG10709_2.1.2.2::REVERSE -- 
	 1.0	;	 %  1512 k_501_cat
	 0.1	;	 %  1513 K_501_THF
	 0.1	;	 %  1514 K_501_FOR

	 % Reaction: 502 folK_BG10142_2.7.6.3::FORWARD -- 
	 1.0	;	 %  1515 k_502_cat
	 0.1	;	 %  1516 K_502_AMINO-OH-HYDROXYMETHYL-DIHYDROPTERIDINE
	 0.1	;	 %  1517 K_502_ATP

	 % Reaction: 503 folK_BG10142_2.7.6.3::REVERSE -- 
	 1.0	;	 %  1518 k_503_cat
	 0.1	;	 %  1519 K_503_DIHYDROPTERIN-CH2OH-PP
	 0.1	;	 %  1520 K_503_AMP

	 % Reaction: 504 purH_BG10710_3.5.4.10::FORWARD -- 
	 1.0	;	 %  1521 k_504_cat
	 0.1	;	 %  1522 K_504_PRFICA

	 % Reaction: 505 purH_BG10710_3.5.4.10::REVERSE -- 
	 1.0	;	 %  1523 k_505_cat
	 0.1	;	 %  1524 K_505_IMP

	 % Reaction: 506 hisB_BG12598_4.2.1.19::FORWARD -- 
	 1.0	;	 %  1525 k_506_cat
	 0.1	;	 %  1526 K_506_D-ERYTHRO-IMIDAZOLE-GLYCEROL-P

	 % Reaction: 507 hisB_BG12598_4.2.1.19::REVERSE -- 
	 1.0	;	 %  1527 k_507_cat
	 0.1	;	 %  1528 K_507_IMIDAZOLE-ACETOL-P

	 % Reaction: 508 adhE::FORWARD -- 
	 1.0	;	 %  1529 k_508_cat
	 0.1	;	 %  1530 K_508_Acetyl-CoA
	 0.1	;	 %  1531 K_508_NADH

	 % Reaction: 509 adhE::REVERSE -- 
	 1.0	;	 %  1532 k_509_cat
	 0.1	;	 %  1533 K_509_ETH
	 0.1	;	 %  1534 K_509_NAD
	 0.1	;	 %  1535 K_509_CoA

	 % Reaction: 510 pabB_pab_BG10137_6.3.5.8::FORWARD -- 
	 1.0	;	 %  1536 k_510_cat
	 0.1	;	 %  1537 K_510_GLN
	 0.1	;	 %  1538 K_510_CHOR

	 % Reaction: 511 pabB_pab_BG10137_6.3.5.8::REVERSE -- 
	 1.0	;	 %  1539 k_511_cat
	 0.1	;	 %  1540 K_511_4-AMINO-4-DEOXYCHORISMATE
	 0.1	;	 %  1541 K_511_GLU

	 % Reaction: 512 hisA_BG12597_5.3.1.16::FORWARD -- 
	 1.0	;	 %  1542 k_512_cat
	 0.1	;	 %  1543 K_512_PHOSPHORIBOSYL-FORMIMINO-AICAR-P

	 % Reaction: 513 hisA_BG12597_5.3.1.16::REVERSE -- 
	 1.0	;	 %  1544 k_513_cat
	 0.1	;	 %  1545 K_513_PHOSPHORIBULOSYL-FORMIMINO-AICAR-P

	 % Reaction: 514 hisC_BG10292_2.6.1.5::FORWARD -- 
	 1.0	;	 %  1546 k_514_cat
	 0.1	;	 %  1547 K_514_P-HYDROXY-PHENYLPYRUVATE
	 0.1	;	 %  1548 K_514_GLU

	 % Reaction: 515 hisC_BG10292_2.6.1.5::REVERSE -- 
	 1.0	;	 %  1549 k_515_cat
	 0.1	;	 %  1550 K_515_OGA
	 0.1	;	 %  1551 K_515_TYR

	 % Reaction: 516 ilvD_BG11532_4.2.1.9::FORWARD -- 
	 1.0	;	 %  1552 k_516_cat
	 0.1	;	 %  1553 K_516_1-KETO-2-METHYLVALERATE

	 % Reaction: 517 ilvD_BG11532_4.2.1.9::REVERSE -- 
	 1.0	;	 %  1554 k_517_cat
	 0.1	;	 %  1555 K_517_2-KETO-3-METHYL-VALERATE

	 % Reaction: 518 ribG_BG10518_3.5.4.26::FORWARD -- 
	 1.0	;	 %  1556 k_518_cat
	 0.1	;	 %  1557 K_518_C01304

	 % Reaction: 519 ribG_BG10518_3.5.4.26::REVERSE -- 
	 1.0	;	 %  1558 k_519_cat
	 0.1	;	 %  1559 K_519_C01268
	 0.1	;	 %  1560 K_519_NH3

	 % Reaction: 520 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1561 k_520_cat
	 0.1	;	 %  1562 K_520_dCDP
	 0.1	;	 %  1563 K_520_ATP

	 % Reaction: 521 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1564 k_521_cat
	 0.1	;	 %  1565 K_521_dCTP
	 0.1	;	 %  1566 K_521_ADP

	 % Reaction: 522 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1567 k_522_cat
	 0.1	;	 %  1568 K_522_dCDP
	 0.1	;	 %  1569 K_522_ATP

	 % Reaction: 523 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1570 k_523_cat
	 0.1	;	 %  1571 K_523_ADP
	 0.1	;	 %  1572 K_523_dCTP

	 % Reaction: 524 folD_BG11711_1.5.1.5::FORWARD -- 
	 1.0	;	 %  1573 k_524_cat
	 0.1	;	 %  1574 K_524_5_10-METHENYL-THF
	 0.1	;	 %  1575 K_524_NADPH

	 % Reaction: 525 folD_BG11711_1.5.1.5::REVERSE -- 
	 1.0	;	 %  1576 k_525_cat
	 0.1	;	 %  1577 K_525_METHYLENE-THF
	 0.1	;	 %  1578 K_525_NADP

	 % Reaction: 526 leuA_BG11948_2.3.3.13::FORWARD -- 
	 1.0	;	 %  1579 k_526_cat
	 0.1	;	 %  1580 K_526_2-KETO-ISOVALERATE
	 0.1	;	 %  1581 K_526_Acetyl-CoA

	 % Reaction: 527 leuA_BG11948_2.3.3.13::REVERSE -- 
	 1.0	;	 %  1582 k_527_cat
	 0.1	;	 %  1583 K_527_3-CARBOXY-3-HYDROXY-ISOCAPROATE
	 0.1	;	 %  1584 K_527_CoA

	 % Reaction: 528 hisI_BG12063_3.6.1.31::FORWARD -- 
	 1.0	;	 %  1585 k_528_cat
	 0.1	;	 %  1586 K_528_PHOSPHORIBOSYL-ATP

	 % Reaction: 529 hisI_BG12063_3.6.1.31::REVERSE -- 
	 1.0	;	 %  1587 k_529_cat
	 0.1	;	 %  1588 K_529_PHOSPHORIBOSYL-AMP
	 0.1	;	 %  1589 K_529_PPI

	 % Reaction: 530 _NEED_TO_DO_6.3.4.1::FORWARD -- 
	 1.0	;	 %  1590 k_530_cat
	 0.1	;	 %  1591 K_530_ATP
	 0.1	;	 %  1592 K_530_XMP
	 0.1	;	 %  1593 K_530_NH3

	 % Reaction: 531 _NEED_TO_DO_6.3.4.1::REVERSE -- 
	 1.0	;	 %  1594 k_531_cat
	 0.1	;	 %  1595 K_531_GMP
	 0.1	;	 %  1596 K_531_AMP
	 0.1	;	 %  1597 K_531_PPI

	 % Reaction: 532 rpe_BG13393_5.1.3.1::FORWARD -- 
	 1.0	;	 %  1598 k_532_cat
	 0.1	;	 %  1599 K_532_RU5P

	 % Reaction: 533 rpe_BG13393_5.1.3.1::REVERSE -- 
	 1.0	;	 %  1600 k_533_cat
	 0.1	;	 %  1601 K_533_X5P

	 % Reaction: 534 malS_BG12614_1.1.1.38::FORWARD -- 
	 1.0	;	 %  1602 k_534_cat
	 0.1	;	 %  1603 K_534_MAL
	 0.1	;	 %  1604 K_534_NAD

	 % Reaction: 535 malS_BG12614_1.1.1.38::REVERSE -- 
	 1.0	;	 %  1605 k_535_cat
	 0.1	;	 %  1606 K_535_PYR
	 0.1	;	 %  1607 K_535_NADH
	 0.1	;	 %  1608 K_535_CO2

	 % Reaction: 536 yccC_BG12755_3.5.1.1::FORWARD -- 
	 1.0	;	 %  1609 k_536_cat
	 0.1	;	 %  1610 K_536_ASN

	 % Reaction: 537 yccC_BG12755_3.5.1.1::REVERSE -- 
	 1.0	;	 %  1611 k_537_cat
	 0.1	;	 %  1612 K_537_ASP
	 0.1	;	 %  1613 K_537_NH3

	 % Reaction: 538 argG_BG12570_6.3.4.5::FORWARD -- 
	 1.0	;	 %  1614 k_538_cat
	 0.1	;	 %  1615 K_538_NOSUCC
	 0.1	;	 %  1616 K_538_PPI
	 0.1	;	 %  1617 K_538_AMP

	 % Reaction: 539 argG_BG12570_6.3.4.5::REVERSE -- 
	 1.0	;	 %  1618 k_539_cat
	 0.1	;	 %  1619 K_539_ATP
	 0.1	;	 %  1620 K_539_ASP
	 0.1	;	 %  1621 K_539_CITR

	 % Reaction: 540 pykA_BG12661_2.7.1.40::FORWARD -- 
	 1.0	;	 %  1622 k_540_cat
	 0.1	;	 %  1623 K_540_ADP
	 0.1	;	 %  1624 K_540_PEP

	 % Reaction: 541 pykA_BG12661_2.7.1.40::REVERSE -- 
	 1.0	;	 %  1625 k_541_cat
	 0.1	;	 %  1626 K_541_ATP
	 0.1	;	 %  1627 K_541_PYR

	 % Reaction: 542 ansB_BG10301_4.3.1.1::FORWARD -- 
	 1.0	;	 %  1628 k_542_cat
	 0.1	;	 %  1629 K_542_ASP

	 % Reaction: 543 ansB_BG10301_4.3.1.1::REVERSE -- 
	 1.0	;	 %  1630 k_543_cat
	 0.1	;	 %  1631 K_543_FUM
	 0.1	;	 %  1632 K_543_NH3

	 % Reaction: 544 aceB::FORWARD -- 
	 1.0	;	 %  1633 k_544_cat
	 0.1	;	 %  1634 K_544_Acetyl-CoA
	 0.1	;	 %  1635 K_544_GLX

	 % Reaction: 545 aceB::REVERSE -- 
	 1.0	;	 %  1636 k_545_cat
	 0.1	;	 %  1637 K_545_CoA
	 0.1	;	 %  1638 K_545_MAL

	 % Reaction: 546 pfk_BG12644_2.7.1.11::FORWARD -- 
	 1.0	;	 %  1639 k_546_cat
	 0.1	;	 %  1640 K_546_ATP
	 0.1	;	 %  1641 K_546_F6P

	 % Reaction: 547 pfk_BG12644_2.7.1.11::REVERSE -- 
	 1.0	;	 %  1642 k_547_cat
	 0.1	;	 %  1643 K_547_ADP
	 0.1	;	 %  1644 K_547_F16BP

	 % Reaction: 548 aroE_BG10294_2.5.1.19::FORWARD -- 
	 1.0	;	 %  1645 k_548_cat
	 0.1	;	 %  1646 K_548_SHIKIMATE-5P
	 0.1	;	 %  1647 K_548_PEP

	 % Reaction: 549 aroE_BG10294_2.5.1.19::REVERSE -- 
	 1.0	;	 %  1648 k_549_cat
	 0.1	;	 %  1649 K_549_3-ENOLPYRUVYL-SHIKIMATE-5P
	 0.1	;	 %  1650 K_549_PI

	 % Reaction: 550 purN_BG10709_2.1.2.2::FORWARD -- 
	 1.0	;	 %  1651 k_550_cat
	 0.1	;	 %  1652 K_550_GAR
	 0.1	;	 %  1653 K_550_10-FORMYL-THF

	 % Reaction: 551 purN_BG10709_2.1.2.2::REVERSE -- 
	 1.0	;	 %  1654 k_551_cat
	 0.1	;	 %  1655 K_551_THF
	 0.1	;	 %  1656 K_551_FGAR

	 % Reaction: 552 ytkP_BG13872_2.5.1.47::FORWARD -- 
	 1.0	;	 %  1657 k_552_cat
	 0.1	;	 %  1658 K_552_ACETYLSERINE
	 0.1	;	 %  1659 K_552_HS

	 % Reaction: 553 ytkP_BG13872_2.5.1.47::REVERSE -- 
	 1.0	;	 %  1660 k_553_cat
	 0.1	;	 %  1661 K_553_CYS
	 0.1	;	 %  1662 K_553_AC

	 % Reaction: 554 hisC_BG10292_2.6.1.9::FORWARD -- 
	 1.0	;	 %  1663 k_554_cat
	 0.1	;	 %  1664 K_554_IMIDAZOLE-ACETOL-P
	 0.1	;	 %  1665 K_554_GLU

	 % Reaction: 555 hisC_BG10292_2.6.1.9::REVERSE -- 
	 1.0	;	 %  1666 k_555_cat
	 0.1	;	 %  1667 K_555_L-HISTIDINOL-P
	 0.1	;	 %  1668 K_555_OGA

	 % Reaction: 556 padC_BG10139_4.1.3.38::FORWARD -- 
	 1.0	;	 %  1669 k_556_cat
	 0.1	;	 %  1670 K_556_4-AMINO-4-DEOXYCHORISMATE

	 % Reaction: 557 padC_BG10139_4.1.3.38::REVERSE -- 
	 1.0	;	 %  1671 k_557_cat
	 0.1	;	 %  1672 K_557_PYR
	 0.1	;	 %  1673 K_557_4-AMINOBENZOATE

	 % Reaction: 558 alsD_BG10472_4.1.1.5::FORWARD -- 
	 1.0	;	 %  1674 k_558_cat
	 0.1	;	 %  1675 K_558_2-ACETOLACTATE

	 % Reaction: 559 alsD_BG10472_4.1.1.5::REVERSE -- 
	 1.0	;	 %  1676 k_559_cat
	 0.1	;	 %  1677 K_559_ACETOIN
	 0.1	;	 %  1678 K_559_CO2

	 % Reaction: 560 rocA_BG10622_1.5.1.12::FORWARD -- 
	 1.0	;	 %  1679 k_560_cat
	 0.1	;	 %  1680 K_560_GLU
	 0.1	;	 %  1681 K_560_NADPH

	 % Reaction: 561 rocA_BG10622_1.5.1.12::REVERSE -- 
	 1.0	;	 %  1682 k_561_cat
	 0.1	;	 %  1683 K_561_PYYCX
	 0.1	;	 %  1684 K_561_NADP

	 % Reaction: 562 yncD_BG12267_5.1.1.1::FORWARD -- 
	 1.0	;	 %  1685 k_562_cat
	 0.1	;	 %  1686 K_562_ALA

	 % Reaction: 563 yncD_BG12267_5.1.1.1::REVERSE -- 
	 1.0	;	 %  1687 k_563_cat
	 0.1	;	 %  1688 K_563_D-ALANINE

	 % Reaction: 564 folC_BG10322_6.3.2.17::FORWARD -- 
	 1.0	;	 %  1689 k_564_cat
	 0.1	;	 %  1690 K_564_7_8-DIHYDROPTEROATE
	 0.1	;	 %  1691 K_564_ATP
	 0.1	;	 %  1692 K_564_GLU

	 % Reaction: 565 folC_BG10322_6.3.2.17::REVERSE -- 
	 1.0	;	 %  1693 k_565_cat
	 0.1	;	 %  1694 K_565_DIHYDROFOLATE
	 0.1	;	 %  1695 K_565_PI
	 0.1	;	 %  1696 K_565_ADP

	 % Reaction: 566 nrdE_BG11404_1.17.4.1::FORWARD -- 
	 1.0	;	 %  1697 k_566_cat
	 0.1	;	 %  1698 K_566_ADP
	 0.1	;	 %  1699 K_566_RTRD

	 % Reaction: 567 nrdE_BG11404_1.17.4.1::REVERSE -- 
	 1.0	;	 %  1700 k_567_cat
	 0.1	;	 %  1701 K_567_OTRD
	 0.1	;	 %  1702 K_567_dADP

	 % Reaction: 568 aroJ_BG10292_2.6.1.5::FORWARD -- 
	 1.0	;	 %  1703 k_568_cat
	 0.1	;	 %  1704 K_568_P-HYDROXY-PHENYLPYRUVATE
	 0.1	;	 %  1705 K_568_GLU

	 % Reaction: 569 aroJ_BG10292_2.6.1.5::REVERSE -- 
	 1.0	;	 %  1706 k_569_cat
	 0.1	;	 %  1707 K_569_OGA
	 0.1	;	 %  1708 K_569_TYR

	 % Reaction: 570 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1709 k_570_cat
	 0.1	;	 %  1710 K_570_dTDP
	 0.1	;	 %  1711 K_570_ATP

	 % Reaction: 571 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1712 k_571_cat
	 0.1	;	 %  1713 K_571_ADP
	 0.1	;	 %  1714 K_571_dTTP

	 % Reaction: 572 qoxB_BG10584_1.9.3.-::FORWARD -- 
	 1.0	;	 %  1715 k_572_cat
	 0.1	;	 %  1716 K_572_Q2
	 0.1	;	 %  1717 K_572_O2

	 % Reaction: 573 qoxB_BG10584_1.9.3.-::REVERSE -- 
	 1.0	;	 %  1718 k_573_cat
	 0.1	;	 %  1719 K_573_Q1
	 0.1	;	 %  1720 K_573_HEXT

	 % Reaction: 574 dat_BG13045_2.6.1.21::FORWARD -- 
	 1.0	;	 %  1721 k_574_cat
	 0.1	;	 %  1722 K_574_PYR
	 0.1	;	 %  1723 K_574_GLU

	 % Reaction: 575 dat_BG13045_2.6.1.21::REVERSE -- 
	 1.0	;	 %  1724 k_575_cat
	 0.1	;	 %  1725 K_575_OGA
	 0.1	;	 %  1726 K_575_D-ALANINE

	 % Reaction: 576 _UNKNOWN_::FORWARD -- 
	 1.0	;	 %  1727 k_576_cat
	 0.1	;	 %  1728 K_576_PEP
	 0.1	;	 %  1729 K_576_E4P

	 % Reaction: 577 _UNKNOWN_::REVERSE -- 
	 1.0	;	 %  1730 k_577_cat
	 0.1	;	 %  1731 K_577_3-DEOXY-D_ARBINO-HEPT-2-ULOSONATE
	 0.1	;	 %  1732 K_577_PI

	 % Reaction: 578 _UNKNOWN::FORWARD -- 
	 1.0	;	 %  1733 k_578_cat
	 0.1	;	 %  1734 K_578_GDP
	 0.1	;	 %  1735 K_578_ATP

	 % Reaction: 579 _UNKNOWN::REVERSE -- 
	 1.0	;	 %  1736 k_579_cat
	 0.1	;	 %  1737 K_579_ppGDP
	 0.1	;	 %  1738 K_579_AMP

	 % Reaction: 580 ilvC_BG10672_1.1.1.86::FORWARD -- 
	 1.0	;	 %  1739 k_580_cat
	 0.1	;	 %  1740 K_580_2-ACETO-LACTATE
	 0.1	;	 %  1741 K_580_NADPH

	 % Reaction: 581 ilvC_BG10672_1.1.1.86::REVERSE -- 
	 1.0	;	 %  1742 k_581_cat
	 0.1	;	 %  1743 K_581_DIOH-ISOVALERATE
	 0.1	;	 %  1744 K_581_NADP

	 % Reaction: 582 hisD_BG12599_1.1.1.23::FORWARD -- 
	 1.0	;	 %  1745 k_582_cat
	 0.1	;	 %  1746 K_582_HISTIDINOL
	 0.1	;	 %  1747 K_582_NAD

	 % Reaction: 583 hisD_BG12599_1.1.1.23::REVERSE -- 
	 1.0	;	 %  1748 k_583_cat
	 0.1	;	 %  1749 K_583_HISTIDINAL
	 0.1	;	 %  1750 K_583_NADH

	 % Reaction: 584 _need_to_do::FORWARD -- 
	 1.0	;	 %  1751 k_584_cat
	 0.1	;	 %  1752 K_584_CMP

	 % Reaction: 585 _need_to_do::REVERSE -- 
	 1.0	;	 %  1753 k_585_cat
	 0.1	;	 %  1754 K_585_CYTD
	 0.1	;	 %  1755 K_585_PI

	 % Reaction: 586 metB_BG11534_2.3.1.46::FORWARD -- 
	 1.0	;	 %  1756 k_586_cat
	 0.1	;	 %  1757 K_586_HSER
	 0.1	;	 %  1758 K_586_SUCCCoA

	 % Reaction: 587 metB_BG11534_2.3.1.46::REVERSE -- 
	 1.0	;	 %  1759 k_587_cat
	 0.1	;	 %  1760 K_587_CoA
	 0.1	;	 %  1761 K_587_O-SUCCINYL-L-HOMOSERINE

	 % Reaction: 588 zwf_BG11739_1.1.1.49::FORWARD -- 
	 1.0	;	 %  1762 k_588_cat
	 0.1	;	 %  1763 K_588_G6P
	 0.1	;	 %  1764 K_588_NADP

	 % Reaction: 589 zwf_BG11739_1.1.1.49::REVERSE -- 
	 1.0	;	 %  1765 k_589_cat
	 0.1	;	 %  1766 K_589_G15L6P
	 0.1	;	 %  1767 K_589_NADPH

	 % Reaction: 590 yjbN_BG13143_2.7.1.23::FORWARD -- 
	 1.0	;	 %  1768 k_590_cat
	 0.1	;	 %  1769 K_590_ATP
	 0.1	;	 %  1770 K_590_NAD

	 % Reaction: 591 yjbN_BG13143_2.7.1.23::REVERSE -- 
	 1.0	;	 %  1771 k_591_cat
	 0.1	;	 %  1772 K_591_ADP
	 0.1	;	 %  1773 K_591_NADP

	 % Reaction: 592 yerD_BG12832_1.4.1.13::FORWARD -- 
	 1.0	;	 %  1774 k_592_cat
	 0.1	;	 %  1775 K_592_GLN
	 0.1	;	 %  1776 K_592_OGA
	 0.1	;	 %  1777 K_592_NADPH

	 % Reaction: 593 yerD_BG12832_1.4.1.13::REVERSE -- 
	 1.0	;	 %  1778 k_593_cat
	 0.1	;	 %  1779 K_593_GLU
	 0.1	;	 %  1780 K_593_NADP

	 % Reaction: 594 _need_to_do::FORWARD -- 
	 1.0	;	 %  1781 k_594_cat
	 0.1	;	 %  1782 K_594_URI
	 0.1	;	 %  1783 K_594_GTP

	 % Reaction: 595 _need_to_do::REVERSE -- 
	 1.0	;	 %  1784 k_595_cat
	 0.1	;	 %  1785 K_595_UMP
	 0.1	;	 %  1786 K_595_GDP

	 % Reaction: 596 ppc::FORWARD -- 
	 1.0	;	 %  1787 k_596_cat
	 0.1	;	 %  1788 K_596_PEP
	 0.1	;	 %  1789 K_596_CO2

	 % Reaction: 597 ppc::REVERSE -- 
	 1.0	;	 %  1790 k_597_cat
	 0.1	;	 %  1791 K_597_OAA
	 0.1	;	 %  1792 K_597_PI

	 % Reaction: 598 eno_BG10899_4.2.1.11::FORWARD -- 
	 1.0	;	 %  1793 k_598_cat
	 0.1	;	 %  1794 K_598_2PG

	 % Reaction: 599 eno_BG10899_4.2.1.11::REVERSE -- 
	 1.0	;	 %  1795 k_599_cat
	 0.1	;	 %  1796 K_599_PEP

	 % Reaction: 600 _need_to_do::FORWARD -- 
	 1.0	;	 %  1797 k_600_cat
	 0.1	;	 %  1798 K_600_CMP
	 0.1	;	 %  1799 K_600_ATP

	 % Reaction: 601 _need_to_do::REVERSE -- 
	 1.0	;	 %  1800 k_601_cat
	 0.1	;	 %  1801 K_601_ADP
	 0.1	;	 %  1802 K_601_CDP

	 % Reaction: 602 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1803 k_602_cat
	 0.1	;	 %  1804 K_602_CDP
	 0.1	;	 %  1805 K_602_ATP

	 % Reaction: 603 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1806 k_603_cat
	 0.1	;	 %  1807 K_603_CTP
	 0.1	;	 %  1808 K_603_ADP

	 % Reaction: 604 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1809 k_604_cat
	 0.1	;	 %  1810 K_604_dGDP
	 0.1	;	 %  1811 K_604_ATP

	 % Reaction: 605 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1812 k_605_cat
	 0.1	;	 %  1813 K_605_ADP
	 0.1	;	 %  1814 K_605_dGTP

	 % Reaction: 606 ndk_BG10282_2.7.4.6::FORWARD -- 
	 1.0	;	 %  1815 k_606_cat
	 0.1	;	 %  1816 K_606_dGDP
	 0.1	;	 %  1817 K_606_ATP

	 % Reaction: 607 ndk_BG10282_2.7.4.6::REVERSE -- 
	 1.0	;	 %  1818 k_607_cat
	 0.1	;	 %  1819 K_607_dGTP
	 0.1	;	 %  1820 K_607_ADP

	 %% Enzyme degradation constants -- 
	 0.01	;	 %  1821 kd_E_1
	 0.01	;	 %  1822 kd_E_2
	 0.01	;	 %  1823 kd_E_3
	 0.01	;	 %  1824 kd_E_4
	 0.01	;	 %  1825 kd_E_5
	 0.01	;	 %  1826 kd_E_6
	 0.01	;	 %  1827 kd_E_7
	 0.01	;	 %  1828 kd_E_8
	 0.01	;	 %  1829 kd_E_9
	 0.01	;	 %  1830 kd_E_10
	 0.01	;	 %  1831 kd_E_11
	 0.01	;	 %  1832 kd_E_12
	 0.01	;	 %  1833 kd_E_13
	 0.01	;	 %  1834 kd_E_14
	 0.01	;	 %  1835 kd_E_15
	 0.01	;	 %  1836 kd_E_16
	 0.01	;	 %  1837 kd_E_17
	 0.01	;	 %  1838 kd_E_18
	 0.01	;	 %  1839 kd_E_19
	 0.01	;	 %  1840 kd_E_20
	 0.01	;	 %  1841 kd_E_21
	 0.01	;	 %  1842 kd_E_22
	 0.01	;	 %  1843 kd_E_23
	 0.01	;	 %  1844 kd_E_24
	 0.01	;	 %  1845 kd_E_25
	 0.01	;	 %  1846 kd_E_26
	 0.01	;	 %  1847 kd_E_27
	 0.01	;	 %  1848 kd_E_28
	 0.01	;	 %  1849 kd_E_29
	 0.01	;	 %  1850 kd_E_30
	 0.01	;	 %  1851 kd_E_31
	 0.01	;	 %  1852 kd_E_32
	 0.01	;	 %  1853 kd_E_33
	 0.01	;	 %  1854 kd_E_34
	 0.01	;	 %  1855 kd_E_35
	 0.01	;	 %  1856 kd_E_36
	 0.01	;	 %  1857 kd_E_37
	 0.01	;	 %  1858 kd_E_38
	 0.01	;	 %  1859 kd_E_39
	 0.01	;	 %  1860 kd_E_40
	 0.01	;	 %  1861 kd_E_41
	 0.01	;	 %  1862 kd_E_42
	 0.01	;	 %  1863 kd_E_43
	 0.01	;	 %  1864 kd_E_44
	 0.01	;	 %  1865 kd_E_45
	 0.01	;	 %  1866 kd_E_46
	 0.01	;	 %  1867 kd_E_47
	 0.01	;	 %  1868 kd_E_48
	 0.01	;	 %  1869 kd_E_49
	 0.01	;	 %  1870 kd_E_50
	 0.01	;	 %  1871 kd_E_51
	 0.01	;	 %  1872 kd_E_52
	 0.01	;	 %  1873 kd_E_53
	 0.01	;	 %  1874 kd_E_54
	 0.01	;	 %  1875 kd_E_55
	 0.01	;	 %  1876 kd_E_56
	 0.01	;	 %  1877 kd_E_57
	 0.01	;	 %  1878 kd_E_58
	 0.01	;	 %  1879 kd_E_59
	 0.01	;	 %  1880 kd_E_60
	 0.01	;	 %  1881 kd_E_61
	 0.01	;	 %  1882 kd_E_62
	 0.01	;	 %  1883 kd_E_63
	 0.01	;	 %  1884 kd_E_64
	 0.01	;	 %  1885 kd_E_65
	 0.01	;	 %  1886 kd_E_66
	 0.01	;	 %  1887 kd_E_67
	 0.01	;	 %  1888 kd_E_68
	 0.01	;	 %  1889 kd_E_69
	 0.01	;	 %  1890 kd_E_70
	 0.01	;	 %  1891 kd_E_71
	 0.01	;	 %  1892 kd_E_72
	 0.01	;	 %  1893 kd_E_73
	 0.01	;	 %  1894 kd_E_74
	 0.01	;	 %  1895 kd_E_75
	 0.01	;	 %  1896 kd_E_76
	 0.01	;	 %  1897 kd_E_77
	 0.01	;	 %  1898 kd_E_78
	 0.01	;	 %  1899 kd_E_79
	 0.01	;	 %  1900 kd_E_80
	 0.01	;	 %  1901 kd_E_81
	 0.01	;	 %  1902 kd_E_82
	 0.01	;	 %  1903 kd_E_83
	 0.01	;	 %  1904 kd_E_84
	 0.01	;	 %  1905 kd_E_85
	 0.01	;	 %  1906 kd_E_86
	 0.01	;	 %  1907 kd_E_87
	 0.01	;	 %  1908 kd_E_88
	 0.01	;	 %  1909 kd_E_89
	 0.01	;	 %  1910 kd_E_90
	 0.01	;	 %  1911 kd_E_91
	 0.01	;	 %  1912 kd_E_92
	 0.01	;	 %  1913 kd_E_93
	 0.01	;	 %  1914 kd_E_94
	 0.01	;	 %  1915 kd_E_95
	 0.01	;	 %  1916 kd_E_96
	 0.01	;	 %  1917 kd_E_97
	 0.01	;	 %  1918 kd_E_98
	 0.01	;	 %  1919 kd_E_99
	 0.01	;	 %  1920 kd_E_100
	 0.01	;	 %  1921 kd_E_101
	 0.01	;	 %  1922 kd_E_102
	 0.01	;	 %  1923 kd_E_103
	 0.01	;	 %  1924 kd_E_104
	 0.01	;	 %  1925 kd_E_105
	 0.01	;	 %  1926 kd_E_106
	 0.01	;	 %  1927 kd_E_107
	 0.01	;	 %  1928 kd_E_108
	 0.01	;	 %  1929 kd_E_109
	 0.01	;	 %  1930 kd_E_110
	 0.01	;	 %  1931 kd_E_111
	 0.01	;	 %  1932 kd_E_112
	 0.01	;	 %  1933 kd_E_113
	 0.01	;	 %  1934 kd_E_114
	 0.01	;	 %  1935 kd_E_115
	 0.01	;	 %  1936 kd_E_116
	 0.01	;	 %  1937 kd_E_117
	 0.01	;	 %  1938 kd_E_118
	 0.01	;	 %  1939 kd_E_119
	 0.01	;	 %  1940 kd_E_120
	 0.01	;	 %  1941 kd_E_121
	 0.01	;	 %  1942 kd_E_122
	 0.01	;	 %  1943 kd_E_123
	 0.01	;	 %  1944 kd_E_124
	 0.01	;	 %  1945 kd_E_125
	 0.01	;	 %  1946 kd_E_126
	 0.01	;	 %  1947 kd_E_127
	 0.01	;	 %  1948 kd_E_128
	 0.01	;	 %  1949 kd_E_129
	 0.01	;	 %  1950 kd_E_130
	 0.01	;	 %  1951 kd_E_131
	 0.01	;	 %  1952 kd_E_132
	 0.01	;	 %  1953 kd_E_133
	 0.01	;	 %  1954 kd_E_134
	 0.01	;	 %  1955 kd_E_135
	 0.01	;	 %  1956 kd_E_136
	 0.01	;	 %  1957 kd_E_137
	 0.01	;	 %  1958 kd_E_138
	 0.01	;	 %  1959 kd_E_139
	 0.01	;	 %  1960 kd_E_140
	 0.01	;	 %  1961 kd_E_141
	 0.01	;	 %  1962 kd_E_142
	 0.01	;	 %  1963 kd_E_143
	 0.01	;	 %  1964 kd_E_144
	 0.01	;	 %  1965 kd_E_145
	 0.01	;	 %  1966 kd_E_146
	 0.01	;	 %  1967 kd_E_147
	 0.01	;	 %  1968 kd_E_148
	 0.01	;	 %  1969 kd_E_149
	 0.01	;	 %  1970 kd_E_150
	 0.01	;	 %  1971 kd_E_151
	 0.01	;	 %  1972 kd_E_152
	 0.01	;	 %  1973 kd_E_153
	 0.01	;	 %  1974 kd_E_154
	 0.01	;	 %  1975 kd_E_155
	 0.01	;	 %  1976 kd_E_156
	 0.01	;	 %  1977 kd_E_157
	 0.01	;	 %  1978 kd_E_158
	 0.01	;	 %  1979 kd_E_159
	 0.01	;	 %  1980 kd_E_160
	 0.01	;	 %  1981 kd_E_161
	 0.01	;	 %  1982 kd_E_162
	 0.01	;	 %  1983 kd_E_163
	 0.01	;	 %  1984 kd_E_164
	 0.01	;	 %  1985 kd_E_165
	 0.01	;	 %  1986 kd_E_166
	 0.01	;	 %  1987 kd_E_167
	 0.01	;	 %  1988 kd_E_168
	 0.01	;	 %  1989 kd_E_169
	 0.01	;	 %  1990 kd_E_170
	 0.01	;	 %  1991 kd_E_171
	 0.01	;	 %  1992 kd_E_172
	 0.01	;	 %  1993 kd_E_173
	 0.01	;	 %  1994 kd_E_174
	 0.01	;	 %  1995 kd_E_175
	 0.01	;	 %  1996 kd_E_176
	 0.01	;	 %  1997 kd_E_177
	 0.01	;	 %  1998 kd_E_178
	 0.01	;	 %  1999 kd_E_179
	 0.01	;	 %  2000 kd_E_180
	 0.01	;	 %  2001 kd_E_181
	 0.01	;	 %  2002 kd_E_182
	 0.01	;	 %  2003 kd_E_183
	 0.01	;	 %  2004 kd_E_184
	 0.01	;	 %  2005 kd_E_185
	 0.01	;	 %  2006 kd_E_186
	 0.01	;	 %  2007 kd_E_187
	 0.01	;	 %  2008 kd_E_188
	 0.01	;	 %  2009 kd_E_189
	 0.01	;	 %  2010 kd_E_190
	 0.01	;	 %  2011 kd_E_191
	 0.01	;	 %  2012 kd_E_192
	 0.01	;	 %  2013 kd_E_193
	 0.01	;	 %  2014 kd_E_194
	 0.01	;	 %  2015 kd_E_195
	 0.01	;	 %  2016 kd_E_196
	 0.01	;	 %  2017 kd_E_197
	 0.01	;	 %  2018 kd_E_198
	 0.01	;	 %  2019 kd_E_199
	 0.01	;	 %  2020 kd_E_200
	 0.01	;	 %  2021 kd_E_201
	 0.01	;	 %  2022 kd_E_202
	 0.01	;	 %  2023 kd_E_203
	 0.01	;	 %  2024 kd_E_204
	 0.01	;	 %  2025 kd_E_205
	 0.01	;	 %  2026 kd_E_206
	 0.01	;	 %  2027 kd_E_207
	 0.01	;	 %  2028 kd_E_208
	 0.01	;	 %  2029 kd_E_209
	 0.01	;	 %  2030 kd_E_210
	 0.01	;	 %  2031 kd_E_211
	 0.01	;	 %  2032 kd_E_212
	 0.01	;	 %  2033 kd_E_213
	 0.01	;	 %  2034 kd_E_214
	 0.01	;	 %  2035 kd_E_215
	 0.01	;	 %  2036 kd_E_216
	 0.01	;	 %  2037 kd_E_217
	 0.01	;	 %  2038 kd_E_218
	 0.01	;	 %  2039 kd_E_219
	 0.01	;	 %  2040 kd_E_220
	 0.01	;	 %  2041 kd_E_221
	 0.01	;	 %  2042 kd_E_222
	 0.01	;	 %  2043 kd_E_223
	 0.01	;	 %  2044 kd_E_224
	 0.01	;	 %  2045 kd_E_225
	 0.01	;	 %  2046 kd_E_226
	 0.01	;	 %  2047 kd_E_227
	 0.01	;	 %  2048 kd_E_228
	 0.01	;	 %  2049 kd_E_229
	 0.01	;	 %  2050 kd_E_230
	 0.01	;	 %  2051 kd_E_231
	 0.01	;	 %  2052 kd_E_232
	 0.01	;	 %  2053 kd_E_233
	 0.01	;	 %  2054 kd_E_234
	 0.01	;	 %  2055 kd_E_235
	 0.01	;	 %  2056 kd_E_236
	 0.01	;	 %  2057 kd_E_237
	 0.01	;	 %  2058 kd_E_238
	 0.01	;	 %  2059 kd_E_239
	 0.01	;	 %  2060 kd_E_240
	 0.01	;	 %  2061 kd_E_241
	 0.01	;	 %  2062 kd_E_242
	 0.01	;	 %  2063 kd_E_243
	 0.01	;	 %  2064 kd_E_244
	 0.01	;	 %  2065 kd_E_245
	 0.01	;	 %  2066 kd_E_246
	 0.01	;	 %  2067 kd_E_247
	 0.01	;	 %  2068 kd_E_248
	 0.01	;	 %  2069 kd_E_249
	 0.01	;	 %  2070 kd_E_250
	 0.01	;	 %  2071 kd_E_251
	 0.01	;	 %  2072 kd_E_252
	 0.01	;	 %  2073 kd_E_253
	 0.01	;	 %  2074 kd_E_254
	 0.01	;	 %  2075 kd_E_255
	 0.01	;	 %  2076 kd_E_256
	 0.01	;	 %  2077 kd_E_257
	 0.01	;	 %  2078 kd_E_258
	 0.01	;	 %  2079 kd_E_259
	 0.01	;	 %  2080 kd_E_260
	 0.01	;	 %  2081 kd_E_261
	 0.01	;	 %  2082 kd_E_262
	 0.01	;	 %  2083 kd_E_263
	 0.01	;	 %  2084 kd_E_264
	 0.01	;	 %  2085 kd_E_265
	 0.01	;	 %  2086 kd_E_266
	 0.01	;	 %  2087 kd_E_267
	 0.01	;	 %  2088 kd_E_268
	 0.01	;	 %  2089 kd_E_269
	 0.01	;	 %  2090 kd_E_270
	 0.01	;	 %  2091 kd_E_271
	 0.01	;	 %  2092 kd_E_272
	 0.01	;	 %  2093 kd_E_273
	 0.01	;	 %  2094 kd_E_274
	 0.01	;	 %  2095 kd_E_275
	 0.01	;	 %  2096 kd_E_276
	 0.01	;	 %  2097 kd_E_277
	 0.01	;	 %  2098 kd_E_278
	 0.01	;	 %  2099 kd_E_279
	 0.01	;	 %  2100 kd_E_280
	 0.01	;	 %  2101 kd_E_281
	 0.01	;	 %  2102 kd_E_282
	 0.01	;	 %  2103 kd_E_283
	 0.01	;	 %  2104 kd_E_284
	 0.01	;	 %  2105 kd_E_285
	 0.01	;	 %  2106 kd_E_286
	 0.01	;	 %  2107 kd_E_287
	 0.01	;	 %  2108 kd_E_288
	 0.01	;	 %  2109 kd_E_289
	 0.01	;	 %  2110 kd_E_290
	 0.01	;	 %  2111 kd_E_291
	 0.01	;	 %  2112 kd_E_292
	 0.01	;	 %  2113 kd_E_293
	 0.01	;	 %  2114 kd_E_294
	 0.01	;	 %  2115 kd_E_295
	 0.01	;	 %  2116 kd_E_296
	 0.01	;	 %  2117 kd_E_297
	 0.01	;	 %  2118 kd_E_298
	 0.01	;	 %  2119 kd_E_299
	 0.01	;	 %  2120 kd_E_300
	 0.01	;	 %  2121 kd_E_301
	 0.01	;	 %  2122 kd_E_302
	 0.01	;	 %  2123 kd_E_303
	 0.01	;	 %  2124 kd_E_304
	 0.01	;	 %  2125 kd_E_305
];

% Initial conditions --
IC = [
	0.0	;	%	1	FUM
	0.0	;	%	2	E_76
	0.0	;	%	3	SUCC
	0.0	;	%	4	E_85
	0.0	;	%	5	E_154
	0.0	;	%	6	E_94
	0.0	;	%	7	E_59
	0.0	;	%	8	E_265
	0.0	;	%	9	NCAIR
	0.0	;	%	10	E_68
	0.0	;	%	11	E_77
	0.0	;	%	12	E_86
	0.0	;	%	13	SLF
	0.0	;	%	14	E_95
	0.0	;	%	15	PHOSPHORIBOSYL-FORMIMINO-AICAR-P
	0.0	;	%	16	GL3P
	0.0	;	%	17	E_105
	0.0	;	%	18	E_216
	0.0	;	%	19	E_69
	0.0	;	%	20	N6-ACETYL-L-LYSINE
	0.0	;	%	21	E_78
	0.0	;	%	22	NH3
	0.0	;	%	23	2PG
	0.0	;	%	24	E_87
	0.0	;	%	25	E_155
	0.0	;	%	26	E_266
	0.0	;	%	27	E_96
	0.0	;	%	28	E_200
	0.0	;	%	29	E_79
	0.0	;	%	30	E_88
	0.0	;	%	31	E_250
	0.0	;	%	32	E_97
	0.0	;	%	33	E_106
	0.0	;	%	34	E_217
	0.0	;	%	35	ACETOIN
	0.0	;	%	36	MET
	0.0	;	%	37	F6P
	0.0	;	%	38	HEXT
	0.0	;	%	39	E_89
	0.0	;	%	40	E_156
	0.0	;	%	41	E_267
	0.0	;	%	42	E_98
	0.0	;	%	43	E_201
	0.0	;	%	44	2K-4CH3-PENTANOATE
	0.0	;	%	45	bALA
	0.0	;	%	46	E_140
	0.0	;	%	47	E_251
	0.0	;	%	48	PPIxt
	0.0	;	%	49	E_99
	0.0	;	%	50	E_107
	0.0	;	%	51	E_218
	0.0	;	%	52	DIHYDROPTERIN-CH2OH-PP
	0.0	;	%	53	E_190
	0.0	;	%	54	TMP
	0.0	;	%	55	E_157
	0.0	;	%	56	E_268
	0.0	;	%	57	E_202
	0.0	;	%	58	E_141
	0.0	;	%	59	E_252
	0.0	;	%	60	HISTIDINOL
	0.0	;	%	61	E_108
	0.0	;	%	62	OAA
	0.0	;	%	63	E_219
	0.0	;	%	64	dCDP
	0.0	;	%	65	HS
	0.0	;	%	66	2-KETO-3-METHYL-VALERATE
	0.0	;	%	67	E_191
	0.0	;	%	68	E_158
	0.0	;	%	69	E_269
	0.0	;	%	70	AMPxt
	0.0	;	%	71	DIHYDRO-NEO-PTERIN
	0.0	;	%	72	PANT
	0.0	;	%	73	E_203
	0.0	;	%	74	HCYS
	0.0	;	%	75	DIAMPIM
	0.0	;	%	76	O-SUCCINYL-L-HOMOSERINE
	0.0	;	%	77	E_142
	0.0	;	%	78	E_253
	0.0	;	%	79	ASUCC
	0.0	;	%	80	E_109
	0.0	;	%	81	UREA
	0.0	;	%	82	E_192
	0.0	;	%	83	dGMP
	0.0	;	%	84	E_159
	0.0	;	%	85	E_204
	0.0	;	%	86	PIxt
	0.0	;	%	87	E_143
	0.0	;	%	88	HSER
	0.0	;	%	89	E_254
	0.0	;	%	90	Fi-c
	0.0	;	%	91	PRAM
	0.0	;	%	92	Acetyl-CoA
	0.0	;	%	93	3-DEHYDRO-SHIKIMATE
	0.0	;	%	94	E_1
	0.0	;	%	95	E_193
	0.0	;	%	96	AIR
	0.0	;	%	97	PYR
	0.0	;	%	98	E_2
	0.0	;	%	99	D-ALANINE
	0.0	;	%	100	dADP
	0.0	;	%	101	E_205
	0.0	;	%	102	E_3
	0.0	;	%	103	LEU
	0.0	;	%	104	E_144
	0.0	;	%	105	E_255
	0.0	;	%	106	E_4
	0.0	;	%	107	E_300
	0.0	;	%	108	PHENYLACETATE
	0.0	;	%	109	E_194
	0.0	;	%	110	E_5
	0.0	;	%	111	10-FORMYL-THF
	0.0	;	%	112	E_206
	0.0	;	%	113	E_6
	0.0	;	%	114	SER
	0.0	;	%	115	INDOLE-3-GLYCEROL-P
	0.0	;	%	116	E_7
	0.0	;	%	117	E_145
	0.0	;	%	118	E_256
	0.0	;	%	119	E_301
	0.0	;	%	120	E_8
	0.0	;	%	121	HIS
	0.0	;	%	122	O2
	0.0	;	%	123	E_195
	0.0	;	%	124	ARG
	0.0	;	%	125	C01268
	0.0	;	%	126	E_9
	0.0	;	%	127	E_240
	0.0	;	%	128	1-KETO-2-METHYLVALERATE
	0.0	;	%	129	IMIDAZOLE-ACETOL-P
	0.0	;	%	130	E_207
	0.0	;	%	131	VAL
	0.0	;	%	132	CDP
	0.0	;	%	133	E_290
	0.0	;	%	134	E_146
	0.0	;	%	135	E_257
	0.0	;	%	136	E_302
	0.0	;	%	137	2-ACETO-2-HYDROXY-BUTYRATE
	0.0	;	%	138	PRO
	0.0	;	%	139	AMINO-OH-HYDROXYMETHYL-DIHYDROPTERIDINE
	0.0	;	%	140	FOR
	0.0	;	%	141	E_196
	0.0	;	%	142	NAD
	0.0	;	%	143	E_130
	0.0	;	%	144	OTRD
	0.0	;	%	145	E_241
	0.0	;	%	146	E_208
	0.0	;	%	147	dGTP
	0.0	;	%	148	7_8-DIHYDROPTEROATE
	0.0	;	%	149	E_180
	0.0	;	%	150	E_291
	0.0	;	%	151	E_147
	0.0	;	%	152	dCMP
	0.0	;	%	153	E_258
	0.0	;	%	154	PHOSPHORIBOSYL-ATP
	0.0	;	%	155	R5P
	0.0	;	%	156	E_303
	0.0	;	%	157	CTP
	0.0	;	%	158	E_197
	0.0	;	%	159	E_131
	0.0	;	%	160	E_242
	0.0	;	%	161	ACETALDEHYDE
	0.0	;	%	162	E_209
	0.0	;	%	163	E_181
	0.0	;	%	164	E_292
	0.0	;	%	165	E_148
	0.0	;	%	166	E_259
	0.0	;	%	167	PROPANOATE
	0.0	;	%	168	RTRD
	0.0	;	%	169	E_304
	0.0	;	%	170	HISTIDINAL
	0.0	;	%	171	E_198
	0.0	;	%	172	E_132
	0.0	;	%	173	E_243
	0.0	;	%	174	2KD6PG
	0.0	;	%	175	GAR
	0.0	;	%	176	E_182
	0.0	;	%	177	E_293
	0.0	;	%	178	E_149
	0.0	;	%	179	E_305
	0.0	;	%	180	dAMP
	0.0	;	%	181	E_199
	0.0	;	%	182	FAD
	0.0	;	%	183	E_133
	0.0	;	%	184	E_244
	0.0	;	%	185	THF
	0.0	;	%	186	C01304
	0.0	;	%	187	ILE
	0.0	;	%	188	RIBOFLAVIN
	0.0	;	%	189	E_183
	0.0	;	%	190	E_294
	0.0	;	%	191	DHAP
	0.0	;	%	192	ORN
	0.0	;	%	193	L-BETA-ASPARTYL-P
	0.0	;	%	194	E_134
	0.0	;	%	195	L-CYSTATHIONINE
	0.0	;	%	196	ACP
	0.0	;	%	197	E_245
	0.0	;	%	198	2-ACETO-LACTATE
	0.0	;	%	199	FGAM
	0.0	;	%	200	GA3P
	0.0	;	%	201	CMP
	0.0	;	%	202	E_184
	0.0	;	%	203	E_295
	0.0	;	%	204	|N-(5-PHOSPHORIBOSYL)-ANTHRANILATE|
	0.0	;	%	205	CO2
	0.0	;	%	206	S7P
	0.0	;	%	207	ppGTP
	0.0	;	%	208	SAICAR
	0.0	;	%	209	AKP
	0.0	;	%	210	PHENYL-PYRUVATE
	0.0	;	%	211	ALA
	0.0	;	%	212	dCTP
	0.0	;	%	213	E_135
	0.0	;	%	214	ASN
	0.0	;	%	215	E_246
	0.0	;	%	216	E_185
	0.0	;	%	217	E_296
	0.0	;	%	218	E_230
	0.0	;	%	219	ASP
	0.0	;	%	220	NOSUCC
	0.0	;	%	221	G15L6P
	0.0	;	%	222	E_280
	0.0	;	%	223	GLYCOLALDEHYDE
	0.0	;	%	224	E_136
	0.0	;	%	225	E_247
	0.0	;	%	226	PHOSPHORIBULOSYL-FORMIMINO-AICAR-P
	0.0	;	%	227	THR
	0.0	;	%	228	E_186
	0.0	;	%	229	E_297
	0.0	;	%	230	2-ACETOLACTATE
	0.0	;	%	231	PREPHENATE
	0.0	;	%	232	E_120
	0.0	;	%	233	E_231
	0.0	;	%	234	MAL
	0.0	;	%	235	X5P
	0.0	;	%	236	3-DEOXY-D_ARBINO-HEPT-2-ULOSONATE
	0.0	;	%	237	FGAR
	0.0	;	%	238	E_170
	0.0	;	%	239	E_281
	0.0	;	%	240	dUDP
	0.0	;	%	241	E_137
	0.0	;	%	242	E_248
	0.0	;	%	243	dATP
	0.0	;	%	244	E_187
	0.0	;	%	245	E_298
	0.0	;	%	246	E_121
	0.0	;	%	247	ASPSALD
	0.0	;	%	248	E_232
	0.0	;	%	249	PRPP
	0.0	;	%	250	PHENYL-ACETALDEHYDE
	0.0	;	%	251	E_171
	0.0	;	%	252	E_282
	0.0	;	%	253	E_138
	0.0	;	%	254	E_249
	0.0	;	%	255	Hxt
	0.0	;	%	256	dTDP
	0.0	;	%	257	F16BP
	0.0	;	%	258	5-FORMYL-THF
	0.0	;	%	259	ADP
	0.0	;	%	260	PI
	0.0	;	%	261	E_188
	0.0	;	%	262	E_299
	0.0	;	%	263	E_122
	0.0	;	%	264	E_233
	0.0	;	%	265	URI
	0.0	;	%	266	LAC
	0.0	;	%	267	3-CARBOXY-3-HYDROXY-ISOCAPROATE
	0.0	;	%	268	E_172
	0.0	;	%	269	XMP
	0.0	;	%	270	E_283
	0.0	;	%	271	ANTHRANILATE
	0.0	;	%	272	E_139
	0.0	;	%	273	2_3-BUTANEDIOL
	0.0	;	%	274	NH3xt
	0.0	;	%	275	DIHYDROFOLATE
	0.0	;	%	276	SHIKIMATE-5P
	0.0	;	%	277	E_189
	0.0	;	%	278	O-PHOSPHO-L-HOMOSERINE
	0.0	;	%	279	E_123
	0.0	;	%	280	E_234
	0.0	;	%	281	ATP
	0.0	;	%	282	E_173
	0.0	;	%	283	E_284
	0.0	;	%	284	ppGDP
	0.0	;	%	285	IMP
	0.0	;	%	286	FADH
	0.0	;	%	287	E_124
	0.0	;	%	288	E_235
	0.0	;	%	289	Q1
	0.0	;	%	290	Q2
	0.0	;	%	291	E_174
	0.0	;	%	292	E_285
	0.0	;	%	293	A5P
	0.0	;	%	294	DIHYDRONEOPTERIN-P
	0.0	;	%	295	PEP
	0.0	;	%	296	4-AMINO-4-DEOXYCHORISMATE
	0.0	;	%	297	E_125
	0.0	;	%	298	GLC
	0.0	;	%	299	E_236
	0.0	;	%	300	CoA
	0.0	;	%	301	DIHYDRONEOPTERIN-P3
	0.0	;	%	302	E_175
	0.0	;	%	303	E_286
	0.0	;	%	304	E_220
	0.0	;	%	305	TYR
	0.0	;	%	306	E_270
	0.0	;	%	307	E_126
	0.0	;	%	308	E_237
	0.0	;	%	309	dUMP
	0.0	;	%	310	PRODUCT
	0.0	;	%	311	PYYCX
	0.0	;	%	312	E_176
	0.0	;	%	313	GDPxt
	0.0	;	%	314	E_287
	0.0	;	%	315	CHOR
	0.0	;	%	316	E_110
	0.0	;	%	317	E_221
	0.0	;	%	318	2-OXOBUTANOATE
	0.0	;	%	319	SHIKIMATE
	0.0	;	%	320	AICAR
	0.0	;	%	321	AMP
	0.0	;	%	322	E_160
	0.0	;	%	323	E_271
	0.0	;	%	324	E_127
	0.0	;	%	325	E_238
	0.0	;	%	326	dTMP
	0.0	;	%	327	E_177
	0.0	;	%	328	E_288
	0.0	;	%	329	PHOSPHORIBOSYL-AMP
	0.0	;	%	330	E_111
	0.0	;	%	331	E_222
	0.0	;	%	332	GDP
	0.0	;	%	333	PNTO
	0.0	;	%	334	E_161
	0.0	;	%	335	E_272
	0.0	;	%	336	E_128
	0.0	;	%	337	GLN
	0.0	;	%	338	NADH
	0.0	;	%	339	E_239
	0.0	;	%	340	E_178
	0.0	;	%	341	E_289
	0.0	;	%	342	TRP
	0.0	;	%	343	CITR
	0.0	;	%	344	E_112
	0.0	;	%	345	E_223
	0.0	;	%	346	DEHYDROQUINATE
	0.0	;	%	347	L-GLUTAMTE-5-SA
	0.0	;	%	348	LYS
	0.0	;	%	349	E_162
	0.0	;	%	350	L-GLUTAMATE-5P
	0.0	;	%	351	E_273
	0.0	;	%	352	E_129
	0.0	;	%	353	GTP
	0.0	;	%	354	E_179
	0.0	;	%	355	NADPH
	0.0	;	%	356	METHYLENE-THF
	0.0	;	%	357	E_113
	0.0	;	%	358	E_224
	0.0	;	%	359	AC
	0.0	;	%	360	CO2xt
	0.0	;	%	361	E_163
	0.0	;	%	362	GLU
	0.0	;	%	363	E_274
	0.0	;	%	364	E_10
	0.0	;	%	365	E_114
	0.0	;	%	366	E_225
	0.0	;	%	367	P-HYDROXY-PHENYLPYRUVATE
	0.0	;	%	368	dUTP
	0.0	;	%	369	CAIR
	0.0	;	%	370	ACETYLSERINE
	0.0	;	%	371	GLX
	0.0	;	%	372	E_11
	0.0	;	%	373	6PDG
	0.0	;	%	374	UDP
	0.0	;	%	375	E_20
	0.0	;	%	376	E_164
	0.0	;	%	377	E_275
	0.0	;	%	378	GLY
	0.0	;	%	379	L-HISTIDINOL-P
	0.0	;	%	380	E_12
	0.0	;	%	381	E_21
	0.0	;	%	382	2-D-THREO-HYDROXY-3-CARBOXY-ISOCAPROATE
	0.0	;	%	383	E_115
	0.0	;	%	384	E_30
	0.0	;	%	385	E_226
	0.0	;	%	386	dTTP
	0.0	;	%	387	E_13
	0.0	;	%	388	E_165
	0.0	;	%	389	E_276
	0.0	;	%	390	E_22
	0.0	;	%	391	E_210
	0.0	;	%	392	E_31
	0.0	;	%	393	NADP
	0.0	;	%	394	E_40
	0.0	;	%	395	E_14
	0.0	;	%	396	UTP
	0.0	;	%	397	E_260
	0.0	;	%	398	E_23
	0.0	;	%	399	ICIT
	0.0	;	%	400	E_116
	0.0	;	%	401	E_32
	0.0	;	%	402	E_227
	0.0	;	%	403	E_41
	0.0	;	%	404	PROPIONYL-PHOSPHATE
	0.0	;	%	405	GMP
	0.0	;	%	406	SLFxt
	0.0	;	%	407	E_15
	0.0	;	%	408	CARBOXYPHENYLAMINO-DEOXYRIBULOSE-P
	0.0	;	%	409	E_50
	0.0	;	%	410	E_166
	0.0	;	%	411	E_24
	0.0	;	%	412	DBP
	0.0	;	%	413	E_100
	0.0	;	%	414	RAU
	0.0	;	%	415	E_33
	0.0	;	%	416	CAP
	0.0	;	%	417	4-AMINOBENZOATE
	0.0	;	%	418	E_211
	0.0	;	%	419	E_42
	0.0	;	%	420	DRL
	0.0	;	%	421	E_277
	0.0	;	%	422	E_51
	0.0	;	%	423	E_16
	0.0	;	%	424	E_150
	0.0	;	%	425	5_10-METHENYL-THF
	0.0	;	%	426	OGA
	0.0	;	%	427	E_25
	0.0	;	%	428	E_117
	0.0	;	%	429	E_60
	0.0	;	%	430	E_228
	0.0	;	%	431	E_34
	0.0	;	%	432	E_261
	0.0	;	%	433	E_43
	0.0	;	%	434	3PG
	0.0	;	%	435	E_52
	0.0	;	%	436	E_17
	0.0	;	%	437	E_167
	0.0	;	%	438	E_278
	0.0	;	%	439	E_61
	0.0	;	%	440	E_26
	0.0	;	%	441	E_101
	0.0	;	%	442	E_212
	0.0	;	%	443	E_70
	0.0	;	%	444	E_35
	0.0	;	%	445	SUCCCoA
	0.0	;	%	446	GL
	0.0	;	%	447	2-KETO-ISOVALERATE
	0.0	;	%	448	E_44
	0.0	;	%	449	OIVAL
	0.0	;	%	450	PHE
	0.0	;	%	451	E_53
	0.0	;	%	452	E_151
	0.0	;	%	453	E_18
	0.0	;	%	454	E_262
	0.0	;	%	455	E_62
	0.0	;	%	456	E_27
	0.0	;	%	457	E_118
	0.0	;	%	458	RU5P
	0.0	;	%	459	E_71
	0.0	;	%	460	E_36
	0.0	;	%	461	E_229
	0.0	;	%	462	G6P
	0.0	;	%	463	E_80
	0.0	;	%	464	E_45
	0.0	;	%	465	E_54
	0.0	;	%	466	E_19
	0.0	;	%	467	CIT
	0.0	;	%	468	E_168
	0.0	;	%	469	E_63
	0.0	;	%	470	E_102
	0.0	;	%	471	E_28
	0.0	;	%	472	E_213
	0.0	;	%	473	E_72
	0.0	;	%	474	PRFICA
	0.0	;	%	475	E_37
	0.0	;	%	476	E_279
	0.0	;	%	477	E4P
	0.0	;	%	478	E_46
	0.0	;	%	479	E_81
	0.0	;	%	480	TDP
	0.0	;	%	481	E_55
	0.0	;	%	482	E_152
	0.0	;	%	483	E_90
	0.0	;	%	484	E_263
	0.0	;	%	485	E_119
	0.0	;	%	486	E_29
	0.0	;	%	487	E_64
	0.0	;	%	488	E_73
	0.0	;	%	489	E_38
	0.0	;	%	490	O2xt
	0.0	;	%	491	E_82
	0.0	;	%	492	CYTD
	0.0	;	%	493	E_47
	0.0	;	%	494	UMP
	0.0	;	%	495	E_91
	0.0	;	%	496	E_56
	0.0	;	%	497	E_169
	0.0	;	%	498	E_103
	0.0	;	%	499	PPI
	0.0	;	%	500	Fo-c
	0.0	;	%	501	ETH
	0.0	;	%	502	G13P
	0.0	;	%	503	CYS
	0.0	;	%	504	E_39
	0.0	;	%	505	E_74
	0.0	;	%	506	E_83
	0.0	;	%	507	E_48
	0.0	;	%	508	APD
	0.0	;	%	509	E_65
	0.0	;	%	510	E_153
	0.0	;	%	511	E_57
	0.0	;	%	512	E_92
	0.0	;	%	513	3-ENOLPYRUVYL-SHIKIMATE-5P
	0.0	;	%	514	E_214
	0.0	;	%	515	E_66
	0.0	;	%	516	dGDP
	0.0	;	%	517	E_264
	0.0	;	%	518	E_75
	0.0	;	%	519	FMN
	0.0	;	%	520	DIOH-ISOVALERATE
	0.0	;	%	521	E_84
	0.0	;	%	522	E_49
	0.0	;	%	523	TTP
	0.0	;	%	524	E_93
	0.0	;	%	525	E_58
	0.0	;	%	526	E_104
	0.0	;	%	527	D-ERYTHRO-IMIDAZOLE-GLYCEROL-P
	0.0	;	%	528	E_67
	0.0	;	%	529	E_215
];


% Initialize the measurement selection matrix. Default is *all* the states -- 
MEASUREMENT_INDEX_VECTOR = [1:NSTATES];

% =========== DO NOT EDIT BELOW THIS LINE ========================== %
DF.INITIAL_CONDITION_VECTOR       =   IC;
DF.PARAMETER_VECTOR               =   kV;
DF.MEASUREMENT_SELECTION_VECTOR   = MEASUREMENT_INDEX_VECTOR;
DF.NUMBER_PARAMETERS              =   NPARAMETERS;
DF.NUMBER_OF_STATES               =   NSTATES;
DF.NUMBER_OF_RATES                =   NRATES;
% ================================================================== %

return;
