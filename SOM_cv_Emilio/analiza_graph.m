%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%PROGRAMITA PARA REPRESENTAR LOS RESULTADOS DEL MEJOR%%%%%%%
%%%%%%%%%%%%%%%%%SOM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%A VER QUÉ PASA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear 
clc


load ../datos.mat
load datosSOM
data=datos;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%CREAMOS LA ESTRUCTURA PARA EL SOM %%%%%%
echo off
sData = som_data_struct(data);

%%NORMALIZAMOS LOS DATOS%%%%%%%%%%%%%%%%%%%%
sData = som_normalize(sData,'var');
nombres_variables=names;
long=length(nombres_variables);

%Error cuantizacion mínimo cuando topográfico=0
load resultados_analisis_som
[valor,indice]=min(err_qe(err_top==0));
elegido=['som_',num2str(indice)];
feval('load',elegido);
matcorr=corrcoef(sM.codebook);
[coord(:,2),coord(:,1)]=find(triu((abs(matcorr))>0.85)-eye(long));
for i=1:length(coord)
    coord(i,3)=matcorr(coord(i,2),coord(i,1));
end

relaciones=names(coord(:,1:2));
relaciones(:,3)=num2cell(coord(:,3)');
sortrows(relaciones,-3)