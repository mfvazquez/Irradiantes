clear
close all

addpath('lib');

%%  DIPOLO 

L=1;
a=0.001;
c=3e8;
L_lambda = 0.01:1e-4:1;

sigma=5.8e7;
mu=1.256637e-6;

% x es el valor de l_lambda
F = @(theta,x) (( (cos(pi.*x.*cos(theta))-cos(pi.*x)) ./ sin(theta)).^2);

%% Resistencia de radiacion

for x = 1:length(L_lambda)
    Rrad_int = @(theta) (60* F(theta, L_lambda(x)) .* sin(theta));
    Rrad(x) = integral(Rrad_int, 0, pi);        
end

figure
plot(L_lambda,Rrad)
ylabel('Rrad [Ohms]');
xlabel('L/lambda');
grid
title('Resistencia de radiacion')
saveas(gcf,fullfile('imagenes','dipolo_rrad.png'))


%% Resistencia de perdidas

Rperd = sqrt(L)/(2*pi*a) .* sqrt((pi*c*mu)/(sigma)) .* sqrt(L_lambda)...
    .* (1 - sinc(2*L_lambda));

figure
plot(L_lambda,Rperd)
ylabel('Rrad [Ohms]');
xlabel('L/lambda');
grid
title('Resistencia de perdidas')

saveas(gcf,fullfile('imagenes','dipolo_rperd.png'))

%% Rendimiento

rendimiento = Rrad ./ (Rrad+Rperd);
figure
plot(L_lambda,rendimiento)
ylabel('rendimiento');
xlabel('L/lambda');
grid
title('Rendimiento')
ylim([(min(rendimiento) - 0.02) (max(rendimiento)+0.02)]);
saveas(gcf,fullfile('imagenes','dipolo_rendimiento.png'))


%% Directividad

for x = 1:length(L_lambda)
    
    maximo = max(F(0:1e-3:pi,L_lambda(x)));
    divisor = @(theta) (F(theta, L_lambda(x)) .* sin(theta));
    divisor = integral(divisor,0,pi);
    D(x) = 2 * maximo ./ divisor;
end

figure
plot(L_lambda,D)
ylabel('D [veces]');
xlabel('L/lambda');
grid
title('Directividad')
saveas(gcf,fullfile('imagenes','dipolo_directividad.png'))

D_dbi = 10.*log10(D);

figure
plot(L_lambda,D_dbi)
ylabel('D [dBi]');
xlabel('L/lambda');
grid
title('Directividad')
saveas(gcf,fullfile('imagenes','dipolo_directividad_dbi.png'))

%% Ganancia

ganancia = rendimiento .* D;

figure
plot(L_lambda,ganancia)
ylabel('Ganancia [veces]');
xlabel('L/lambda');
grid
title('Ganancia')
saveas(gcf,fullfile('imagenes','dipolo_ganancia.png'))

ganancia_dbi = 10.*log10(ganancia);

figure
plot(L_lambda,10.*log10(ganancia))
ylabel('Ganancia [dBi]');
xlabel('L/lambda');
grid
title('Ganancia')
saveas(gcf,fullfile('imagenes','dipolo_ganancia_dbi.png'))

%% Diagrama de radiacion

L_lambda_radiacion = [0.1 0.5 1 1.25 1.5];
circs=3;
deg=45;

for x = L_lambda_radiacion

    
    Rrad_int = @(theta) (60* F(theta, x) .* sin(theta));
    Rrad_radiacion = integral(Rrad_int, 0, pi);    
    Rperd_radiacion = sqrt(L)/(2*pi*a) .* sqrt((pi*c*mu)/(sigma))...
        .* sqrt(x) .* (1 - sinc(2*x));
    rendimiento_radiacion = Rrad_radiacion /...
        (Rrad_radiacion+Rperd_radiacion);
    
    maximo = max(F(0:1e-3:pi,x));
    divisor = @(theta) (F(theta, x) .* sin(theta));
    divisor = integral(divisor,0,pi);
    D_radiacion = 2 * maximo ./ divisor;
    
    ganancia_radiacion = @(theta) rendimiento_radiacion *...
        D_radiacion * F(theta,x);
    
    theta = 0:1e-3:2*pi;
    gain_vect = ganancia_radiacion(theta);
    gain_vect_dbi = 10.*log10(gain_vect);
    figure
    polar_dB(theta, gain_vect, -30, max(gain_vect_dbi), circs, deg)
    saveas(gcf,fullfile('imagenes',...
        ['dipolo_radiacion' num2str(100*x) '.png']))

end

%% Corriente

lambda = L ./ [0.01 0.1 0.5 1];
Im = 1;
beta = 2*pi./lambda;

n = 1;
for b = beta
    I = @(z) ((z < 0) .*Im .* sin(b.*(L/2 + z))) + ((z >= 0)...
        .*Im .* sin(b.*(L/2 - z)));
    z = -0.5:1e-6:0.5;
    
    figure
    plot(z,I(z))
    ylabel('Corriente [A]');
    xlabel('z [m]');
    grid
    title('Distribucion de corriente')
    saveas(gcf,fullfile('imagenes',['dipolo_corriente_' num2str(n) '.png']))
    n = n + 1;
end

dipolo_hertz = mean(find(L_lambda <= 1/100));
dipolo_corto = mean(find(L_lambda > 1/100 & L_lambda < 1/10));
dipolo_media_onda = mean(find(L_lambda > 1/10 & L_lambda < 1/2));

disp(['R_{rad} [$\Omega$] & ' num2str(Rrad(dipolo_hertz)) ' & ' num2str(Rrad(dipolo_corto)) ' & ' num2str(Rrad(dipolo_media_onda)) '\\ \hline'])
disp(['R_{perd} [$\Omega$] & ' num2str(Rperd(dipolo_hertz)) ' & ' num2str(Rperd(dipolo_corto)) ' & ' num2str(Rperd(dipolo_media_onda)) '\\ \hline'])
disp(['rendimiento & ' num2str(rendimiento(dipolo_hertz)) ' & ' num2str(rendimiento(dipolo_corto)) ' & ' num2str(rendimiento(dipolo_media_onda)) '\\ \hline'])
disp(['directividad & ' num2str(D(dipolo_hertz)) ' & ' num2str(D(dipolo_corto)) ' & ' num2str(D(dipolo_media_onda)) '\\ \hline'])
disp(['directividad [dBi] & ' num2str(D_dbi(dipolo_hertz)) ' & ' num2str(D_dbi(dipolo_corto)) ' & ' num2str(D_dbi(dipolo_media_onda)) '\\ \hline'])
disp(['ganancia & ' num2str(ganancia(dipolo_hertz)) ' & ' num2str(ganancia(dipolo_corto)) ' & ' num2str(ganancia(dipolo_media_onda)) '\\ \hline'])
disp(['ganancia [dBi] & ' num2str(ganancia_dbi(dipolo_hertz)) ' & ' num2str(ganancia_dbi(dipolo_corto)) ' & ' num2str(ganancia_dbi(dipolo_media_onda)) '\\ \hline'])


%%  MONOPOLO 

%% Resistencia de radiacion

Rrad_monopolo = Rrad/2;

figure
plot(L_lambda,Rrad_monopolo)
ylabel('Rrad [Ohms]');
xlabel('L/lambda');
grid
title('Resistencia de radiacion')
saveas(gcf,fullfile('imagenes','monopolo_rrad.png'))

%% Resistencia de perdidas

Rperd_monopolo = Rperd/2;

figure
plot(L_lambda,Rperd_monopolo)
ylabel('Rrad [Ohms]');
xlabel('L/lambda');
grid
title('Resistencia de perdidas')

saveas(gcf,fullfile('imagenes','monopolo_rperd.png'))

%% Rendimiento

rendimiento_monopolo = Rrad_monopolo ./ (Rrad_monopolo+Rperd_monopolo);
figure
plot(L_lambda,rendimiento_monopolo)
ylabel('rendimiento');
xlabel('L/lambda');
grid
title('Rendimiento')
ylim([(min(rendimiento) - 0.02) (max(rendimiento)+0.02)]);
saveas(gcf,fullfile('imagenes','monopolo_rendimiento.png'))

%% Directividad

D_monopolo = D*2;

figure
plot(L_lambda,D_monopolo)
ylabel('D [veces]');
xlabel('L/lambda');
grid
title('Directividad')
saveas(gcf,fullfile('imagenes','monopolo_directividad.png'))

figure
plot(L_lambda,10*log10(D_monopolo))
ylabel('D [dBi]');
xlabel('L/lambda');
grid
title('Directividad')
saveas(gcf,fullfile('imagenes','monopolo_directividad_dbi.png'))

%% Ganancia

ganancia_monopolo = rendimiento_monopolo .* D_monopolo;

figure
plot(L_lambda,ganancia_monopolo)
ylabel('Ganancia [veces]');
xlabel('L/lambda');
grid
title('Ganancia')
saveas(gcf,fullfile('imagenes','monopolo_ganancia.png'))

figure
plot(L_lambda,10.*log10(ganancia_monopolo))
ylabel('Ganancia [dBi]');
xlabel('L/lambda');
grid
title('Ganancia')
saveas(gcf,fullfile('imagenes','monopolo_ganancia_dbi.png'))

%% Diagrama de radiacion


L_lambda_radiacion = [0.1 0.5 1 1.25 1.5];
circs=3;
deg=45;

for x = L_lambda_radiacion

    
    Rrad_int = @(theta) (60* F(theta, x) .* sin(theta));
    Rrad_radiacion = integral(Rrad_int, 0, pi);    
    Rperd_radiacion = sqrt((L)/(2*pi*a)) .* sqrt((pi*c*mu)/(sigma))...
        .* sqrt(x) .* (1 - sinc(2*x));
    rendimiento_radiacion = Rrad_radiacion /...
        (Rrad_radiacion+Rperd_radiacion);
    
    maximo = max(F(0:1e-3:pi,x));
    divisor = @(theta) (F(theta, x) .* sin(theta));
    divisor = integral(divisor,0,pi);
    D_radiacion = 2 * maximo ./ divisor;
    D_radiacion = D_radiacion * 2;
    
    ganancia_radiacion = @(theta) rendimiento_radiacion * ...
        D_radiacion * F(theta,x);
    
    theta = -pi/2:1e-3:pi/2;
    gain_vect = ganancia_radiacion(theta);
    gain_vect_dbi = 10.*log10(gain_vect);
    figure
    polar_dB(theta, gain_vect, -30, max(gain_vect_dbi), circs, deg)
    saveas(gcf,fullfile('imagenes',['monopolo_radiacion' num2str(100*x)...
        '.png']))

end