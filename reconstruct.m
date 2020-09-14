%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wright State University                                         
% Written By: Alec Petrack                        
% Modified: 9/14/2020
%
% Code Description: CS reconstruction function.
%
% Phi -- Measurement Basis
%
% Psi -- Representation Basis
%
% y -- Measurement Vector
%
% method -- Number Defines Reconstruction Algorithm To Use
% 0.)   L1 Dantzig Pd
% 1.)   L1 Decode Pd
% 2.)   L1 Eq Pd
% 3.)   L1 Qc Logbarrier
% 4.)   TV Dantzig Logbarrier
% 5.)   TV Eq Logbarrier
% 6.)   TV Qc Logbarrier
% 7.)   Bayesian Compressive Sensing
%* Note -- 4-6 only work when x*y is an integer square root.
%
% dims - Dimensions of Reconstructed Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [csImage, minImage, time] = reconstruct(Phi, Psi, y, method, dims)
%%% Compressed Sensing Libraries
addpath(['optimization' filesep 'bcs_ver' filesep 'BCS_demo'])             % Bayesian CS
addpath(['optimization' filesep 'bcs_ver' filesep 'MT_CS_demo'])           % Bayesian CS Multi
addpath(['optimization' filesep 'l1magic' filesep 'l1magic' filesep 'Measurements']) % l1-magic
addpath(['optimization' filesep 'l1magic' filesep 'l1magic' filesep 'Optimization']) % l1-magic

%%% Compute Theta
Theta = Phi*Psi;

%%% Minimum Energy Solution
s2 = pinv(Theta)*y;

tic
%%% Reconstruct Images
if method == 0          % L1 Method
    s1 = l1dantzig_pd(s2,Theta,[],y,5e-3,20);
    
elseif method==1
    s1 = l1decode_pd(s2,Theta,[],y,5e-3,20);
    
elseif method==2
    % minimize l1 with equality constraints (l1-magic library)
    s1 = l1eq_pd(s2,Theta,[],y,5e-3,20);
    
elseif method==3
    % minimize l1 with equality constraints (l1-magic library)
    s1 = l1qc_logbarrier(s2,Theta,[],y,5e-3,20);
    
elseif method==4
    % minimize l1 with equality constraints (l1-magic library)
    s1 = tvdantzig_logbarrier(s2,Theta,[],y, 5e-3, 1e-3, 5, 1e-8, 1500);
    
elseif method==5
    % minimize l1 with equality constraints (l1-magic library)
    s1 = tveq_logbarrier(s2,Theta,[],y,1e-3, 5, 1e-8, 200);
    
elseif method==6
    % minimize l1 with equality constraints (l1-magic library)
    s1 = tvqc_logbarrier(s2,Theta,[],y,1e-3, 5, 1e-8, 200);
    
elseif method==7    
    % fast-RVM
    sigma2 =  std(y)^2/1e6;
    eta = 1e-8;
    [weights,used,sigma2,errbars] = BCS_fast_rvm(Theta,y,sigma2,eta);
    s1 = zeros(size(Theta,2),1);
    s1(used) = weights;
    % err = zeros(totalMeasurements,1);
    % err(used) = errbars;
    
end
time = toc;
csImage = reshape(Psi*s1, dims);
minImage = reshape(Psi*s2, dims);
end