
clear
clc
close all

%% Carga de datos
load ../../Data/DatosRafa.mat
DatosRafa=Datos;
clear Datos;
[nrow,ncol]=size(DatosRafa);


%% Preprocesado de datos
    DatosRafa(:,[1,24,25,63:ncol])=[]; % Borramos las variables no catalogadas
    Names([1,24,25,63:ncol])=[];
    
    DatosRafa(:,[1,7,17])=[]; % Borramos la variable Fecha de nacimiento y Mortalidad (Leer comentarios...)
    Names([1,7,17])=[];
    
    DatosRafa(:,[20,21])=[]; % Eliminamos Variables con Datos Perdidos.
    Names([20,21])=[];
    
    DatosRafa(:,2:7)=[]; % Elegimos deseada DatosRafa(:,1)
    Names(2:7)=[]; 
    
    DatosRafa=cell2mat(DatosRafa); % Ya no hay datos perdidos ---> a Matriz
    
    %Dejamos las 10 variables que más varian al eliminarlas una vez
    %entrenado el MLP con todas.
    %DatosRafa=DatosRafa(:,[1,2,12,41,20,26,42,46,40,10,9]);
    %Names=Names([1,2,12,41,20,26,42,46,40,10,9]);
    
    %Eliminamos Variables menos importantes (RL)
    DatosRafa(:,[34,13,15,36,6,8,22,27,4,33,35,29,38,14,42,26,39,43,45])=[];
    Names([34,13,15,36,6,8,22,27,4,33,35,29,38,14,42,26,39,43,45])=[];    
    
    [DatosRafa,Names]=dumifica(DatosRafa,Names,6); % Dummy Variables con menos de 6 valores






%% Entrenamos y guardamos las redes
FOLDS=5; % Número de particiones k-fold.
EXPERIMENTOS=300; % Número de experimentos. Diferentes particiones.
 mlp_train(DatosRafa,FOLDS,EXPERIMENTOS);

%% Analizamos las redes 
[AUC_train,AUC_test,SD_AUC_train,SD_AUC_test] = mlp_test(DatosRafa,FOLDS,EXPERIMENTOS);

%% Calculamos la importancia... MAE
%[Var_Importance_MAE,NamVar_Importance_MAE]=importancia_mlp(DatosRafa,Names,FOLDS,EXPERIMENTOS);



