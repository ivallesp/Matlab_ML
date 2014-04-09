%% Analiza los SOM obtenidos mediante entrena_som.m
% Se guardan los dos errores; el de cuantización da idea de lo bien que
% representa a los datos y el topográfico da idea de si se mantienen las
% relaciones de vecindad 

clear
clc
close all
load datosSOM;

% Número de SOM guardados en la carpeta ./maps
N=4008;
err_top=zeros(1,N);
err_qe=err_top;

for R=1:N,
    fileName=['./maps/som_' num2str(R)];
    feval('load', fileName); % Se carga el SOM
    [qe,te] = som_quality(sM,sD); % Calcula Error tipográfico y de cuantización
    err_top(R)=te; % Acumula errores topográficos
    err_qe(R)=qe; % Acumula errores de cuantización
    R;
end

save errores err_top err_qe %Guarda los resultados
