% AUTHOR: DELANEY DOW
% CREATED: 04/26/2022 
% SENIOR DESIGN SPRING 2022 TEAM 17 
    
 %% GENERATE PREDICTIONS    
%use new paramter to get predicted mKate2 concentrations for experiment 3(b) and 3(c) 
    %send to ODE_Main and ZEV_Induction_ODE to generate these GFP
    %concentratins, import additional .xlsx file that stores experimental
    %mKate2 concentrations 
    
mKate2Param = readtable('mKate2Vals.xlsx'); %experimental values, get from data sheet 
expB = mKate2Param.Exp3B; 
expC = mKate2Param.Exp3C; 

expC = expC(~isnan(expC));
expB = expB(~isnan(expB));

%select values from predicted values (which are done by the minute) to be
%hourly timepoints

expBHr = [expB(1) expB(121) expB(181) expB(241) expB(301) expB(361) expB(421) ...
    expB(481) expB(541) expB(601) expB(661) expB(721) expB(781) expB(841) expB(1560)]'; 

 expCHr = [expC(1) expC(301) expC(361) expC(421) expC(481) expC(541) expC(601)...
     expC(661) expC(721) expC(781) expC(841) expC(901) expC(961) expC(1021) expC(1680)]';

%READ IN PARAMETERS FROM 3A AND 3B EXPERIMENTS 
bParams = readtable('IntStagB.xlsx');
yas330B = bParams.yAS330;
yas331B = bParams.yAS331; 

cParams = readtable('IntStagC.xlsx'); 
yas330C = cParams.yAS330; 
yas331C = cParams.yAS331; 

%scaling to be out of 100 
yas330B = 100*yas330B./max(yas330B);
yas331B = 100*yas331B./max(yas331B); 

yas330C = 100*yas330C./max(yas330C);
yas331C = 100*yas331C./max(yas331C);

timeB = [1 3:15 27]; 

expTimeB = linspace(0,26,26*60)';
expTimeC = linspace(0, 28, 28*60); 
timeC = [1 6:18 29]; 


%% plot 

figure(1);  
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
