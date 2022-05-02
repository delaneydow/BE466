clear all, clc

%using source: 
%https://www.mathworks.com/help/optim/ug/nonlinear-curve-fitting-with-lsqcurvefit.html


%% Initial Conditions; would be equivalent to an inducer 

AA_conc = 0.001;          % AA homodimer initial (nM)
BB_conc = 0.001;         %BB homodimer initial (nM)
MKATE2 = 0.000;               % mKate2

initialC = [AA_conc BB_conc MKATE2]; 

%% Parameters

nH_Est = 1.2;              % Hill for Est known from Baker
nH_Ald = 1.2;              % Hill for Ald known from Baker
nH_het = 1.163;              %                   ***Optimize this value??

kact = 0.97;                % Transcriptional activation rate for all equations

kdeg1 = 0.01;           % Degredation rate of AA
kdeg2 = 0.01;           % Degredation rate of BB
kdeg3 = 0.0089;         % Degredation rate of mKate       **Optimize this value

%ec values, dissociation constant 
ec501 = 64; %nM, known from Baker (Est)
ec502 = 200; %nM, known from Baker (Ald)
ec503 = 196; %nM, guess for now

kobs = 1.25e-4;          % Exchange rate parameter from Baker; not precise  **Optimize this value

%% read in experimental data  
% this section uses dataset 'intStagC.xlsx' and yAS331 strain as examples 

tableVals = readtable('intStagC.xlsx'); %CAN USE ANY DATA SET HERE
expStrainVal = tableVals.yAS331; %stores values of specific strain for experiment type
expStrainVal = expStrainVal'; 

simTime = [1 6:18 29]; %HAVE TO ADJUST TIME VECTOR ACCORDING TO WHEN TIME POINTS WERE TAKEN
simTime = simTime.*60;

%% fitting 
 
expStrainVal = 100*expStrainVal./max(expStrainVal);
t=simTime';
c=expStrainVal';
theta0=[kdeg3;ec503;kobs;nH_het; AA_conc; BB_conc; MKATE2];

options = optimoptions('lsqcurvefit','OptimalityTolerance', 1e-15, 'FunctionTolerance', ...,
    1e-16, 'StepTolerance', 1e-22, 'MaxFunctionEvaluations', 1e2, 'MaxIterations', 1e2); 
[theta,Rsdnrm,Rsd,ExFlg,OptmInfo,Lmda,Jmat]=lsqcurvefit(@kinetics,theta0,t,c, [], [], options);
% for the lsqcurvefit function, there is the option to add lower and upper bounds 

%% solve ODE
% Time Vector, need to change time vector depending on which experiment 
tmin = 0;                    % start time
tmax = 28*60;                 % end time (min.) 
inc  = 28*60;                  % # of time steps
time = linspace(tmin,tmax,inc);

% Induction Vector (when Estradiol is given to cells over time course)
ON_time = 28*60;              % Units = min.
OFF_time = (0)*60;             % Units = min.
Est = 100*[ones(1,ceil((ON_time/tmax)*inc)) zeros(1,floor((OFF_time/tmax)*inc))];

%Induction Vector for Aldosterone
ON_A = 4*60; %ON for aldosterone, units = min 
OFF_A = 24*60; %OFF for aldosterone, units = min 
Ald = 100*[zeros(1,ceil((ON_A/tmax)*inc)) ones(1,floor((OFF_A/tmax)*inc))]; %units = nM
%% 
[T,X] = ode45(@(t,y)ZEV_Induction_ODE_updated(t,y,time,Est,Ald,kact,kdeg1,kdeg2,theta(1),nH_Est, nH_Ald, theta(4), ec501, ec502, theta(2), theta(3)),time, initialC);
AA_conc = X(:,1);
BB_conc = X(:,2);
MKATE2 = X(:,3);

%% plotting - verification that the proposed optimizations match the actual experimental values

plot(simTime,c,'ko'); hold on;
plot(time,MKATE2); 

%% function 

function C = kinetics(theta,t)
    %dcdt=zeros(3,1);
    c0 = theta(5:7);      %[AA_conc BB_conc MKATE2]
    [T,Cv]=ode45(@DifEq,t,c0);

    function dC = DifEq(t,c)
        dcdt=zeros(3,1);       
        
        AA_conc = c0(1); 
        BB_conc = c0(2); 
        MKATE2 = c0(3); 
        
        nH_Est = 1.2;              % Hill for Est known from Baker
        nH_Ald = 1.2;              % Hill for Ald known from Baker
        nH_het = 1.2;              %      ***Optimize this value??

        kact = 1;                  % Transcriptional activation rate for all equations

        kdeg1 = 0.01;              % Degredation rate of AA
        kdeg2 = 0.01; 
        
        ec501 = 64; %nM, known from Baker (Est)
        ec502 = 200; %nM, known from Baker (Ald)
        
        %NOTE: THESE VALUES MAY NEED TO CHANGE DEPENDING ON # OF TIME
        %POINTS AND TIME OF STAGGERING IN EACH EXPERIMENT
        tmin = 0;                    % start time
        tmax = 28*60;                 % end time (min.)
        inc  = 28*60;                  % # of time steps
        time = linspace(tmin,tmax,inc); 
        
        ON_time = 28*60;              % Units = min.
        OFF_time = 0;             % Units = min.
        Est  = 100*[ones(1,(ON_time/tmax)*inc) zeros(1,(OFF_time/tmax)*inc)];
        
        ON_A = 4*60; %ON for aldosterone, units = min 
        OFF_A = 24*60; %OFF for aldosterone, units = min 
        Ald = 100*[ones(1,(ON_A/tmax)*inc) zeros(1,(OFF_A/tmax)*inc)]; %units = nM
               
        EstI = interp1(time,Est,t)';
        AldI = interp1(time,Ald,t)';
        
        dcdt(1) = kact.*[EstI].^nH_Est./([EstI].^nH_Est + ec501.^nH_Est) - kdeg1.*c(1);
        dcdt(2) = kact.*[AldI].^nH_Ald./([AldI].^nH_Ald + ec502.^nH_Ald) - kdeg2.*c(2);
        dcdt(3) = kact.*[c(1).*c(2)./(theta(3)).^0.5]^theta(4)./([c(1).*c(2)./(theta(3)).^0.5].^theta(4) + theta(2).^nH_het) - theta(1).*c(3);
        dC=dcdt;
    end
C=Cv(:,3);
C(find(isnan(C))) = 0;

end
