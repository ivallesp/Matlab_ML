function [salida_elm_t,salida_elm_g]=elm(Entradas,Deseada,trainIndex,testIndex,Neuronas)

EntradasTrain=Entradas(trainIndex,:);
DeseadaTrain=Deseada(trainIndex,:);
EntradasTest=Entradas(testIndex,:);


[N,L]=size(EntradasTrain);% Tamaño de Entradas para Entrenamiento
G=zeros(N,Neuronas); % Inicialización de la matriz G (Matriz 3000xN.Neuronas)
pesos_oculta=1*randn(Neuronas,L+1); % Matriz N.Neuronasx20

%Obtención de matriz rho (G) para el entrenamiento
for tt=1:N
    x=[1 EntradasTrain(tt,:)]';% Patrón de entrada precedido de un 1 (umbral) (20x1)
    sal=tanh(pesos_oculta*x); %FNL (20x20)*(20x1)
    G(tt,:)=sal'; % Matriz (3000x20)
end

% Planteamos ELM
welm=(pinv(G))*DeseadaTrain; % Cálculo de la Pseudoinversa de G (20x3000)(3000x1)

% CÃLCULO DE LAS SALIDAS ENTRENAMIENTO ELM
salida_elm_t=G*welm; % (3000x1) Una salida por patrón

[N,L]=size(EntradasTest);% Tamaño de Entradas para Entrenamiento
% Obtención de matriz rhog (G) Para la generalización
for tt=1:N  
    x=[1 EntradasTest(tt,:)]';% PatrÃ³n de entrada precedido de un 1 (umbral) (20x1)
    sal=tanh(pesos_oculta*x); %FNL (20x20)*(20x1)
    rhog(tt,:)=sal';  % Matriz (2000x20)
end
 % CÃLCULO DE LAS SALIDAS GENERALIZACIÃ“N ELM
 salida_elm_g=rhog*welm; % (2000x1) Una salida por patrÃ³n


end
