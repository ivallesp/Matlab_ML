function [matriz,matriznombres]=dumifica(X,names,minlevelscontinua)




tam=size(X);
tam=tam(2);
matriz=[];
matriznombres={};

BoolVar=zeros(1,tam);
for i=2:tam
    if (length(unique(X(:,i))))<minlevelscontinua && (length(unique(X(:,i))))>2
        BoolVar(i)=1;
    end
end



for i=1:tam
    if BoolVar(i)==1
        dummyficada=dummyvar(X(:,i)+1);
        dummyficadatam=size(dummyficada);
        dummyficadatam=dummyficadatam(2);
        
        matriz=[matriz,dummyficada];
        for j=1:dummyficadatam
            matriznombres=[matriznombres,[names{i},'_dummy_',num2str(j-1)]];
        end
                
    
    else
        matriz=[matriz,X(:,i)];
        matriznombres=[matriznombres,names{i}];
    
    end


end

matriznombres(std(matriz)==0)=[];

matriz(:,std(matriz)==0)=[];
end

