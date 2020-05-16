clear;clc;
N = 16;
[x, w] = gaussHermite(N);

for M = [2 4 8 16]
    conste_norm = getConste(M);
    K = log2(M);
    No = 1;
    SNR = -10:0.1:30;
    SNR_Lin = 10.^(0.1*SNR);
    C = zeros(size(SNR));
    
    for SNR_cnt = 1:length(SNR)

        snr_lin = SNR_Lin(SNR_cnt);
        Es = snr_lin*0.5;
        conste = sqrt(Es)*conste_norm;

        sum1 = 0;
        for i = 1:M
            sum2 = 0;
            for n = 1:N
                sum3 = 0;
                for j = 1:M
                    sum3 = sum3+exp(-(conste(j)-conste(i)).^2+...
                            2*x(n)*(conste(j)-conste(i)));
                end
                sum2 = sum2+w(n)*log2(sum3);
            end
            sum1 = sum1+sum2;
        end
        C(SNR_cnt) = K-sum1/(sqrt(pi)*M);
    end
    plot(SNR,C,'LineWidth',1);
    grid on;
    hold on;
end
thy_capacity = 0.5*log2(1+SNR_Lin);
plot(SNR,thy_capacity,'LineWidth',1);
