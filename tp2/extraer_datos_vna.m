close all
clear

data_dir = 'data';
datos_vna = dir(fullfile(data_dir,'*.s1p'));

antenas = {'cilindrica' 'parche' 'biquad'};

for x = 1:length(datos_vna)
    S = sparameters(fullfile(datos_vna(x).folder,datos_vna(x).name));    
    gamma = rfparam(S,1,1);
    figure
    smithchart(gamma)
    saveas(gcf,fullfile('imagenes',[antenas{x} '_smith.png']))  
    
    Zo = S.Impedance;
    Z = Zo * (gamma + 1) ./ (1 - gamma);
    f = S.Frequencies./1e9;
    
    figure
    plot(f,real(Z))
    hold on
    plot(f,imag(Z))
    ylabel('Impedancia [Ohm]');
    xlabel('Frecuencia [GHz]');
    legend('Real','Imaginaria');
    ylim([-50 100]);
    saveas(gcf,fullfile('imagenes',[antenas{x} '_impedancia.png']))
    
    rho = abs(gamma);
    rho_dB = 10*log10(rho);
    
    figure
    plot(f,rho_dB)
    ylabel('rho [dB]');
    xlabel('Frecuencia [GHz]');
    saveas(gcf,fullfile('imagenes',[antenas{x} '_rho.png']))
    
    ROE = (1+rho)./(1-rho);
    figure
    plot(f,ROE)
    hold on
    plot(f,2*ones(size(f)),'-.r');
    ylabel('ROE');
    xlabel('Frecuencia [GHz]');
    legend('Antena','ROE=2');
    ylim([1 3]);

    saveas(gcf,fullfile('imagenes',[antenas{x} '_ROE.png']))
    
end