// ------------------------------------------------------------------------------------ %
// Copyright (c) 2014 Varnerlab,  
// School of Chemical and Biomolecular Engineering,  
// Cornell University, Ithaca NY 14853 USA. 
// - 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is  
// furnished to do so, subject to the following conditions: 
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software. 
// - 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE. 
// ------------------------------------------------------------------------------------ %
#include <octave/oct.h>
#include <ov-struct.h>
#include <iostream>
#include <math.h>

// Function prototypes - 
void calculateKinetics(ColumnVector&,ColumnVector&,ColumnVector&);
void calculateMassBalances(int,int,Matrix&,ColumnVector&,ColumnVector&);


DEFUN_DLD(BalanceEquations,args,nargout,"Calculate the mass balances.")
{
	// Initialize variables --
	ColumnVector xV(args(0).vector_value());        // Get the state vector (index 0);
	Matrix STMATRIX(args(2).matrix_value());        // Get the stoichiometric matrix;
	ColumnVector kVM(args(3).vector_value());		// Rate constant vector;
	const int NRATES = args(4).int_value();         // Number of rates
	const int NSTATES = args(5).int_value();        // Number of states
	ColumnVector rV=ColumnVector(NRATES);           // Setup the rate vector;
	ColumnVector dx = ColumnVector(NSTATES);        // dxdt vector;

	// Calculate the kinetics -- 
	calculateKinetics(kVM,xV,rV);

	// Calculate the mass balance equations --
	calculateMassBalances(NRATES,NSTATES,STMATRIX,rV,dx);

	// return the mass balances --
	return octave_value(dx);
};

void calculateKinetics(ColumnVector& kV,ColumnVector& xV,ColumnVector& rV)
{
	// Formulate the kinetics - 
	// First alias the species symbols (helps with debugging)
	float C3_H20 = xV(0,0);	// compartment: MODEL
	float C3 = xV(1,0);	// compartment: MODEL
	float C3_H20_FB = xV(2,0);	// compartment: MODEL
	float FactorB = xV(3,0);	// compartment: MODEL
	float C3_H20_FB_FD = xV(4,0);	// compartment: MODEL
	float FactorD = xV(5,0);	// compartment: MODEL
	float C3Bb_H20 = xV(6,0);	// compartment: MODEL
	float C3Bb_H20_C3 = xV(7,0);	// compartment: MODEL
	float C3a = xV(8,0);	// compartment: MODEL
	float C3b = xV(9,0);	// compartment: MODEL
	float Bb = xV(10,0);	// compartment: MODEL
	float C3b_S = xV(11,0);	// compartment: MODEL
	float S = xV(12,0);	// compartment: MODEL
	float C3b_S_FB = xV(13,0);	// compartment: MODEL
	float C3b_S_FB_FD = xV(14,0);	// compartment: MODEL
	float C3bBb_S = xV(15,0);	// compartment: MODEL
	float FBF = xV(16,0);	// compartment: MODEL
	float C3bBb_S_FP = xV(17,0);	// compartment: MODEL
	float FactorP = xV(18,0);	// compartment: MODEL
	float C3bBb = xV(19,0);	// compartment: MODEL
	float FP_S = xV(20,0);	// compartment: MODEL
	float C3b_FP_S = xV(21,0);	// compartment: MODEL
	float C3b_FP_S_FB = xV(22,0);	// compartment: MODEL
	float C3b_FP_S_FB_FD = xV(23,0);	// compartment: MODEL
	float C3_C3bBb_S_FP = xV(24,0);	// compartment: MODEL
	float C3_C3bBb_S = xV(25,0);	// compartment: MODEL
	float C3bBbC3b_S_FP = xV(26,0);	// compartment: MODEL
	float C3bBbC3b_S = xV(27,0);	// compartment: MODEL
	float C3bBbC3b_S_C5 = xV(28,0);	// compartment: MODEL
	float C5 = xV(29,0);	// compartment: MODEL
	float C3bBbC3b_S_FP_C5 = xV(30,0);	// compartment: MODEL
	float C5a = xV(31,0);	// compartment: MODEL
	float C5b = xV(32,0);	// compartment: MODEL
	float C5b_S = xV(33,0);	// compartment: MODEL
	float C5b_S_C6 = xV(34,0);	// compartment: MODEL
	float C6 = xV(35,0);	// compartment: MODEL
	float C5b_S_C6_C7 = xV(36,0);	// compartment: MODEL
	float C7 = xV(37,0);	// compartment: MODEL
	float C5b_S_C6_C7_C8 = xV(38,0);	// compartment: MODEL
	float C8 = xV(39,0);	// compartment: MODEL
	float C5b_S_C6_C7_C8_C9 = xV(40,0);	// compartment: MODEL
	float C9 = xV(41,0);	// compartment: MODEL
	float C3b_FH = xV(42,0);	// compartment: MODEL
	float FactorH = xV(43,0);	// compartment: MODEL
	float C3b_FH_FI = xV(44,0);	// compartment: MODEL
	float FactorI = xV(45,0);	// compartment: MODEL
	float iC3b = xV(46,0);	// compartment: MODEL
	float C5b_S_C6_C7_PS = xV(47,0);	// compartment: MODEL
	float PS = xV(48,0);	// compartment: MODEL
	float C5b_S_C6_C7_C8_Clu = xV(49,0);	// compartment: MODEL
	float Clu = xV(50,0);	// compartment: MODEL
	float C4bp = xV(51,0);	// compartment: MODEL
	float C3Bb = xV(52,0);	// compartment: MODEL

	// Next calculate the rates - 
	rV(0,0) = kV(0,0)*C3;
	rV(1,0) = kV(1,0)*C3_H20;
	rV(2,0) = kV(2,0)*C3_H20*FactorB;
	rV(3,0) = kV(3,0)*C3_H20_FB;
	rV(4,0) = kV(4,0)*C3_H20_FB*FactorD;
	rV(5,0) = kV(5,0)*C3_H20_FB_FD;
	rV(6,0) = kV(6,0)*C3_H20_FB_FD;
	rV(7,0) = kV(7,0)*C3Bb_H20*C3;
	rV(8,0) = kV(8,0)*C3Bb_H20_C3;
	rV(9,0) = kV(9,0)*C3Bb_H20;
	rV(10,0) = kV(10,0)*C3_H20*Bb;
	rV(11,0) = kV(11,0)*C3b*S;
	rV(12,0) = kV(12,0)*C3b_S;
	rV(13,0) = kV(13,0)*C3b_S*FactorB;
	rV(14,0) = kV(14,0)*C3b_S_FB;
	rV(15,0) = kV(15,0)*C3b_S_FB*FactorD;
	rV(16,0) = kV(16,0)*C3b_S_FB_FD;
	rV(17,0) = kV(17,0)*C3b_S_FB_FD;
	rV(18,0) = kV(18,0)*C3bBb_S*FactorP;
	rV(19,0) = kV(19,0)*C3bBb_S;
	rV(20,0) = kV(20,0)*C3b_S*Bb;
	rV(21,0) = kV(21,0)*C3bBb_S;
	rV(22,0) = kV(22,0)*FactorP*S;
	rV(23,0) = kV(23,0)*FP_S;
	rV(24,0) = kV(24,0)*C3b*FP_S;
	rV(25,0) = kV(25,0)*C3b_FP_S;
	rV(26,0) = kV(26,0)*C3b_FP_S*FactorB;
	rV(27,0) = kV(27,0)*C3b_FP_S_FB;
	rV(28,0) = kV(28,0)*C3b_FP_S_FB*FactorD;
	rV(29,0) = kV(29,0)*C3b_FP_S_FB_FD;
	rV(30,0) = kV(30,0)*C3b_FP_S_FB_FD;
	rV(31,0) = kV(31,0)*C3bBb_S_FP*C3;
	rV(32,0) = kV(32,0)*C3_C3bBb_S_FP;
	rV(33,0) = kV(33,0)*C3_C3bBb_S_FP;
	rV(34,0) = kV(34,0)*C3b*C3a*C3bBb_S_FP;
	rV(35,0) = kV(35,0)*C3bBb_S*C3;
	rV(36,0) = kV(36,0)*C3_C3bBb_S;
	rV(37,0) = kV(37,0)*C3_C3bBb_S;
	rV(38,0) = kV(38,0)*C3b*C3a*C3bBb_S;
	rV(39,0) = kV(39,0)*C3bBb_S_FP*C3b;
	rV(40,0) = kV(40,0)*C3bBbC3b_S_FP;
	rV(41,0) = kV(41,0)*C3bBb_S*C3b;
	rV(42,0) = kV(42,0)*C3bBbC3b_S;
	rV(43,0) = kV(43,0)*C3bBbC3b_S*C5;
	rV(44,0) = kV(44,0)*C3bBbC3b_S_C5;
	rV(45,0) = kV(45,0)*C3bBbC3b_S_FP*C5;
	rV(46,0) = kV(46,0)*C3bBbC3b_S_FP_C5;
	rV(47,0) = kV(47,0)*C3bBbC3b_S_C5;
	rV(48,0) = kV(48,0)*C3bBbC3b_S*C5a*C5b;
	rV(49,0) = kV(49,0)*C3bBbC3b_S_FP_C5;
	rV(50,0) = kV(50,0)*C3bBbC3b_S_FP*C5a*C5b;
	rV(51,0) = kV(51,0)*C5b*S;
	rV(52,0) = kV(52,0)*C5b_S;
	rV(53,0) = kV(53,0)*C5b_S*C6;
	rV(54,0) = kV(54,0)*C5b_S_C6;
	rV(55,0) = kV(55,0)*C5b_S_C6*C7;
	rV(56,0) = kV(56,0)*C5b_S_C6_C7;
	rV(57,0) = kV(57,0)*C5b_S_C6_C7*C8;
	rV(58,0) = kV(58,0)*C5b_S_C6_C7_C8;
	rV(59,0) = kV(59,0)*C5b_S_C6_C7_C8*C9;
	rV(60,0) = kV(60,0)*C5b_S_C6_C7_C8_C9;
	rV(61,0) = kV(61,0)*C3b*FactorH;
	rV(62,0) = kV(62,0)*C3b_FH;
	rV(63,0) = kV(63,0)*C3b_FH*FactorI;
	rV(64,0) = kV(64,0)*C3b_FH_FI;
	rV(65,0) = kV(65,0)*C3b_FH_FI;
	rV(66,0) = kV(66,0)*iC3b*FactorI*FactorH;
	rV(67,0) = kV(67,0)*C5b_S_C6_C7*PS;
	rV(68,0) = kV(68,0)*C5b_S_C6_C7_PS;
	rV(69,0) = kV(69,0)*C5b_S_C6_C7_C8*Clu;
	rV(70,0) = kV(70,0)*C5b_S_C6_C7_C8_Clu;
	rV(71,0) = kV(71,0);
	rV(72,0) = kV(72,0)*C3;
	rV(73,0) = kV(73,0);
	rV(74,0) = kV(74,0)*C5;
	rV(75,0) = kV(75,0);
	rV(76,0) = kV(76,0)*C6;
	rV(77,0) = kV(77,0);
	rV(78,0) = kV(78,0)*C7;
	rV(79,0) = kV(79,0);
	rV(80,0) = kV(80,0)*C8;
	rV(81,0) = kV(81,0);
	rV(82,0) = kV(82,0)*C9;
	rV(83,0) = kV(83,0);
	rV(84,0) = kV(84,0)*C4bp;
	rV(85,0) = kV(85,0);
	rV(86,0) = kV(86,0)*PS;
	rV(87,0) = kV(87,0);
	rV(88,0) = kV(88,0)*FactorB;
	rV(89,0) = kV(89,0);
	rV(90,0) = kV(90,0)*FactorD;
	rV(91,0) = kV(91,0);
	rV(92,0) = kV(92,0)*FactorH;
	rV(93,0) = kV(93,0);
	rV(94,0) = kV(94,0)*FactorI;
	rV(95,0) = kV(95,0);
	rV(96,0) = kV(96,0)*FactorP;
	rV(97,0) = kV(97,0);
	rV(98,0) = kV(98,0)*Clu;
	rV(99,0) = kV(99,0)*C3;
	rV(100,0) = kV(100,0);
	rV(101,0) = kV(101,0)*C5;
	rV(102,0) = kV(102,0);
	rV(103,0) = kV(103,0)*C6;
	rV(104,0) = kV(104,0);
	rV(105,0) = kV(105,0)*C7;
	rV(106,0) = kV(106,0);
	rV(107,0) = kV(107,0)*C8;
	rV(108,0) = kV(108,0);
	rV(109,0) = kV(109,0)*C9;
	rV(110,0) = kV(110,0);
	rV(111,0) = kV(111,0)*C4bp;
	rV(112,0) = kV(112,0);
	rV(113,0) = kV(113,0)*PS;
	rV(114,0) = kV(114,0);
	rV(115,0) = kV(115,0)*C3Bb;
	rV(116,0) = kV(116,0);
	rV(117,0) = kV(117,0)*FactorB;
	rV(118,0) = kV(118,0);
	rV(119,0) = kV(119,0)*FactorD;
	rV(120,0) = kV(120,0);
	rV(121,0) = kV(121,0)*FactorH;
	rV(122,0) = kV(122,0);
	rV(123,0) = kV(123,0)*FactorI;
	rV(124,0) = kV(124,0);
	rV(125,0) = kV(125,0)*FactorP;
	rV(126,0) = kV(126,0);
	rV(127,0) = kV(127,0)*Clu;
	rV(128,0) = kV(128,0);
	rV(129,0) = kV(129,0)*FBF;
	rV(130,0) = kV(130,0);
	rV(131,0) = kV(131,0)*C3a;
	rV(132,0) = kV(132,0);
	rV(133,0) = kV(133,0)*C3b;
	rV(134,0) = kV(134,0);
	rV(135,0) = kV(135,0)*C5a;
	rV(136,0) = kV(136,0);
	rV(137,0) = kV(137,0)*C5b;
	rV(138,0) = kV(138,0);
	rV(139,0) = kV(139,0)*Bb;
	rV(140,0) = kV(140,0);

}

void calculateMassBalances(int NRATES,int NSTATES,Matrix& STMATRIX,ColumnVector& rV,ColumnVector& dx)
{
	// Write the mass balance equations (compact form) -- 
	dx=STMATRIX*rV;

}

