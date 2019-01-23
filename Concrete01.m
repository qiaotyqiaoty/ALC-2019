% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   ?017, ACTS Technologies Inc.   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   All Rights Reserved   %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

function [MatData,Result] = Concrete01(action,MatData,edp)
% ELASTICNOTENSION elastic-no-tension material
% varargout = ElasticNoTension(action,MatData,stress)
%
% action  : switch with following possible values
%              'initialize'         initialize internal variables
%              'setTrialStress'     set the trial stress
%              'getStress'          get the current stress
%              'getStrain'          get the current strain
%              'getTangent'         get the current tangent flexibility
%              'getInitialTangent'  get the initial tangent flexibility
%              'commitState'        commit state of internal variables
% MatData : data structure with material information
% edp     : trial stress or strain


%#codegen
% extract material properties
tag   = MatData(1,1);      % unique material tag
fpc   = MatData(1,2);      % concrete maximum compressive strength (negative)
epsc  = MatData(1,3);      % concrete strain at maximum strength (negative)
fpcu  = MatData(1,4);      % concrete crushing strength (negative)
epscu = MatData(1,5);      % concrete strain at crushing strength (negative)
% trial variables
stressT = MatData(1,6);
strainT = MatData(1,7);
% state history variables
stressC = MatData(1,8);
strainC = MatData(1,9);


switch action
   % ======================================================================
   case 'initialize'
       strainT = 0;
       stressT = 0;
       Result = 0;
       
   % ======================================================================
   case 'setTrialStrain'
       strainT = edp;
       Result = 0;  
        
   % ======================================================================
   case 'setTrialStress'
       stressT = edp;
       Result = 0;  
      
   % ======================================================================
   case 'getStrain'
       Result = strainT;
      
   % ======================================================================
   case 'getStress'
       if strainT < 0
           Result = E*strainT;
       else
           Result = 0;
       end
      
   % ======================================================================
   case 'getFlexibility'
       if strainT < 0
           Result = 1/E;
       else
           Result = 1e10*1/E;  % Take 10^10*(1/E) as infinity
       end
      
   % ======================================================================
   case 'getStiffness'
       if strainT < 0
           Result = E;
       else
           Result = 1e10*1/E;  % Take 10^10*(1/E) as infinity
       end
      
   % ======================================================================
   case 'getInitialStiffness'
       Result = E;
      
   % ======================================================================
   case 'getInitialFlexibility'
       Result = 1/E;
        
   % ======================================================================
   case 'commitState'
       Result = 0;
      
   % ======================================================================
end

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = fpc;
MatData(1,3) = epsc;
MatData(1,4) = strainT;

end
