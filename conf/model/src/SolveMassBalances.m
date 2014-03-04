function [TSIM,X,OUTPUT]= SolveMassBalances(pDataFile,TSTART,TSTOP,Ts,DFIN)
% Check to see if I need to load the datafile -- 
if (~isempty(DFIN))
	DF = DFIN;
else
	DF = feval(pDataFile,TSTART,TSTOP,Ts,[]);
end;

% Get reqd stuff from data struct -- 
IC = DF.INITIAL_CONDITIONS;
TSIM = TSTART:Ts:TSTOP;
S = DF.STOICHIOMETRIC_MATRIX;
kV = DF.PARAMETER_VECTOR;
NUMBER_OF_RATES = DF.NUMBER_OF_RATES;
NUMBER_OF_STATES = DF.NUMBER_OF_STATES;
MEASUREMENT_INDEX_VECTOR = DF.MEASUREMENT_SELECTION_VECTOR;

% Solve the mass balances using LSODE -- 
pBalanceEquations = @(x,t)BalanceEquations(x,t,DF,S,kV,NUMBER_OF_STATES,NUMBER_OF_RATES);
X = lsode(pBalanceEquations,IC,TSIM);

% make sure all is positive - 
X = abs(X);

% Calculate the output - 
OUTPUT = X(:,MEASUREMENT_INDEX_VECTOR);

% return to caller -- 
return;
