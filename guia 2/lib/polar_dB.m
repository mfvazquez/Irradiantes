%%  Esta función se utiliza para graficar diagramas de radiación polares en dB

%%  theta = Valores del ángulo tita (en radianes, entre 0 y 2*pi)
%%  gain = Ganancia (en veces)
%%  rmin = Valor de referencia mínimo en dB
%%  rmax = Valor de referencia máximo en dB
%%  circs = Círculos del diagrama de radiación (incluyendo el círculo externo)
%%  deg = Grados de separación en el diagrama de radiación (30, 45 o 90)

function diapol = polar_dB(theta,gain,rmin,rmax,circs,deg)
    
    font_size = 16;
    font_name = 'Times';
    deg_dia = [30 45 90];  % Grados posibles de separación del diagrama de radiación
    if all(deg ~= deg_dia)
        error('Los grados de separacin deben ser 30, 45 o 90.')
    end
    if circs > 5
        error('La cantidad de círculos del diagrama de radiación debe ser menor o igual a 5.')
    end
    tc = 'k';  % Color de los circulos y radios del diagrama de radiación (negro)
    hold on;
    % Convierte los valor de veces a dB, verificando de no realizar un logaritmo de 0
    for i = 1:length(gain)
        if gain(i) == 0  
            gain(i) = rmin;
        else
            gain(i) = 10*log10(gain(i));
        end
    end
    % Transforma los datos del diagrama de radiación de coordenadas
    % esféricas a coordenadas cartesianas para poder graficar
    for i = 1:length(gain)
        if gain(i) > rmin
            xx(i) = -(gain(i) - rmin)*cos(theta(i) + pi/2);
            yy(i) = (gain(i) - rmin)*sin(theta(i) + pi/2);
        else
            xx(i) = 0;
            yy(i) = 0;
        end
    end
    % Grafica los datos en el diagrama de radiación
    plot(xx,yy,'Color','r','LineWidth',2);
    % Define un círculo
    th = 0:pi/100:2*pi;
    xunit = cos(th);
    yunit = sin(th);
    % Dibuja los círculos del diagrama de radiación (incluyendo el
    % círculo externo), indicando el valor en dB de dichos círculos
    rinc = (rmax - rmin)/circs;
    cir = 0;
    for i = rmin:rinc:rmax
        is = i - rmin;
        if cir < circs
            style = ':';
            line_width = 1;
        else
            style = '-';
            line_width = 2;
        end
        plot(xunit*is,yunit*is,style,'color',tc,'linewidth',line_width);
        dbi_str = num2str(i,'%2.1f');
        dbi_str(length(dbi_str) - 1) = ',';
        text(0,is + rinc/20,['  ' dbi_str],'verticalalignment','bottom','FontSize',font_size,'FontName',font_name);
        cir = cir + 1;
    end
    % Dibuja los radios del diagrama de radiación
    th = (1:180/deg)*2*pi/(360/deg);
    cst = cos(th);
    snt = sin(th);
    cs = [-cst; cst];
    sn = [-snt; snt];
    plot((rmax - rmin)*cs,(rmax - rmin)*sn,':','color',tc,'linewidth',1);
    % Dibuja los marcadores de separación de grados en el círculo
    % exterior
    george = (rmax - rmin)/30;  % Longitud de los marcadores
    th2 = (0:36)*2*pi/72;
    cst2 = cos(th2);
    snt2 = sin(th2);
    cs2 = [(rmax - rmin - george)*cst2;(rmax - rmin)*cst2];
    sn2 = [(rmax - rmin - george)*snt2;(rmax - rmin)*snt2];
    plot(cs2,sn2,'-','color',tc,'linewidth',1);
    plot(-cs2,-sn2,'-','color',tc,'linewidth',1);
    % Introduce los grados de separación del diagrama de radiación sobre el
    % círculo exterior, sobre cada uno de los radios
    rt = 1.1*(rmax - rmin);
    th = (0:360/deg - 1)*2*pi/(360/deg);
    cst = -cos(th + pi/2);
    snt = sin(th + pi/2);
    deg_num = [0:deg:180 - deg 180:-deg:deg];
    for i = 1:max(size(th))
        text(rt*cst(i),rt*snt(i),int2str(deg_num(i)),'horizontalalignment','center','FontSize',font_size,'FontName',font_name);
    end
    % Configura los límites de los ejes; esto se hace para que el gráfico
    % quede en un factor de escala tal que no se superponga con el título
    axis((rmax - rmin)*[-1 1 -1.1 1.1]);
    axis('equal');
    axis('off');
    hold off;