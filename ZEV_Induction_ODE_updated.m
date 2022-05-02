function dxdt = ZEV_Induction_ODE_updated(t,x,time,Est,Ald,kact,kdeg1,kdeg2,kdeg3,nH_Est, nH_Ald, nH_het, ec501, ec502, ec503, kobs)

%% Interpolate Estradiol dose onto time vector
EstI = interp1(time,Est,t);

%% interpolate aldosterone dose onto time vector
AldI = interp1(time,Ald,t);

%% PROTEINS
AA_conc = x(1);          % Cytosolic ZEV
BB_conc = x(2);           % Nuclear ZEV
MKATE2 = x(3);               % GFP
dxdt = zeros(3,1);        % ODE column Vector

%% PARAMETERS
% nH_Est    = Hill Coefficient for estradiol
% nH_Ald    = Hill Coefficient for aldosterone
% nH_het    = Hill Coefficient for heterodimer
% kact      = Transcriptional activation rate
% kdeg1     = Degredation rate of AA
% kdeg2     = Degredation rate of BB
% kdeg3     = Degredation rate of mKate
% ec501     = Half maximal effective concentration for estradiol
% ec502     = Half maximal effective concentration for aldosterone
% ec503     = Half maximal effective concentration for heterodimer
% kobs      = Exchange rate homo-/hetero-dimer


% d[AA]/dt estradiol
dxdt(1) = kact*[EstI]^nH_Est/([EstI]^nH_Est + ec501^nH_Est) - kdeg1*[AA_conc]; 

% d[BB]/dt aldosterone
dxdt(2) = kact*[AldI]^nH_Ald/([AldI]^nH_Ald + ec502^nH_Ald) - kdeg2*[BB_conc];

%d[mKate]/dt                  
dxdt(3) = kact*[(AA_conc.*BB_conc./kobs).^0.5]^nH_het/([(AA_conc.*BB_conc./kobs).^0.5]^nH_het + ec503^nH_het) - kdeg3*[MKATE2];

end
