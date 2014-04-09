%%%%PROGRAMITA PARA GENERAR LOS CONJUNTOS PARA LA CV.

clear
clc
close all

%% Carga de datos
load ../../Data/DatosRafa.mat
DatosRafa=Datos;
clear Datos;
[nrow,ncol]=size(DatosRafa);

%% Inicializaciones
N=50; %50
FOLDS=5;

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
%DatosRafa(:,[34,13,15,36,6,8,22,27,4,33,35,29,38,14,42,26,39,43,45])=[];
%Names([34,13,15,36,6,8,22,27,4,33,35,29,38,14,42,26,39,43,45])=[];

[DatosRafa,Names]=dumifica(DatosRafa,Names,6); % Dummy Variables con menos de 6 valores

inputs =DatosRafa(:,2:end);
targets=DatosRafa(:,1);


%inputs=zscore(inputs);

for exper=1:N % Bucle de experimentos (Diferentes k-folds)
    IndicesCV=crossvalind('kfold', targets, FOLDS); % Crea Ìndices de CV
    clear areae areat
    
    for kk=1:FOLDS % Bucle K-FOLD
        train_index=find(IndicesCV~=kk); % Índices de patrones de entrenamiento
        test_index=find(IndicesCV==kk); % Índices de patrones de test
        
        % Conjuntos de entrenamiento inputs/target
        input_train=inputs(train_index,:); 
        target_train=targets(train_index,:);
        
        % Conjuntos de test inputs/target
        input_test=inputs(test_index,:);
        target_test=targets(test_index,:);
        
        % Estandarizamos
        [z,mu,sigma]=zscore(input_train);
        input_train=z;
        %%% Estandarizamos el conjunto de Test
        patrones_input=size(input_test);
        patrones_input=patrones_input(1);
        medias=ones(patrones_input,1)*mu;
        desviaciones=ones(patrones_input,1)*sigma;
        input_test=(input_test-medias)./desviaciones;

        % Generamos el modelo SVM
        [yp,res,model] = AutomaticSVM(target_test,input_test,target_train,input_train);
        name=['./Models/svm_',num2str(exper),'-',num2str(kk)];
        % feval('save', name, 'model', 'train_index','test_index');%Guardamos los modelos
        % Calculamos la salida para Entrenamiento y para Test
        [train_output,res] = PredictSVMM(target_train,input_train,model);
        [test_output,res] = PredictSVMM(target_test,input_test,model);
        
        [vpp,vpn,train_se(kk,:),train_sp(kk,:),v_cutoff,area,W,EE,va,vb,vc,vd]=roc_j(train_output',target_train');
        areae(kk)=area;
        [vpp,vpn,test_se(kk,:),test_sp(kk,:),v_cutoff,area,W,EE,va,vb,vc,vd]=roc_j(test_output',target_test');
        areat(kk)=area; 
    end   
    
    train_se2(exper,:)=mean(train_se,1);
    test_se2(exper,:)=mean(test_se,1);
    train_sp2(exper,:)=mean(train_sp,1);
    test_sp2(exper,:)=mean(test_sp,1);
    
    area_train(exper)=mean(areae);
    area_test(exper)=mean(areat);
    clear train_se test_se train_sp test_sp
end

train_se=mean(train_se2,1);
test_se=mean(test_se2,1);
train_sp=mean(train_sp2,1);
test_sp=mean(test_sp2,1);

titulo=['Curva ROC  !  AUC.TEST=',num2str(mean(area_test)),' - ','AUC.TRAIN=',num2str(mean(area_train))];
plot_roc(test_se,test_sp,'test',train_se,train_sp,'train',titulo)

AUC_TEST=mean(area_test);
AUC_TRAIN=mean(area_train);
SD_AUC_TEST=std(area_test);
SD_AUC_TRAIN=std(area_train);

[Var_diff_mae,NamVar] = importancia_svm(DatosRafa,Names,FOLDS,N);




