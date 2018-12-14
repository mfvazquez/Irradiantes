close all
clear

data_dir = 'data';
datos_vna = dir(fullfile(data_dir,'*.s1p'));

antenas = {datos_vna.name};

distancias = {'2 cm' '1,5 cm' '2,5 cm' '2,1 cm'};


for x = 1:length(datos_vna)
    S = sparameters(fullfile(datos_vna(x).folder,datos_vna(x).name));    
    gamma = rfparam(S,1,1);
    figure
    smithchart(gamma)
    saveas(gcf,fullfile('imagenes',[num2str(x) '_smith.png']))      
    
    Zo = S.Impedance;
    Z = Zo * (gamma + 1) ./ (1 - gamma);
    f = S.Frequencies./1e9;
    
    figure(2)    
    hold on
    subplot(2,1,1)
    plot(f,real(Z))
    grid
    if x == length(datos_vna)
        legend(distancias, 'location', 'northoutside', 'Orientation','horizontal');
    end
    ylim([0 200]);
    hold on
    subplot(2,1,2)
    plot(f,imag(Z))
    grid
    ylim([-200 150]);
    ylabel('Impedancia [Ohm]');
    xlabel('Frecuencia [GHz]');
    if x == length(datos_vna)
        saveas(gcf,fullfile('imagenes','impedancia.png'))
    end
    
    rho = abs(gamma);
    rho_dB = 10*log10(rho);
    
    figure(3)
    hold on
    grid
    plot(f,rho_dB)
    ylabel('rho [dB]');
    xlabel('Frecuencia [GHz]');
    if x == length(datos_vna)
        legend(distancias, 'location', 'best')
        saveas(gcf,fullfile('imagenes','rho.png'))
    end
    
    ROE = (1+rho)./(1-rho);
    figure(4)
    grid
    hold on
    plot(f,ROE)
    ylabel('ROE');
    xlabel('Frecuencia [GHz]');
    ylim([1 3]);
    if x == length(datos_vna)
        legend(distancias, 'location', 'best')
        saveas(gcf,fullfile('imagenes','ROE.png'))
    end

end