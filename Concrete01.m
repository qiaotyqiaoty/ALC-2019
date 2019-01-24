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
strainCmin = MatData(1,10);
strainCunload = MatData(1,11);
strainCend = MatData(1,12);

% Force all parameters negative
if fpc > 0
    fpc = -fpc;
end
if epsc > 0
    epsc = -epsc;
end
if fpcu > 0
    fpcu = -fpcu;
end
if epscu > 0
    epscu = -epscu;
end

% Initial values
Ec0 = 2*fpc/epsc;
tangentC = Ec0;
unloadSlopeC = Ec0;
tangentT = Ec0;

switch action
   % ======================================================================
   case 'initialize'
       strainT = 0;
       stressT = 0;
       strainC = 0;
       stressC = 0;
       strainCmin = 0;
       strainCunload = 0;
       strainCend = 0;
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
       if stressT >= 0
           Result = strainT;
       else

       end
      
   % ======================================================================
   case 'getStress'
       if strainT > 0
           Result = 0;
       else
           % determine trial variables given the change in strain
           dStrain = strainT - strainC;
           unloadSlopeT = unloadSlopeC;
           stressTemp = stressC + unloadSlopeT*strainT - unloadSlopeT*strainC;
           if strainT < strainC     % Goes further into compression
               strainTmin = strainCmin;
               strainTend = strainCend;
               if stressTemp > stressT
                   stressT = stressTemp;
                   tengentT = unloadSlopeT;
               end
           elseif stressTemp <= 0
               stressT = stressTemp;
               tangentT = unloadSlopeT;
           else
               stressT = 0;
               tangentT = 0;
           end
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
MatData(1,4) = fpcu;
MatData(1,5) = epscu;
% trial variables
MatData(1,6) = stressT;
MatData(1,7) = strainT;
% state history variables
MatData(1,8) = stressC;
MatData(1,9) = strainC;
end
