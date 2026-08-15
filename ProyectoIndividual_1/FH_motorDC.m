clc;
clear;
close all;

%% =========================================================
%  SIMULACION PARAMETRICA PARA UN MOTOR DC
%  G(s) = KM / (tau*s + 1)
% ==========================================================

%% 1. PARAMETROS

fprintf('=============================================\n');
fprintf('     SIMULACION PARAMETRICA MOTOR DC\n');
fprintf('=============================================\n\n');

fprintf('Ingrese los parametros del motor:\n\n');

Kt = input('Kt [N*m/A]: ');
Ra = input('Ra [ohm]: ');
b  = input('b [N*m*s/rad]: ');
Kb = input('Kb [V*s/rad]: ');
J  = input('J [kg*m^2]: ');

%% 2. VALIDACION DE PARAMETROS

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

%% 3. CALCULO DE KM Y TAU

KM = Kt / (Ra*b + Kt*Kb);

tau = (Ra*J) / (Ra*b + Kt*Kb);

%% 4. MOSTRAR RESULTADOS

fprintf('\n=============================================\n');
fprintf('             RESULTADOS\n');
fprintf('=============================================\n');

fprintf('KM  = %.6f\n', KM);
fprintf('tau = %.6f s\n', tau);

fprintf('\nFuncion de transferencia:\n');

fprintf('             %.6f\n', KM);
fprintf('G(s) = -------------------------\n');
fprintf('        %.6f s + 1\n', tau);
