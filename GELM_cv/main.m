%%%%PROGRAMITA PARA GENERAR LOS CONJUNTOS PARA LA CV.

clear
clc
close all
tic
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

inputs =zscore(DatosRafa(:,2:end));
targets=2*(DatosRafa(:,1))-1;
[N,L]=size(DatosRafa);
%% Inicializaciones
EXPERIMENTOS=50; %50
FOLDS=5;
NEURONAS=L:L:35*L;

for n=1:EXPERIMENTOS
n

    IndicesCV=crossvalind('kfold', targets, FOLDS); % Crea Ìndices de CV
    for k=1:FOLDS
        trainIndex=find(IndicesCV~=k);
        testIndex=find(IndicesCV==k);
        DeseadaTr=targets(trainIndex);
        DeseadaGe=targets(testIndex);
        for i=1:length(NEURONAS)
            [salida_gelm_t,salida_gelm_g]=gelm(inputs,targets,trainIndex,testIndex,NEURONAS(i));
            [vpp,vpn,se,sp,v_cutoff,area_t(i,k),W,EE,va,vb,vc,vd]=roc_j(salida_gelm_t,DeseadaTr);
            [vpp,vpn,se,sp,v_cutoff,area_g(i,k),W,EE,va,vb,vc,vd]=roc_j(salida_gelm_g,DeseadaGe);
            
        end
        
   end
    area_experimentos_t(:,n)=mean(area_t,2);
    area_experimentos_g(:,n)=mean(area_g,2);
end
area_media_t=mean(area_experimentos_t,2);
area_media_g=mean(area_experimentos_g,2);




area_std_t=std(area_experimentos_t');
area_std_g=std(area_experimentos_g');
figure
plot(NEURONAS,area_media_t,'b','linewidth',3)
hold on
plot(NEURONAS,area_media_g,'r','linewidth',3)
plot(NEURONAS,area_media_t+area_std_t','b--','linewidth',1)
plot(NEURONAS,area_media_g-area_std_g','r--','linewidth',1)
legend('AUC Training','AUC Test','STD AUC Training','STD AUC Test')
plot(NEURONAS,area_media_t-area_std_t','b--','linewidth',1)
plot(NEURONAS,area_std_g'+area_media_g,'r--','linewidth',1)
grid
title('AUCs GELM')
xlabel('Number of nodes in hidden layer')
ylabel('AUC')



save resultados area_experimentos_t area_experimentos_g area_media_t area_media_g NEURONAS
    