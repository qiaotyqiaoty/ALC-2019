% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ?017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

% Check material

% clean start
clear all; close all; clc;

% forcing function
Time = 0:0.01:10;
V = 0.05*sin(Time);

% material property
% Element = 'Elastic';
% Element = 'BLElastic';
% Element = 'BLHysteretic';
Element = 'ElasticNoTension';

MatData = zeros(1,50);
MatData(1,1) = 1;       % tag
MatData(1,2) = 200000;  % E
MatData(1,3) = 345;     % Fy yield stress
MatData(1,4) = 0.01;    % b hardening ratio
MatData(1,5) = 28;
MatData(1,6) = 0.925;
MatData(1,7) = 0.15;
MatData(1,8) = 0.085;
MatData(1,9) = 1;
MatData(1,10) = 0.07;
MatData(1,11) = 1;
MatData(1,12) = 0;

% initialize the material
[MatData,~] = feval(Element,'initialize',MatData);
[MatData,E] = feval(Element,'getInitialStiffness',MatData);
[MatData,Fs] = feval(Element,'getInitialFlexibility',MatData);
 
% loop through the force vector
P = zeros(length(V),1);
for nn = 1:length(P)
    [MatData,~] = feval(Element,'setTrialStrain',MatData,V(nn));
    [MatData,P(nn)] = feval(Element,'getStress',MatData);
    [MatData,~] = feval(Element,'commitState',MatData);
end
 
figure;
plot(V,P)
xlabel('Displacement')
ylabel('Force')
grid
