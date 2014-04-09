%%%%FICHERO PARA ANALIZAR LOS SOM OBTENIDOS %%%%%%%%%

clear
clc
close all
load datosSOM;
%%%%N es el número de SOM que generéis %%%%%%
N=8000;
err_top=zeros(1,N);
err_qe=err_top;

for R=1:N,

  %%% %% CARGAMOS EL SOM CORRESPONDIENTE %%%%%%
mejorsom=['./maps/som_' num2str(R)]; 
feval('load', mejorsom); 
%%%%%DETERMINAMOS SU ERROR DE CUANTIZACIÓN %%%%%
%%%%%Y SU ERROR TOPOGRÁFICO %%%%%%%%%%%%%%%%%%

[qe,te] = som_quality(sM,sData);
err_top(R)=te;
err_qe(R)=qe;
R;
%%%%%%%%%%%%%%%%%%%%%%%%

end
   
%%%%se guardan los dos errores; el de cuantización da idea de lo bien que
%%%%representa a los datos y el topográfico da idea de si se mantienen las
%%%%relaciones de vecindad %%%%%%%%%%%%%%%%%%%%%%%%%%

save resultados_analisis_som err_top err_qe
