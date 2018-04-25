% Esta función es utilizada para hallar el ancho de haz principal a
% potencia media (HPBW)

%%  gain = Ganancia (en veces)
%%  theta = Valores del ángulo tita (en radianes, entre 0 y 2*pi)

function y = hpbw(gain,theta)
    
    gain_hpbw = 0.5;  % - 3 dB a potencia media
    hpbw_ctrl = 'n';  % Inicialmente, no se ha determinado el HPBW
    [gain_max,ind] = max(gain);  % Halla el valor y el índice del máximo
    gain = gain/max(gain);  % Normaliza la ganancia
    while hpbw_ctrl == 'n'
        ind = ind + 1;
        if ind <= length(gain)
            err_act = gain(ind) - gain_hpbw;
            if err_act < 0
                err_exc = abs(gain(ind) - gain_hpbw);  % Error por exceso
                err_def = abs(gain(ind - 1) - gain_hpbw);  % Error por defecto
                if err_exc >= err_def
                    theta_act = theta(ind - 1);
                else
                    theta_act = theta(ind);
                end
                hpbw_ctrl = 'y';
            end 
        else
            theta_act = theta(ind - 1);
            hpbw_ctrl = 'y';
        end
    end    
    y = 2*theta_act*180/pi;