function frames = sig2frames(signal, Nw, No)
% Convert a speech signal to frames using the window and overlap method
% Default window used is a Hamming window.
%
% INPUTS:
% signal: speech signal (a vector)
% Nw: window size in number of samples
% No: overlap size in number of samples
% 
% OUTPUTS:
% frames: Matrix of frames [Nw x Nf]. Each column is a frame of length Nw samples.
% There are Nf such frames. Nf is computed from signal, Nw, and No.
%
% 

signal = signal(:);
len = length(signal);
Nf  = floor( (len - No)/(Nw - No) );
frames = zeros(Nw, Nf);

win = @hamming;
for i = 1:Nf
    start_sample =  i*Nw*No;
    end_sample =    (i+1)*Nw*No+Nw*(1-No);
    frames(:, i) = signal(start_sample:end_sample);
end

end
