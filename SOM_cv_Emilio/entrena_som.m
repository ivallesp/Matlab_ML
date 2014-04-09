%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%EN ESTE PROGRAMA CREAMOS EL SOM DESDE CERO %%%%%%%
%%%%%A VER QUÉ PASA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all

mkdir maps
load ../datos.mat

X=datos;

echo off
sData = som_data_struct(X); % Se crea el Data Struct para el SOM
sData = som_normalize(sData,'var'); % Normalización de variables. Escalado Lineal
% Datos relativos a la normalización en comp_norm.


%%%%HACEMOS LOS BUCLES DEL SOM PARA VER QÚE PASA
%%%%AQUÍ VARIAMOS TODOS LOS PARÁMETROS DEL SOM %%%%
R=1;

for inicia=1:2 %%%%%INICIALIZACIONES %%%%%%%%%%%%%%%%
    
    inicia=1;
    posib1={'randinit','lininit'};
    elec1=char(posib1(inicia));
    
    if inicia==1
        
        num_rep=500;
        
    else
        
        num_rep=1
        
    end
    
    for k=1:num_rep,
        
        
        %for k=1:500 %%%% número de pruebas diferente %%%%%%%%%%%%
        
        for algor=1:2 %%%%%%ALGORITMOS %%%%%%%%%%%%%%%%
            
            posib2={'seq', 'batch'};
            elec2=char(posib2(algor));
            
            for vec=1:4 %%%%%%%%VECINDADES %%%%%%%%%%%%%%%
                
                posib3={'gaussian', 'cutgauss', 'ep', 'bubble'};
                elec3=char(posib3(vec));
                
                
                % Posibilidades 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %     'init'       *(string) initialization: 'randinit' or 'lininit' (default)
                %     'algorithm'  *(string) training: 'seq' or 'batch' (default) or 'sompak'
                %     'munits'      (scalar) the preferred number of map units
                %     'msize'       (vector) map grid size
                %     'mapsize'    *(string) do you want a 'small', 'normal' or 'big' map
                %                            Any explicit settings of munits or msize override this.
                %     'lattice'    *(string) map lattice, 'hexa' or 'rect'
                %     'shape'      *(string) map shape, 'sheet', 'cyl' or 'toroid'
                %     'neigh'      *(string) neighborhood function, 'gaussian', 'cutgauss',
                %                            'ep' or 'bubble'
                %     'topol'      *(struct) topology struct
                %     'som_topol','sTopol' = 'topol'
                %     'mask'        (vector) BMU search mask, size dim x 1
                %     'name'        (string) map name
                %     'comp_names'  (string array / cellstr) component names, size dim x 1
                %     'tracking'    (scalar) how much to report, default = 1
                %     'training'    (string) 'short', 'default', 'long'
                %                   (vector) size 1 x 2, first length of rough training in epochs,
                %                            and then length of finetuning in epochs
                
                
                echo off
                
                
                
                %sM=som_make(sData,'init',elec1,'algorithm',elec2,'neigh',elec3,'tracking',0, 'training',[100 25]);
                sM=som_make(sData,'init',elec1,'algorithm',elec2,'neigh',elec3,'tracking',0);
                %%%% hay qu hacer el entrenamiento largo también....mirar cuantas
                %%%% iteraciones salen con el corto!!!%%%%%%%%%%%%%%%%
                mejorsom=['./maps/som_' num2str(R)];
                feval('save', mejorsom, 'sM');
                R=R+1;
            end
        end
    end
    
end
save datosSOM sData


 