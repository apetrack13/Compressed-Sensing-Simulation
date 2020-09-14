%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wright State University                                          BMIL Lab
% Written By: Alec Petrack                        Professor: Dr. Ulas Sunar
% Modified: 9/14/2020
%
% Code Description: This code simulates a single pixel camera collecting
% measurements of a grayscale image then reconstructs using CS.
%
% image - Grayscale Image to Use For Demonstration
%
% method (optional) -- Number Defines Reconstruction Algorithm To Use
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
% Phi (optional) -- Measurement Basis Used to Sample Image
% 0.) Bernoulli (Default)
% 1.) Hadamard
%
% Psi (optional) -- Representation basis.
% 0.) DCT (Default)
% 1.) Hadamard
% 2.) DB-8 Wavelet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [csImage, minImage, time] = spcSimulation(image, ratio, method, phi, psi)
% image, size, method, measureBasis, representationBasis, ratio, sparsity
if size(image,3) > 1
   disp('Image must be grayscale (only 1 bit plane).') 
   csImage = [];
   time = [];
   return
end
if ~exist('ratio', 'var')
    ratio = 0.2;
end
if ~exist('method', 'var')
    method = 7;
end
if ~exist('phi', 'var')
    phi = 0;
end
if ~exist('psi', 'var')
    psi = 0;
end

%%% Generate Measurement Basis
Phi = generatePhi(phi, size(image), floor(length(image(:))*ratio));

%%% Do Compressive Measurements
y = doCompressiveMeasurements(image, Phi);

%%% Generate Representation Basis
Psi = generatePsi(psi, length(image(:)));

%%% Reconstruct Image
[csImage, minImage, time] = reconstruct(Phi, Psi, y, method, size(image));
return

%%% Get Measurement Matrices
function Phi = generatePhi(phi, sze, numMeasurements)
if phi == 0 % Bernoulli (80% Sparse)
    Phi = rand(sze(1)^2);
    Phi(Phi < 0.8) = 0;
    Phi(Phi >= 0.8) = 1;
elseif phi == 1 % Hadamard
    Phi = ifwht(eye(sze(1)^2), sze(1)^2, 'dyadic');
end
Phi = Phi(1 : numMeasurements, :); 
return

%%% Get Measurement Vector
function y = doCompressiveMeasurements(image, Phi)
%y = zeros(size(Phi,2),1);
y = Phi * image(:);
return

%%% Generate Representation Basis
function Psi = generatePsi(psi, sze)
if psi == 0 % DCT matrix
    Psi = dctmtx(sze);
elseif psi == 1
    Psi = ifwht(eye(sze), sze, 'dyadic')';
elseif psi == 2
    [Psi,~,~,longs] = wmpdictionary(sze, 'lstcpt', {'db8'});
end
return
