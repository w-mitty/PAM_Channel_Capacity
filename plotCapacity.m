function plotCapacity(SNR, capacity, draw_shannon)

    plot(SNR,capacity,'LineWidth',1);
    set(gca,'box','on');    
    grid on;
    hold on;
    xlabel('SNR (dB)');
    ylabel('bits per 2D');
    if nargin==2||draw_shannon
        plot(SNR,log2(1+10.^(0.1*SNR)),'LineWidth',1);
    end
    
end