clear;

%% set simulation parameters
M = 16;% modulation order
conste.dim = 2;% constellation dimension
% conste.symbols = qammod(0:M-1, M,'UnitAveragePower', true);% symbols
% conste.labels = 0:M-1;% decimal labels
Gray=[0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10]';
conste.labels = 0:M-1;% decimal labels
conste.symbols = qammod(conste.labels, M, conste.labels, 'UnitAveragePower', true);% symbols

SNR = -10:30;% range of signal to noise ratio(logarithm)

type = 'b';% CM('c') or BICM('b')

%% calculate capacity
capacity = getCapacity(conste, SNR, type);

%% plot
plotCapacity(SNR,capacity,0);