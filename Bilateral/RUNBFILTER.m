% RUNBFILTER Illustrates the use of BFILTER2.
%    This demo shows typical usage for the bilateral 
%    filter implemented by BFILTER2. 
%
% Douglas R. Lanman, Brown University, September 2006.
% dlanman@brown.edu, http://mesh.brown.edu/dlanman
% Load test images.
% Note: Must be double precision in the interval [0,1].
function y_est = RUNBFILTER(img1,sigma)

% img1 is the noisy image with double precision in the interval [0,1]
% y_est is the denoised image with double precision in the interval [0,1]

img1(img1<0) = 0; img1(img1>1) = 1;
% Set bilateral filter parameters.
w     = 5;       % bilateral filter half-width
% sigma = [3 0.1]; % bilateral filter standard deviations
% Apply bilateral filter to the image.
y_est = bfilter2(img1,w,sigma);


