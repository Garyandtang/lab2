addpath('Bilateral')
addpath('BM3D')
y = im2double(imread('Lena512Gray.bmp'));  % y is in the interval [0,1]
sigma = 25;
n = (sigma/255)*randn(size(y));  % So the normalized noise standard deviation is sigma/255 
z = y + n;

figure(1)
imshow(z);
% peaksnr = psnr(z,y);
% Gaussian_sigma = [3 1];
% dx_bi = RUNBFILTER(z, Gaussian_sigma);		
% % Output – dx_bi: denoised image in the interval [0,1]
% % Input – z: noisy image in the interval [0,1]
% %         Gaussian_sigma: controls the shape of the Gaussian filters
% figure(2)
% imshow(dx_bi)
% peaksnr2 = psnr(dx_bi,y);
%With DM3D
% sigma = 10;
% dx_bm = BM3D(1,z,sigma);


%estimate the noise variance based on image 
y1d = z(:)*256;
sd = median(abs(dct(y1d) - mean(dct(y1d))))/0.6754;








% Output – dx_bm: denoised image in the interval [0,1]
% Input – z: noisy images in the interval [0,1]
%			  sigma: Noise standard deviation (the true one, not the normalized one)
% figure(3)
% imshow(dx_bm)
