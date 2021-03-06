function [x0,LB,UB] = uvsd_gen_pars(nBins,nConds,parNames)
% usage: 
%   x0 = uvsd_gen_pars(nBins,nConds,parNames)
%   [x0,LB,UB] = uvsd_gen_pars(nBins,nConds,parNames)
%
% UVSD_GEN_PARS creates default starting and bouding paramters for the UVSD
% model. The output is three vectors. One contains the starting values of 
% the parameters (x0), one contains the lower bounds of the parameters 
% (LB), and the last contains the upper bounds of the parameters (UB). The 
% LB and UB variables are used with dpsd_model_solver to constrain the 
% starting parameters (x0).
%
% Input:
%   nBins - This is the number of confidence bins in the scale used in
%   the experiment. This input creates a total of n-1 criterion points 
%   ranging between -1.5 and 1.5 using the following formula:
%       criterion_x0=[-1.5 ones(1,nBins-2)*(3/(nBins-2))];
%       criterion_LB=[-Inf zeros(1,nBins-2)];
%       criterion_UB=[Inf Inf inf(1,nBins-2)];
%
%   nConds - This corresponds to the number of experimental conditions
%   in the data that will be simultaneously fitted. For example, if there
%   is only one group of target items and one group of lure items, then
%   nConds should equal 1, If there are two classes of target and lure
%   items
%
%   parNames - This is a cell array of strings identifying the parameters 
%   to be estimated. To specify the parameters, enter the appropriate 
%   strings listed below into a cell array:
%
%   'Dprime' - This specifies the memory strength (d') parameter. If given,
%   x0 is set to .2, LB is set to 0, and UB is set to 1. If this input is
%   not given, x0, LB, and UB are set to 0 (i.e., the parameter is not
%   estimated).
%
%   'Vo' - This specifies the memory variance (Vo) parameter. If given,
%   x0 is set to 1.4, LB is set to 0, and UB is set to Inf. If this input 
%   is not given, x0, LB, and UB are set to 1 (i.e., the parameter is not
%   estimated).
%
%   Example: If you wanted to estimate d' and Vo, you would use the
%   following code:
%       parNames={'Dprime' 'Vo'};
%       [x0,LB,UB]=uvsd_gen_pars(nbins,nconds,parNames)
%
% Output:
%   The output of this function is a MxN row vector. The length of the
%   vector depends on the number of confidence bins used in the experiment.
%   The vector) output from this function correspond to:
%       [Dprime Vo criterion]
%
%   Note that the first criterion value in the vector is always -1.5. The
%   remaining values in the vector are the interval between successive
%   criterion points, as this is needed for parameter estimation reasons
%   (i.e., monotonically increasing criterion placements). Hence, the LB
%   for the successive values is 0 rather than -Inf.
%
% Author: Joshua D. Koen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The ROC Toolbox is the proprietary property of The Regents of the       
% University of California (The Regents.)                                
%
% Copyright © 2014 The Regents of the University of California, Davis
% campus. All Rights Reserved.   
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted by nonprofit, research institutions for
% research use only, provided that the following conditions are met:  
%
% 	Redistributions of source code must retain the above copyright 
% notice, this list of conditions and the following disclaimer.  
%
% 	Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.   
%
% 	The name of The Regents may not be used to endorse or promote 
% products derived from this software without specific prior written
% permission.   
%
% The end-user understands that the program was developed for research
% purposes and is advised not to rely exclusively on the program for any
% reason.  
%
% THE SOFTWARE PROVIDED IS ON AN "AS IS" BASIS, AND THE REGENTS HAVE NO
% OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
% MODIFICATIONS. THE REGENTS SPECIFICALLY DISCLAIM ANY EXPRESS OR IMPLIED
% WARRANTIES, INCLUDING BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
% IN NO EVENT SHALL THE REGENTS BE LIABLE TO ANY PARTY FOR DIRECT,
% INDIRECT, SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES,
% INCLUDING BUT NOT LIMITED TO  PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES, LOSS OF USE, DATA OR PROFITS, OR BUSINESS INTERRUPTION, 
% HOWEVER CAUSED AND UNDER ANY THEORY OF LIABILITY WHETHER IN CONTRACT,
% STRICT LIABILITY OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
% ANY WAY OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.             
%
% If you do not agree to these terms, do not download or use the software.
% This license may be modified only in a writing signed by authorized
% signatory of both parties.  
%
% For commercial license information please contact
% copyright@ucdavis.edu. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set values for memory strength (d') parameter
if ismember('Dprime',parNames)
    Dprime=1;
    lDprime=-Inf;
    uDprime=Inf;
else
    Dprime=0;
    lDprime=0;
    uDprime=0;
end

% Set values for old item variance (Vo) parameter
if ismember('Vo',parNames)
    Vo=1.4;
    lVo=1e-1000;
    uVo=Inf;
else
    Vo=1;
    lVo=1;
    uVo=1;
end

% Calculate criterion parameters
criterion=[-1.5 ones(1,nBins-2)*(3/(nBins-2))];
lcriterion=[-Inf zeros(1,nBins-2)];
ucriterion=[Inf inf(1,nBins-2)];

% Preallocate variables
x0=zeros(nConds,2+length(criterion));
LB=zeros(nConds,2+length(criterion));
UB=zeros(nConds,2+length(criterion));

% Create output vectors
for a=1:nConds
    x0(a,:)=[Dprime Vo criterion];
    LB(a,:)=[lDprime lVo lcriterion];
    UB(a,:)=[uDprime uVo ucriterion];
end

end