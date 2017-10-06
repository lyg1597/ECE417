function CC = cepstrum(signal, Ncc, Nw, No)
% signal: speech signal (a vector)
% Nw: window size in samples
% No: overlap size in samples
% Ncc:  Number of cepstral coefficients
% CC = matrix of cepstral coeffs of size [Ncc x Nf], where Nf = num frames

% NFFT must meet the following conditions:
% a) NFFT is a number that is nearest to and >= Nw. 
% b) NFFT must also be a power of 2 (e.g. 2^1, 2^2, 2^3, 2^4 etc) 
NFFT = N_pow2(NW);  
alpha = 0.97;

% Preemphasis filtering
signal = filter([1 -alpha], 1, signal);

% Convert signal to frames
frames = sig2frames(signal, Nw, No);
[~, Nf] = size(frames); % Nf = number of frames

% Compute real cepstrum from magnitude spectra = real part of inverse Fourier transform
% of the log magnitude spectrum
CC = ifft(log10(abs(fft(frames,NFFT,1))),NFFT,1) ; % [NFFT x Nf]

% Take only first Ncc coefficients since higher order coeffs are too small.
CC = CC(1:Ncc,:) ; % [Ncc x Nf]

end