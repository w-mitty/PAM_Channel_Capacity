clear;

%% set simulation parameters
M = 8;% modulation order
K = log2(M);% bits per 2D
conste.dim = 2;% constellation dimension
conste.labels = [0 1 3 2 6 7 5 4];% decimal labels
conste.symbols = exp(1j*2*pi*(0:M-1)/M);% symbols

type = 'b';% CM('c') or BICM('b')

R = 2/3;% code rate
rho = R*K;% information bits per 2D (or spectra efficiency)


%% calculate limit
snr_start = -30;
snr_end = 50;
snr_num = 100;
SNR = linspace(snr_start,snr_end,snr_num);
while(1) 
    
    capacity = getCapacity(conste,SNR,type);

    tmp = find(capacity>rho);
    g_index = tmp(1);
    l_index = tmp(1)-1;
    if(capacity(g_index)-capacity(l_index)<=1e-6)
        limit = SNR(g_index);
        break;
    end
    
    snr_start = SNR(l_index);
    snr_end = SNR(g_index);
    SNR = linspace(snr_start,snr_end,snr_num);
    
end

%% output
fprintf("The capacity limit is: \n");
fprintf("    SNR        %d\n", limit);
fprintf("    EsNo       %d\n", limit+10*log10(0.5*conste.dim));
fprintf("    EbNo       %d\n", limit+10*log10(0.5*conste.dim/rho));