clear;

% Parameters
N = 10^6;                    % Number of bits or symbols
rand('state', 100);           % Initializing the rand() function
randn('state', 200);          % Initializing the randn() function

% Transmitter
ip = rand(1, N) > 0.5;        % Generating 0,1 with equal probability
s = 2 * ip - 1;               % BPSK modulation: 0 -> -1, 1 -> 1

% Noise
n = 1/sqrt(2) * (randn(1, N) + 1j * randn(1, N));  % White Gaussian noise, 0dB variance

% SNR range
Eb_N0_dB = -3:10;             % Multiple Eb/N0 values

% Simulation
for ii = 1:length(Eb_N0_dB)
    % Noise addition
    y = s + 10^(-Eb_N0_dB(ii)/20) * n;              % Additive white Gaussian noise
    
    % Receiver - Hard decision decoding
    ipHat = real(y) > 0;
    
    % Counting the errors
    nErr(ii) = size(find(ip - ipHat), 2);
end

% Results
simBer = nErr / N;                                    % Simulated BER
theoryBer = 0.5 * erfc(sqrt(10.^(Eb_N0_dB/10)));      % Theoretical BER

% Plot
close all;
figure;
semilogy(Eb_N0_dB, theoryBer, 'b.-');
hold on;
semilogy(Eb_N0_dB, simBer, 'mx-');
axis([-3 10 10^-5 0.5]);
grid on;
legend('Theory', 'Simulation');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
title('Bit Error Probability Curve for BPSK Modulation');
