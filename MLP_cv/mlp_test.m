
function [AUC_train,AUC_test,SD_AUC_train,SD_AUC_test] = mlp_test(Datos,FOLDS,EXPERIMENTOS)



Areas_train=[];
Areas_test=[];

R=0;
for N=1:EXPERIMENTOS 
    for k=1:FOLDS
        R=R+1;
        %%%%CARGAMOS LA RED %%%%%%
        mejored=['./Redes/','red_',num2str(N),'-', num2str(k)]; % Nombre de cada red
        feval('load', mejored);
        input_train=Datos(train_index,2:end);
        input_test=Datos(test_index,2:end);
        target_train=Datos(train_index,1);
        target_test=Datos(test_index,1);
        
        %%%CONJUNTO DE ENTRENAMIENTO
        oo=sim(net,input_train');
        oo=0.5*(oo+1);
        des=0.5*(target_train'+1);
        [vpp,vpn,train_se(R,:),train_sp(R,:),v_cutoff,area,W,EE,va,vb,vc,vd]=roc_j(oo,des);
        Areas_train=[Areas_train,area];
        
        %%%VAMOS AL CONJUNTO DE TEST
        oo=sim(net,input_test');
        oo=0.5*(oo+1);
        des=0.5*(target_test'+1);
        [vpp,vpn,test_se(R,:),test_sp(R,:),v_cutoff,area,W,EE,va,vb,vc,vd]=roc_j(oo,des);
        Areas_test=[Areas_test,area];

        
    end
end
SD_AUC_test=std(Areas_test);
SD_AUC_train=std(Areas_train);

AUC_test=mean(Areas_test);

AUC_train=mean(Areas_train);

train_se=mean(train_se);
train_sp=mean(train_sp);
test_se=mean(test_se);
test_sp=mean(test_sp);

titulo=['Curva ROC  !  AUC.TEST=',num2str(AUC_test),' - ','AUC.TRAIN=',num2str(AUC_train)];
plot_roc(test_se,test_sp,'test',train_se,train_sp,'train',titulo)
end
