%% LINEA 1

linea.largo = 0.96;

linea.mediciones(1).f = 1e3;
linea.mediciones(1).L = 160e-9;
linea.mediciones(1).C = 160e-12;

linea.mediciones(2).f = 10e3;
linea.mediciones(2).L = 130e-9;
linea.mediciones(2).C = 112e-12;

linea.mediciones(3).f = 40e3;
linea.mediciones(3).L = 110e-9;
linea.mediciones(3).C = 99e-12;

linea.mediciones(4).f = 100e3;
linea.mediciones(4).L = 90e-9;
linea.mediciones(4).C = 97e-12;

lineas(1) = linea;

%% LINEA 2

linea.largo = 2.05;

linea.mediciones(1).f = 1e3;
linea.mediciones(1).L = 560e-9;
linea.mediciones(1).C = 240e-12;

linea.mediciones(2).f = 10e3;
linea.mediciones(2).L = 540e-9;
linea.mediciones(2).C = 195e-12;

linea.mediciones(3).f = 40e3;
linea.mediciones(3).L = 520e-9;
linea.mediciones(3).C = 183e-12;

linea.mediciones(4).f = 100e3;
linea.mediciones(4).L = 510e-9;
linea.mediciones(4).C = 155e-12;

lineas(2) = linea;

%% LINEA 3

linea.largo = 2.075;

linea.mediciones(1).f = 1e3;
linea.mediciones(1).L = 580e-9;
linea.mediciones(1).C = 240e-12;

linea.mediciones(2).f = 10e3;
linea.mediciones(2).L = 550e-9;
linea.mediciones(2).C = 196e-12;

linea.mediciones(3).f = 40e3;
linea.mediciones(3).L = 540e-9;
linea.mediciones(3).C = 185e-12;

linea.mediciones(4).f = 100e3;
linea.mediciones(4).L = 520e-9;
linea.mediciones(4).C = 183e-12;

lineas(3) = linea;

%% Divido los valores medidos por el largo

for x = 1:length(lineas)
    linea = lineas(x);
    for y = 1:length(linea.mediciones)
                
        linea.mediciones(y).L = linea.mediciones(y).L / linea.largo;
        linea.mediciones(y).C = linea.mediciones(y).C / linea.largo;
        disp(['Linea ' num2str(x) ' f = ' num2str(linea.mediciones(y).f)]);
        fprintf('L = %f\n',linea.mediciones(y).L*1e9);
        fprintf('C = %f\n',linea.mediciones(y).C*1e12);
    end
    lineas(x) = linea;
end

%% Calculo Zo, V y Er
c = 3e8; % velocidad de la luz

for x = 1:length(lineas)
    linea = lineas(x);
    for y = 1:length(linea.mediciones)
        Zo = sqrt(linea.mediciones(y).L/linea.mediciones(y).C);                
        V = 1/sqrt(linea.mediciones(y).L*linea.mediciones(y).C);
        Er = (c/V)^2;
        
        linea.mediciones(y).Zo = Zo;
        linea.mediciones(y).V = V;
        linea.mediciones(y).Er = Er;
        
    end
    lineas(x) = linea;
end

%% Imprimo los datos en una tabla de latex

for x = 1:length(lineas)
    linea = lineas(x);

    % Zo
    fprintf('\\multirow{3}{*}{$\\ell_1$} & $Z_o$ ')
    for y = 1:length(linea.mediciones) 
        fprintf('& $\\unit[%.f]{\\Omega}$ ',linea.mediciones(y).Zo)        
    end
    fprintf('\\\\ \\cline{2-6}\n');
    
    % v
    fprintf('& $v$ ')
    for y = 1:length(linea.mediciones) 
        fprintf('& $\\unit[%.f \\, 10^6]{m/s}$ ',linea.mediciones(y).V/1e6)        
    end
    fprintf('\\\\ \\cline{2-6}\n');
    
    % Er
    fprintf('& $\\epsilon_r$ ')
    for y = 1:length(linea.mediciones) 
        fprintf('& $%.2f$ ',linea.mediciones(y).Er)        
    end
    fprintf('\\\\ \\hline\n');
    
end