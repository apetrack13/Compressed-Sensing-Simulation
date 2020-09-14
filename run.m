%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wright State University                                          BMIL Lab
% Written By: Alec Petrack                        Professor: Dr. Ulas Sunar
% Modified: 9/14/2020
%
% Code Description: Use this code to run either an SPC simulation or
% reconstruct experiment data.
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
% phi (optional) -- Measurement Basis Used to Sample Image
% 0.) Bernoulli (Default)
% 1.) Hadamard
%
% psi (optional) -- Representation basis.
% 0.) DCT (Default)
% 1.) Hadamard
% 2.) DB-8 Wavelet
%
% ratio - Compression ratio.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clc;

%%% SIMULATION EXAMPLE

%%% Settings
method = 2;         % use fast-RVM to reconstruct
phi = 0;            % bernoulli measurement matrices
psi = 0;            % hadamard basis
ratio = .4;         % compression ratio (use 80% of samples)

%%% Load Test Image for Simulation
%image = phantom('Modified Shepp-Logan', 128);

image = imread('lena_std.tif');
image = rgb2gray(image);
image = imresize(image, [128 128]);
image = double(image);


%%% Reconstruct Simulated Data
[csImage,minImage,time] = spcSimulation(image, ratio, method, phi, psi);

%%% Show Results
figure('name', 'Reconstructed Images')
subplot(1,2,1)
imagesc(csImage)
title('CS Solution')
subplot(1,2,2)
imagesc(minImage)
title('Minimum Energy Solution')
fprintf('It took %4.2d seconds to reconstruct the image.', time)


