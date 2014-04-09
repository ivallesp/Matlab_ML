
function [Var_diff_mae,NamVar] = importancia_svm(Datos,Names,FOLDS,EXPERIMENTOS)



Area_prom_train=0;
Area_prom_test=0;
N_EVAL=10; % Número de redes a evaluar...
R=0;
% En primer lugar tenemos que determinar qué 10 redes tienen mejor AUC
for N=1:EXPERIMENTOS
    for k=1:FOLDS
        R=R+1;
        %%%%CARGAMOS LOS MODELOS %%%%%%
        svmmodel=['./Models/','svm_',num2str(N),'-', num2str(k)]; % Nombre de cada red
        feval('load', svmmodel);
        input_test=Datos(test_index,2:end);
        target_test=Datos(test_index,1);
        
        [test_output,res] = PredictSVMM(target_test,input_test,model);
        [vpp,vpn,test_se,test_sp,v_cutoff,area(N,k),W,EE,va,vb,vc,vd]=roc_j(test_output',target_test');

    end
end

areaeval=area;

for i=1:N_EVAL
    [A,B]=find(areaeval==max(max(areaeval))); %Coordenadas de redes con mayor AUC [EXPERIMENTOS,FOLD]
    coordMax(i,1)=A(1);
    coordMax(i,2)=B(1);
    coordMax(i,3)=max(max(areaeval));
    areaeval(coordMax(i,1),coordMax(i,2))=0;
end

% Ahora aquí toca cargar las redes, ir quitando variables, simular y cargar
% el MAE de la diferencia de coeficientes

full_input=Datos(:,2:end);
full_target=Datos(:,1);

for j=1:N_EVAL
    %%%%CARGAMOS LA RED %%%%%%
    svmmodel=['./Models/','svm_',num2str(coordMax(j,1)),'-', num2str(coordMax(j,2))]; % Nombre de cada red
    feval('load', svmmodel);
    % Calculamos la salida para todas las variables y todos los patrones
    [full_output,res] = PredictSVMM(full_target,full_input,model);
   
    
    % Calculamos la salida anulando, cada vez, una variable y con todos los
    % patrones
    for i=1:min(size(full_input))
        mod_input=full_input;
        mod_input(:,i)=0; %Anulamos la variable i
        [mod_output,res]=PredictSVMM(full_target,mod_input,model);
        mae(i,j)=mean(abs(full_output-mod_output)); %Calculamos el MAE de la diferencia entre salidas.
    end
    
end
mean(mae,2)
Names(2:end)'
[Var_diff_mae,index]=sort(mean(mae,2),'descend');
NamVar=Names(index+1)';
figure
barh(Var_diff_mae);
set(gca,'yticklabel',NamVar,'YTick',1:numel(NamVar));
xlabel('MAE')
title('Importancia de las variables (MAE de la salida con y sin cada una de estas)');

end
