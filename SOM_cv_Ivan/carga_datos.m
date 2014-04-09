load ../datos.mat
chosen=[1,1,0,0,0,1,0,1,1,0,1,0,0,1,0,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1];
datos=datos(:,find(chosen));
names=names(find(chosen));