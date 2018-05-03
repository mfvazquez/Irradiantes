close all
clear

addpath('lib');

data_dir = 'data';
archivos = dir(fullfile(data_dir,'*.TRC'));


antena = 'cilindrica';

for x = 1:length(archivos)

    M = importdata(fullfile(archivos(x).folder,archivos(x).name),',',216);
    datos = M.data(:,1);

    mitad = round(length(datos)/2);

    [valor_inicio, inicio] = max(datos(1:mitad));
    [valor_fin, fin] = max(datos(mitad+1:end));
    datos = datos(inicio:mitad+fin);

    if datos(1) ~= valor_inicio
       disp('valor_inicio distinto al maximo inicial!!');
    end

    if datos(end) ~= valor_fin
       disp('valor_fin distinto al maximo inicial!!');
    end

    datos = datos - max(datos); 

    %% DIAGRAMA EN POLARES
    
    division = 2*pi/length(datos);
    theta = 0:division:2*pi - division;
    gain = 10.^(datos./10);    
    rmin = min(datos);
    rmax = max(datos);
    circs=3;
    deg=45;
    
    figure
    polar_dB(theta,gain,rmin,rmax,circs,deg)
    saveas(gcf,fullfile('imagenes', [num2str(x) 'polar.png']))

    
    %% ANCHO DEL HAZ
    
    ancho_haz = hpbw(gain,theta);
    disp(['Ancho del haz = ' num2str(ancho_haz)]);
    
    mayor_media = sum(gain >= 0.5) - 1; % Cuenta todos los elementos cuya ganancia es mayor o igual a 0.5
    ancho_haz = mayor_media * division * 360 / (2*pi);
    disp(['Ancho del haz = ' num2str(ancho_haz)]);

end