%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%PROGRAMITA PARA REPRESENTAR LOS RESULTADOS DEL MEJOR%%%%%%%
%%%%%%%%%%%%%%%%%SOM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%A VER QUÉ PASA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear 
clc
close all

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

%Error cuantizacion mínimo cuando topográfico=0
load resultados_analisis_som
[valor,indice]=min(err_qe(err_top==0));
elegido=['./maps/som_',num2str(indice)];
feval('load',elegido);



%%%%MENOR ERROR PRODUCTO CUANTIZACION-TOPOGRÁFICO: 3722
%load som_7563;
sM.comp_names=nombres_variables;


%%%%DETERMINAMOS LOS GANADORES POR SI ACASO %%%%
[bmus(:,1),bmus(:,2)] = som_bmus(sM,sData);
h=som_hits(sM,sData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%VISUALIZACIÓN DEL SOM%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%de la demo del iris %%%%%%%%%%

%som_show(sM,'norm','d')
%som_show(sM,'umat','all')
%som_show_add('label',sMap,'Textsize',8,'TextColor','r','Subplot',2)

%figure
%%%el nuestro %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
long=length(nombres_variables);
som_show(sM,'comp',1:long,'norm','d');
% 
 figure
% 
% %som_show(sM,'umat','all','empty','Labels')
% %som_show_add('label',sM,'Textsize',8,'TextColor','r','Subplot',2)
% 
% %%%SEGUIMOS CON LA DEMO DEL SOM TOOLBOX %%%%%%%
%colormap(1-gray)
som_show(sM,'empty','Número de ganadoras')
som_show_add('hit',h,'MarkerColor','b','Subplot',1)
% 
% % figure
% % colormap(1-gray)
% % som_show(sM,'umat','all','empty','Labels')
% % som_show_add('label',sM,'Textsize',8,'TextColor','r','Subplot',2)
% % [aa,bb]=find(deseada==1);
% % h1 = som_hits(sM,sData.data(bb,:));
% % [aa,bb]=find(deseada==-1);
% % h2 = som_hits(sM,sData.data(bb,:));
% % som_show_add('hit',[h1, h2],'MarkerColor',[1 0 0; 0 1 0],'Subplot',1)
% % % 
% % % 
% % 
% 
figure
%%clustering %%%%%%
%%%%parte que determina los clusters de los datos %%%%%%
[c, p, err, ind] = kmeans_clusters(sM); % find clusterings
[dummy,i] = min(ind); % select the one with smallest index
 som_show(sM,'color',{p{i},sprintf('%d clusters',i)}); % visualize
colormap(jet(i)), som_recolorbar % change colormap

 

 