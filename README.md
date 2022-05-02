# BE466
Senior Design Project 

## Authors 
Delaney M. Dow (programming contributer),
Hannah Collins (programming contributer) 

Emily Hill (team member),
Blaire Smith (team member) 

## Project Abstract 
Synthetic biology is an emerging multidisciplinary field that involves the synthesis of de novo cellular components. We designed a genetic circuit in Saccharomyces cerevisiae that utilizes molecular assembly kinetics to perform “input coherence detection”. These circuits can differentiate between two distinct input signals and detect when both are present, allowing for greater specificity and fine-tuned output control to make a synthetic circuit more akin to natural biological circuits. Our system leverages oligomerizing protein-protein pairs that can form both homodimers and heterodimers. Each oligomerizing domain is fused to half a synthetic transcription factor and controlled by distinct chemical inputs. In the presence of both input signals (i.e. hormones), co-expression of both protein domains drives formation of heterodimers to activate circuit output. Staggered induction will drive production of homodimeric complexes that delay circuit activation. Through a series of experiments, we measured fluorescent output in response to varied temporal input sequences. Our results indicate that allowing the first inducer to saturate decreased the time needed for heterodimers to form after addition of the second inducer. We also found that introducing both inducers simultaneously drove the fastest reporter response, while staggering inductions delayed heterodimer formation. We developed a computational model of our circuit based on protein-protein assembly kinetics and our experimental data to predict temporally-dependent responses of the system to varied inputs. By modeling our synthetic circuit under physiologically relevant conditions, we have contributed to the toolbox of synthetic parts available for future applications in vivo.

## Description
The following repository stores the code for the modeling component of our senior design project at Boston University, titled Designing, Modeling, and Constructing Coherence Detection Synthetic Gene Circuits Based on Protein Oligimerization. 
The modeling component was based on a series of three experiments conducted to be used as training data on our model of a series of ordinary differential equations. The training data optimized specific parameters in our equations, and the outputs of the system were predicted on a different set of experiments to test the model's accuracy. 

## Navigating the Repository 
The training data folder contains all of the datasets used for the training data, as well as the matlab files used to collect the predicted outputs. 

The testing data folder contains all of the datasets used for the testing data, as well as the matlab files used to collect the predicted outputs. 

The ZEV_Induction_ODE.m file was used to generate the ODE oututs for all functions in the training/testing data folders, hence why it is not in a specific folder. 
The fitting.m file was used to measure the accuracy of the model in the testing vs. training data outputs. 

## Suggested Readings and Follow Up Information

C.J. Bashor, N. Patel, S. Choubey, A. Beyzavi, J. Kondev, J.J. Collins, A.S. Khalil, “Complex signal processing in synthetic gene circuits using cooperative regulatory assemblies.” Science, 364(6440):593-597, (2019).

A.S. Khalil, J.J. Collins. “Synthetic biology: applications come of age.” The Sci and App of Syn and Sys Bio: Workshop Summ, 11:367-379, (2010).

https://www.bu.edu/khalillab/

