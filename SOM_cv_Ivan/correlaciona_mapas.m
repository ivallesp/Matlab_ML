%% Correlaciona los mapas para tener una idea de los mapas más parecidos.

clear 
clc

carga_datos
load datosSOM
data=datos;

indice=input('Introduce el número del SOM a estudiar: ');

nombres_variables=names;
long=length(nombres_variables);

load errores
elegido=['./maps/som_',num2str(indice)];
feval('load',elegido);
matcorr=corrcoef(sM.codebook);
[coord(:,2),coord(:,1)]=find(triu((abs(matcorr))>0.85)-eye(long));
for i=1:size(coord,1)
    coord(i,3)=matcorr(coord(i,2),coord(i,1));
end

relaciones=names(coord(:,1:2));
relaciones(:,3)=num2cell(coord(:,3)');
sortrows(relaciones,-3)