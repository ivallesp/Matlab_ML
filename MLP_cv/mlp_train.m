%%%%PROGRAMITA DE GONZALO PARA DETERMINAR EL MEJOR MODELO NEURONAL %%%%%
%   X - input data.
%   des - target data.
function mlp_train(Datos,FOLDS,N)

%%%%CARGAMOS LOS DATOS
mkdir('Redes') % Creamos la carpeta Redes.

inputs=(Datos(:,2:end))';

targets=(Datos(:,1))';

for exper=1:N
    IndicesCV=crossvalind('Kfold', targets, FOLDS); % Crea índices de CV
    
    for kk=1:FOLDS % Bucle k-fold
        tic
        train_index=find(IndicesCV~=kk); % Índices de entrenamiento para cada fold
        test_index=find(IndicesCV==kk); % Índices de validación para cada fold
        display(['Iteración ',num2str((exper-1)*FOLDS+kk),' de ',num2str(FOLDS*N),'...'])
        % Definimos el umbral a superar para guardar la red
        min_err=-1;
        
        for k=1:30 %Lanzamos cada arquitectura 50 veces (muchas particiones)
            
            for S1=2:5 % Neuronas en la primera capa
                
                for S2=2:5 % Neuronas en la segunda capa
                    
                    % Se crea la red (2 capas ocultas)
                    net = newfit(inputs,targets,[S1, S2],{'tansig','tansig','tansig'});
                    
                    % Estandarización de entradas (help nnprocess)
                    net.inputs{1}.processFcns = {'removeconstantrows','mapstd'};
                    
                    % Se indica qué índices son para test y cuales para train.
                    net.divideFcn='divideind'; % Método de partición
                    net.divideParam.trainInd = train_index;
                    net.divideParam.valInd = test_index;
                    
                    % USAMOS COMO ALGORITMO DE APRENDIZAJE EL LEVENBERG-MARQUARDT
                    % SI QUIERES VER LA LISTA DE ALGORITMOS DE APRENDIZAJE USA help nntrain
                    net.trainFcn = 'trainlm';  %
                    
                    %%%NO DIVIDIMOS LOS CONJUNTOS A VER QUÉ PASA!!!
                    
                    %%% CON ESTA INSTRUCCIï¿½N NO SALEN LAS PANTALLAS DE ENTRENAMIENTO %%%%%%
                    net.trainParam.showWindow=false;
                    
                    %%%%CON ESTA INSTRUCCIï¿½N ENTRENAMOS LA RED %%%%%%%
                    [net,tr] = train(net,inputs,targets);
                    
                    %%%%%OBTENEMOS EL VALOR DEL ERROR %%%%%%%%%%%%%%
                    outputs = sim(net,inputs);
                    
                    %%%TOMAMOS COMO INDICE DE FUNCIONAMIENTO EL VALOR DEL PRODUCTO ENTRE SE Y
                    %%%SP (Sensibilidad y Especificidad)
                    
                    
                    outputs=0.5*(outputs+1);
                    [vpp,vpn,se,sp,v_cutoff,area,W,EE]=roc_j(outputs,0.5*(targets+1));
                    bonanza=se.*sp;
                    bonanza=max(bonanza);
                    
                    if bonanza>min_err
                        mejored=['./Redes/','red_',num2str(exper),'-', num2str(kk)]; %%le vamos dando nombres diferentes redes
                        feval('save', mejored, 'net', 'tr','train_index','test_index'); %%con esto guardamos la red
                        min_err=bonanza;
                        
                    end
                    
                end
                
            end
            
        end
        display(['    Empleados ',num2str(fix(toc)),' segundos.'])
        display('')
    end
end
end







