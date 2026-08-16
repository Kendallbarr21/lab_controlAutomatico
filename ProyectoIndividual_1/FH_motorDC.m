clc;
clear;
close all;

% =========================================================
%  SIMULACION PARAMETRICA PARA UN MOTOR DC
%  G(s) = KM / (tau*s + 1)
% ==========================================================

%% 1. INGRESO DE PARAMETROS

fprintf('=============================================\n');
fprintf('     SIMULACION PARAMETRICA MOTOR DC\n');
fprintf('=============================================\n\n');

fprintf('Ingrese los parametros del motor:\n\n');

%Caracterisiticas Mecanicas
Kt = input('Kt [N*m/A]: '); %Constante por motor
Kb = input('Kb [V*s/rad]: '); %Constante Fuerza Electromotriz
b  = input('b [N*m*s/rad]: '); %Coeficiente de Friccion
J  = input('J [kg*m^2]: '); %Inercia del rotor(y carga)

%Caracterisiticas Electricas
Ra = input('Ra [ohm]: '); %Resistencia de Armadura

%% 2. VALIDAR PARAMETROS

if Kt <= 0
    error('Kt debe ser mayor que cero.');
end

if Ra <= 0
    error('Ra debe ser mayor que cero.');
end

if b <= 0
    error('b debe ser mayor que cero.');
end

if Kb <= 0
    error('Kb debe ser mayor que cero.');
end

if J <= 0
    error('J debe ser mayor que cero.');
end

fprintf('\nTodos los parametros son validos.\n');

%% 3. CALCULO DE Constante De Proporcionalidad (Km) y Constante de tiempo (Tau)  

Km = Kt / (Ra*b + Kt*Kb);

Tau = (Ra*J) / (Ra*b + Kt*Kb);

%% 4. MOSTRAR RESULTADOS

fprintf('\n=============================================\n');
fprintf('             RESULTADOS\n');
fprintf('=============================================\n');

fprintf('Km  = %.6f\n', Km);
fprintf('Tau = %.6f s\n', Tau);

fprintf('\nFuncion de transferencia:\n');

fprintf('             %.6f\n', Km);
fprintf('G(s) = -------------------------\n');
fprintf('        %.6f s + 1\n', Tau);

%% 5. SIMULACION DE LA RESPUESTA AL ESCALON

% Tiempo de simulacion: hasta 5 tau
t_final = 5*Tau;

% Vector de tiempo
t = linspace(0, t_final, 1000);

% Respuesta al escalon unitario
y = Km * (1 - exp(-t/Tau));

%% 6. PARAMETROS CARACTERISTICOS

% Valor final esperado
y_final = Km;

% Respuesta en t = tau
y_Tau = Km * (1 - exp(-1));

% Respuesta en t = 5 tau
y_5Tau = Km * (1 - exp(-5));

% Error de estado estacionario en t = 5 tau
error_ss = abs(y_final - y_5Tau);

% Error porcentual
error_ss_percent = (error_ss / y_final) * 100;

% Tiempo de asentamiento al 2%
t_settling = -Tau * log(0.02);

%% 7. MOSTRAR VALORES

fprintf('\n=============================================\n');
fprintf('       PARAMETROS DE LA RESPUESTA\n');
fprintf('=============================================\n');

fprintf('Valor final esperado: %.6f\n', y_final);

fprintf('Respuesta en t = tau: %.6f\n', y_Tau);

fprintf('Respuesta en t = 5tau: %.6f\n', y_5Tau);

fprintf('Error de estado estacionario: %.6f\n', error_ss);

fprintf('Error de estado estacionario: %.4f %%\n', ...
        error_ss_percent);

fprintf('Tiempo de asentamiento (2%%): %.6f s\n', ...
        t_settling);

%% 8. GRAFICA

figure;

plot(t, y, 'LineWidth', 2);
grid on;
hold on;

% Valor final esperado
plot([0 t_final], [y_final y_final], '--');

% Punto en tau
plot(Tau, y_Tau, 'o', 'MarkerSize', 8, 'LineWidth', 2);

% Punto en 5tau
plot(5*Tau, y_5Tau, 'o', 'MarkerSize', 8, 'LineWidth', 2);

% Tiempo de asentamiento
plot(t_settling, ...
     Km*(1-exp(-t_settling/Tau)), ...
     's', 'MarkerSize', 8, 'LineWidth', 2);

%% 9. ETIQUETAS

xlabel('Tiempo [s]');
ylabel('Respuesta');

title('Respuesta al escalon unitario - Motor DC');

legend('Respuesta del sistema', ...
       'Valor final esperado', ...
       'Respuesta en t = \tau', ...
       'Respuesta en t = 5\tau', ...
       'Tiempo de asentamiento 2%', ...
       'Location', 'southeast');

%% 10. TEXTO INFORMATIVO EN LA GRAFICA

text(Tau, y_Tau, ...
    sprintf('  t = tau, y = %.4f', y_Tau));

text(5*Tau, y_5Tau, ...
    sprintf('  t = 5tau, y = %.4f', y_5Tau));

text(t_settling, ...
     Km*(1-exp(-t_settling/Tau)), ...
     sprintf('  t_s = %.4f s', t_settling));

hold off;

