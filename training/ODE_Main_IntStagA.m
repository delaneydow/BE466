clear all, clc

%% Initialize time parameters

% Time Vector, need to change time vector depending on which experiment 
tmin = 0;                    % start time
tmax = 58*60;                 % end time (min.) 
inc  = 58*60;                  % # of time steps
time = linspace(tmin,tmax,inc);

% Induction Vector (when Estradiol is given to cells over time course)
ON_time = 58*60;              % Units = min.
OFF_time = 0*60;             % Units = min.
Est = 100*[ones(1,ceil((ON_time/tmax)*inc)) zeros(1,floor((OFF_time/tmax)*inc))];

%Induction Vector for Aldosterone
ON_A = 12*60; %ON for aldosterone, units = min 
OFF_A = 46*60; %OFF for aldosterone, units = min 
Ald = 100*[zeros(1,ceil((ON_A/tmax)*inc)) ones(1,floor((OFF_A/tmax)*inc))]; %units = nM


%% Initial Conditions; would be equivalent to an inducer 

AA_conc = 0;          % AA homodimer initial (nM)
BB_conc = 0;         %BB homodimer initial (nM)
MKATE2 = 0;               % mKate2  

initialC = [AA_conc BB_conc MKATE2]; 

%% Parameters

nH_Est = 1.2;              % Hill for Est known from Baker
nH_Ald = 1.2;              % Hill for Ald known from Baker
nH_het = 1.2;              %                   ***Optimize this value??

kact = 1;                % Transcriptional activation rate for all equations

kdeg1 = 0.01;           % Degredation rate of AA
kdeg2 = 0.01;           % Degredation rate of BB
kdeg3 = 0.01;         % Degredation rate of mKate       **Optimize this value

%ec values, dissociation constant 
ec501 = 64; %nM, known from Baker (Est)
ec502 = 200; %nM, known from Baker (Ald)
ec503 = 132; %nM, guess for now

kobs = 1e-4;          % Exchange rate parameter from Baker; not precise  **Optimize this value
%% Run ODE

[T,X] = ode45(@(t,y)ZEV_Induction_ODE_updated(t,y,time,Est,Ald,kact,kdeg1,kdeg2,kdeg3,nH_Est, nH_Ald, nH_het, ec501, ec502, ec503, kobs), time, initialC);

% Unpack Variables
AA_conc = X(:,1);
BB_conc = X(:,2);
MKATE2 = X(:,3);

%% Plot Data

    figure(1)
    %estradiol curve 
    subplot(3,1,1)
    plot(time,Est,'k-')
    legend('Estradiol')
    set(gca,'FontSize',18)
    xlim([tmin tmax]);
    ylim([0 110]);
    ylabel('[Est] (normalized)','FontSize',18)
    
    %aldosterone curve 
    subplot(3,1,2); 
    plot(time, Ald, 'r-'); 
    legend('Aldosterone'); 
    set(gca,'FontSize',18)
    xlim([tmin tmax]);
    ylim([0 110]);
    ylabel('[Ald] (normalized)','FontSize',18)

    %mKate curve 
    subplot(3,1,3)
    plot(time,MKATE2,'b-'); hold on
    legend('mKate2')
    set(gca,'FontSize',18)
    xlim([tmin tmax]);
    ylim([0 max(MKATE2)*1.1])
    xlabel('time (min.)','FontSize',18)
    ylabel('[mKate2] (normalized)','FontSize',18)