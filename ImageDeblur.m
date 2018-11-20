f = im2double(imread('Lena512Gray.bmp'));  % f is in the interval [0,1]
h = [1 1 1 1 1 1 1; 1 1 1 2 1 1 1; 1 1 2 4 2 1 1; 1 2 4 8 4 2 1; ...
    1 1 2 4 2 1 1; 1 1 1 2 1 1 1; 1 1 1 1 1 1 1];
h = h/(sum(sum(h)));		% Assume the PSF is known
r = conv2(h,f);				% The blurring process is modelled by a 2-D convolution of the PSF and the image f
sigma = 3;
n = (sigma/255)*randn(size(r));  % So the normalized noise standard deviation is sigma/255 
g = r + n;

figure(4)
imshow(g);
% g_crop = imcrop(g, [3,3,511,511]);
% peaksnr = psnr(g_crop,f);
% %%% Deblur by inverse filtering
% %
N1 = size(g,1);
N2 = size(g,2);
G = fft2(g);				% fft2 performs the 2-D DFT
H = fft2(h,N1,N2);
% FH = G./H;
% fh = real(ifft2(FH));	% ifft2 performs the inverse 2-D DFT
% 								% fh has to be a real function
% figure(5)
% imshow(fh);
%%% Deblur by Wiener filter %%%
%
Pn = (abs(fft2(n,N1,N2)).^2)/(N1*N2);
Pnn = mean(Pn(:));					% Assume the noise psd is known
Pgg = (abs(fft2(g,N1,N2)).^2)/(N1*N2);
% The signal psd is approximated by subtracting Pnn from Pgg
% Pgg is approximated by its periodogram, since we have only one observation of g
Pff = max(Pgg-Pnn,0.000001); 	% To give a lower bound (greater than 0) for Pff to avoid data instability

%%% Deblur by regularized minimization %%%
%
lap = [0 -1 0; -1 4 -1; 0 -1 0];		% The Laplacian function
Lap = fft2(lap,N1,N2);									
%Get N(u,v);
N = fft2(n);
%Create an array for storing landa and C
stored_i_C = zeros(1000,2);
count = 1;

for i = 0.001:0.001:1
    FH = G.*conj(H)./((abs(H)).^2+i*((abs(Lap)).^2));	% Wiener filtering
  
    R = G - H.*FH;
    C = abs(std2(R)-std2(N));
    the_x = [i,C];
    stored_i_C(count,:) = the_x;
    count = count +1;
end

% sort the array to based on the value of C, find the optimized landa
[a, index] = sort(stored_i_C(:,2),'ascend');
list = stored_i_C(index, [1,2]);
i_optimized = list(1,1);

%use the optimized landa for denosing
FH = G.*conj(H)./((abs(H)).^2+ i_optimized*(abs(Lap)).^2);
fh = min(max(real(ifft2(FH)),0),1); 		% fh must be real and in the interval [0,1]
%draw the image
figure(6)
imshow(fh)
fh_crop = imcrop(fh, [1,1,511,511]);
peaksnr = psnr(fh_crop,f);



