function capacity = getCapacity(conste, SNR, type)
    
% conste: 'struct'; 'symbols', 'labels', 'dim'.
% SNR: signal to noise ratio
% type: Coded Modulation('c') or Bit-interleaved Coded Modulation('b').

    % Gauss-Hermite approximation
    N = 16;
    [x, w] = gaussHermite(N);
    xx = x+1j*x.';
    ww = w.*w.';

    M = length(conste.symbols);% modulation order
    K = log2(M);% coded bits per channel symbol
    % constellation points with unit average symbol energy
    symbols_norm = sqrt(M)*conste.symbols./...
        norm(conste.symbols);
    labels = conste.labels;% decimal labels of constellation points
    bin_labels = dec2bin(labels, K)-'0';% labels in binary form

    No = 1; % for derivation simplicity
    SNR_lin = 10.^(0.1*SNR);% logarithmic to linear
    capacity = zeros(size(SNR));
    
    if nargin==2||type=='c'% default case is CM
        for SNR_cnt = 1:length(SNR)

            snr_lin = SNR_lin(SNR_cnt);
            Es = snr_lin*No*0.5*conste.dim;
            symbols = sqrt(Es)*symbols_norm;
    
            sum1 = 0;
            for i = 1:M
                sum2 = 0;
                for j = 1:M
                    sum2 = sum2+exp(abs(xx).^2-abs(xx+symbols(i)-symbols(j)).^2);
                end
                sum2 = ww.*log2(sum2);
                sum1 = sum1+sum(sum(sum2));
            end
            capacity(SNR_cnt) = K-sum1/(pi*M);
        end
    else
        for SNR_cnt = 1:length(SNR)

            snr_lin = SNR_lin(SNR_cnt);
            % distinguish 1-D and 2-D constellations
            Es = snr_lin*No*0.5*conste.dim;
            symbols = sqrt(Es)*symbols_norm;

            total_sum = 0;
            for k = 1:K

                index_0 = bin_labels(:, k)==0;
                index_1 = bin_labels(:, k)==1;
                subset_0 = reshape(symbols(index_0),1,1,M/2);
                subset_1 = reshape(symbols(index_1),1,1,M/2);
                sum0 = 0;
                sum1 = 0;

                for cnt = 1:length(subset_0)

                    p0 = sum(exp(-abs(xx+subset_0(cnt)-subset_0).^2), 3);
                    p1 = sum(exp(-abs(xx+subset_0(cnt)-subset_1).^2), 3);
                    p = p0+p1;
                    sum0 = sum0+ww.*log2(p./p0);

                    p0_ = sum(exp(-abs(xx+subset_1(cnt)-subset_0).^2), 3);
                    p1_ = sum(exp(-abs(xx+subset_1(cnt)-subset_1).^2), 3);
                    p_ = p0_+p1_;
                    sum1 = sum1+ww.*log2(p_./p1_);

                end
                tmp = sum0+sum1;
                total_sum = total_sum+sum(tmp(:))/(M*pi);

            end
            capacity(SNR_cnt) = K-total_sum;
        end
    end
end
