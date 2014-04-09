function [salida_gelm_t,salida_gelm_g]=gelm(Entradas,Deseada,trainIndex,testIndex,Neuronas)

% Opciones del GA a modificar
options = gaoptimset; % InicializaciÛn
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'Generations', 800);
options = gaoptimset(options,'StallGenLimit', 100);
options = gaoptimset(options,'CrossoverFcn', {  @crossoverheuristic [] });
options = gaoptimset(options,'PopInitRange', [-.5;.5]);


EntradasTrain=Entradas(trainIndex,:);
DeseadaTrain=Deseada(trainIndex,:);
EntradasTest=Entradas(testIndex,:);


[N,L]=size(EntradasTrain);% TamaÒo de Entradas para Entrenamiento
G=zeros(N,Neuronas); % InicializaciÛn de la matriz G (Matriz 3000xN.Neuronas)
pesos_oculta=1*randn(Neuronas,L+1); % Matriz N.Neuronasx20

%ObtenciÛn de matriz rho (G) para el entrenamiento
for tt=1:N
    x=[1 EntradasTrain(tt,:)]';% PatrÛn de entrada precedido de un 1 (umbral) (20x1)
    sal=tanh(pesos_oculta*x); %FNL (20x20)*(20x1)
    G(tt,:)=sal'; % Matriz (3000x20)
end

% Planteamos GenÈticos
FitnessFunction =@(w) coste_elm(w,G,DeseadaTrain); %@ designa variable a optimizar
numberOfVariables=Neuronas;

%options = gaoptimset(options,'InitialPopulation',[welm+1*(rand(n_nodos,1)-0.5)]'); %Intento aproximar pesos...
[w,fval] = ga(FitnessFunction,numberOfVariables,options);

% C¡ÅLCULO DE LAS SALIDAS ENTRENAMIENTO GELM
salida_gelm_t=G*w'; % (3000x1) Una salida por patrÛn




[N,L]=size(EntradasTest);% TamaÒo de Entradas para Entrenamiento
% ObtenciÛn de matriz rhog (G) Para la generalizaciÛn
rhog=zeros(N,Neuronas); % InicializaciÛn de la matriz rhog (Matriz 3000xN.Neuronas)
for tt=1:N  
    x=[1 EntradasTest(tt,:)]';% Patr√≥n de entrada precedido de un 1 (umbral) (20x1)
    sal=tanh(pesos_oculta*x); %FNL (20x20)*(20x1)
    rhog(tt,:)=sal';  % Matriz (2000x20)
end
 % C√ÅLCULO DE LAS SALIDAS GENERALIZACI√ìN ELM
 salida_gelm_g=rhog*w'; % (2000x1) Una salida por patr√≥n


end
