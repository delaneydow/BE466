% AUTHOR: DELANEY DOW
% CREATED: 04/26/2022 
% SENIOR DESIGN SPRING 2022 TEAM 17 
% ANA
%% ANALYSIS FILE BEGIN
%Analysis and predictions file 

%import all of the parameters from ODE_Main after getting the parameters 
%parse through .xlsx file that holds values 

paramVals = readtable('param.xlsx'); 
%% get params 

kdeg3 = paramVals.kdeg3; %get all kdeg3
kobs = paramVals.kobs;  %get all kobs 
ec503 = paramVals.ec503;  %get all ec503 

%% take averages 
%take averages of each parameter to get 'true' parameter 
    %can also look into machine learning toolbox to get nclpi to see how
    %"true" each param. value is 
kdeg3True = mean(kdeg3); 
kobsTrue = mean(kobs); 
ec503True = mean(ec503); 

%are these good true values? statistical analysis of "True" values 
    
 %% make predictions    
%use new paramter to get predicted mKate2 concentrations for experiment 3(b) and 3(c) 
    %send to ODE_Main and ZEV_Induction_ODE to generate these GFP
    %concentratins, import additional .xlsx file that stores experimental
    %mKate2 concentrations 
    
mKate2Param = readtable('mKate2Vals.xlsx'); %experimental values, get from data sheet 
expB = mKate2Param.Exp3B; 
expC = mKate2Param.Exp3C; 

expC = expC(~isnan(expC));
expB = expB(~isnan(expB));

%[1,6,7,8,9,10,11,12,13,14,15,16,17,18,29]

 expCHr = [expC(1) expC(301) expC(361) expC(421) expC(481) expC(541) expC(601)...
     expC(661) expC(721) expC(781) expC(841) expC(901) expC(961) expC(1021) expC(1680)]';

%[1,3,4,5,6,7,8,9,10,11,12,13,14,15,27]
expBHr = [0.000001 4.439526209 30.30058128 64.92166299 81.59282107 90.17031634 ...
    93.36172836 95.66412431 96.95350687 97.64957588 98.04318293 98.26134111 ...
    98.37052643 98.44099626 98.52350987]; 
%expBHr = [expB(1) expB(121) expB(181) expB(241) expB(301) expB(361) expB(421) ...
    %expB(481) expB(541) expB(601) expB(661) expB(721) expB(781) expB(841) expB(1560)]'; 

bParams = readtable('IntStagB.xlsx');
yas330B = bParams.yAS330;
yas331B = bParams.yAS331; 

cParams = readtable('IntStagC.xlsx'); 
yas330C = cParams.yAS330; 
yas331C = cParams.yAS331; 

%scale 
yas330B = 100*yas330B./max(yas330B);
yas331B = 100*yas331B./max(yas331B); 

yas330C = 100*yas330C./max(yas330C);
yas331C = 100*yas331C./max(yas331C);

timeB = [1 3:15 27]; 

expTimeB = linspace(0,26,26*60)';
expTimeC = linspace(0, 28, 28*60); 
timeC = [1 6:18 29]; 

%get predicted values: call _IntStagB & _IntStagC, replace kdeg, kobs, ec503 vals 
    %use dummy vals for now, use actual predicted output for now  


%% plot 
%err330B = abs(expBHr-yas330B)./expBHr*100; 
%err330B = interp1(timeB, err330B); 
% pos = zeros(1, length(timeB));
% neg = zeros(1, length(timeB));
% pos(expBHr < yas330B) = err330B(expBHr < yas330B);
% neg(expBHr > yas330B) = err330B(expBHr > yas330B);

%erro331B = ones(size(yas331B));

err330C = ones(size(yas330C));
erro331C = ones(size(yas331C));



figure(1); 
%set(gca,'FontSize',100); 
plot(timeB, expBHr, 'c-', 'LineWidth', 3.0); hold on; 
plot(timeB,yas330B, '-', 'Color', '#7E2F8E', 'LineWidth', 3.0);   
plot(timeB, yas331B, '-', 'Color', '#77AC30', 'LineWidth', 3.0);
lgdA =legend('Predicted Values', 'yAS330 Experimental Values', 'yAS331 Experimental Values'); 
lgdA.FontSize = 12; 
title('Predicted vs. Actual Results for Experiment 3a', 'FontSize', 20); 
ylabel('[mKATE2]', 'FontSize', 16); 
xlabel('Time (hours)', 'FontSize', 16); 
ylim([-5 105]); 


figure(2); 
plot(timeC,expCHr,'c-', 'LineWidth', 3.0);hold on;
plot(timeC,yas330C, '-', 'Color', '#7E2F8E','LineWidth', 3.0);
plot(timeC, yas331C, '-', 'Color', '#77AC30','LineWidth', 3.0); 
lgdB =  legend('Predicted Values', 'yAS330 Experimental Values', 'yAS331 Experimental Values'); 
lgdB.FontSize = 12; 
title('Predicted vs. Actual Results for Experiment 3b', 'FontSize', 20); 
ylabel('[mKATE2]', 'FontSize', 16); 
xlabel('Time (hours)', 'FontSize', 16);
ylim([-5 105]);

%% analsysis of predicted vs. actual 
%calculate significant difference between actual and predicted for each
%experiment 

%predicted vs. actual for 3(b)
% [hB, tB] = ttest(expB, predB, 'Alpha', 0.15); %two sample ttest 
% %predicted vs. actual for 3(c)
% [hC, tC]= ttest(expC, predC, 'Alpha', 0.15); %two sample ttest

%compare amongst all results as well as across experiments 
   