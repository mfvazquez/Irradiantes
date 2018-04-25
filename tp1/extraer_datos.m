close all
clear

archivos = dir(fullfile('data','*.s1p'));

Zo = 50;


for x = 1:length(archivos)/2
    Scc = sparameters(fullfile(archivos(x*2-1).folder,archivos(x*2-1).name));
    s11cc = rfparam(Scc,1,1);
    figure
    smithchart(s11cc)
    saveas(gcf,fullfile('imagenes',[num2str(x) 'CC.png']))
    
    Sca = sparameters(fullfile(archivos(x*2).folder,archivos(x*2).name));
    s11ca = rfparam(Sca,1,1);
    figure
    smithchart(s11ca)
    saveas(gcf,fullfile('imagenes',[num2str(x) 'CA.png' ]))

    
    Zincc = Zo * (s11cc + 1) ./ (1-s11cc);
    Zinca = Zo * (s11ca + 1) ./ (1-s11ca);
    
    Zo_calculado = sqrt(abs(Zincc.*Zinca));
    
    figure
    plot(Scc.Frequencies/1e6, Zo_calculado); % paso la frecuencia a MHz
    legend(['media = ' num2str(mean(Zo_calculado)) ' Ohm'], 'Location','northwest');
    ylabel('Zo [Ohm]');
    xlabel('Frecuencia [MHz]');
    xlim([Scc.Frequencies(1) Scc.Frequencies(end)]/1e6)
    saveas(gcf,fullfile('imagenes',[num2str(x) 'Zo.png']))

end
