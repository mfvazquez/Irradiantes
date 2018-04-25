close all
clear

archivos = dir(fullfile('data','*.s2p'));

f = [1e9 1.5e9 2e9 2.5e9 3e9];
mediciones = [ [3.3 5 3 3.4 2];[4.3 6 4.5 5 3.9];[4.3 5.4 4.3 4.7 3.9]];
l = [0.96 2.05 2.075];

f_fabricante =  {[100e6 400e6 1e9] [10e6 100e6 1e9 5e9] [10e6 100e6 1e9 5e9]};
datos_fabricante = {[6.89 15.75 26.25] [4.59 16.08 65.62 196.85] [4.59 16.08 65.62 196.85]};

for x = 1:length(archivos) 
    S = sparameters(fullfile(archivos(x).folder,archivos(x).name));
    S21 = rfparam(S,2,1);
    
    atenuacion = 10*log10(1./abs(S21).^2) *100/l(x);
    
    figure
    semilogx(S.Frequencies/1e9, atenuacion);
    hold on
    semilogx(f/1e9,mediciones(x,:)*100/l(x), 'ro')
    hold on
    semilogx(f_fabricante{x}/1e9,datos_fabricante{x}, 'go');
    grid
    xlim([100e6 5e9]/1e9)
    ylabel('atenuacion [dB/100m]');
    xlabel('Frecuencia [GHz]');
    legend('VNA','analizador de espectros', 'datos fabricante', 'Location','northwest')
    saveas(gcf,fullfile('imagenes',[num2str(x) 'atenuacion.png']))

end

for x = 1:3
    mediciones(x,:)*100/l(x)
end