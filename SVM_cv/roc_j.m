
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funcion ROC
% Entrada: oo como probabilidad, des como clase deseada 1 o 0
% Salida: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vpp,vpn,se,sp,v_cutoff,area,W,EE,va,vb,vc,vd]=roc_j(oo,des)
    
    np=sum(des==1);
    nn=sum(des~=1);
    %oo=round(oo*100)/100; %nos quedamos con un decimales
    [no,patrones]=size(des);
    v_cutoff=[0,unique(oo),1]; %tantos puntos de corte como valores diferentes tenga la salida
   
    %v_cutoff=[0,0.25,0.5,0.75,1]; %prueba

    for i_cutoff=[1:length(v_cutoff)]
    if (i_cutoff==1)
        a=np;
        b=nn;
        c=0;
        d=0;
    elseif (i_cutoff==length(v_cutoff))
        a=0;
        b=0;
        c=np;
        d=nn;
    else
        cutoff=v_cutoff(i_cutoff);
        tabla=zeros(2,2);
        a=sum((oo>=cutoff).*(des==1));
        b=sum((oo>=cutoff).*(des~=1));
        c=sum((oo<cutoff).*(des==1));
        d=sum((oo<cutoff).*(des~=1));
    end
    tabla=[a,b;c,d];

    %Para el calculo de la curva ROC
    se(i_cutoff)=0;
    sp(i_cutoff)=0;
    vpp(i_cutoff)=0;
    vpn(i_cutoff)=0;
    va(i_cutoff)=a;
    vb(i_cutoff)=b;
    vc(i_cutoff)=c;
    vd(i_cutoff)=d;

	if (a~=0) 
		se(i_cutoff)=a/(a+c);
        vpp(i_cutoff)=a/(a+b);
        
	end
	if (d~=0) 
		sp(i_cutoff)=d/(d+b);
        vpn(i_cutoff)=d/(d+c);
        
	end
    % Para el calculo del error estandar del Area
    
    %tabla
    %np=(a+c); %numero de reales positivos
    %nn=(b+d); %numero de reales negativos
 
    vp(i_cutoff)=a; %numero de postivos con mayor valor de salida que mayor que el cutoff
    vn(i_cutoff)=d; %numero de negativos con mayor valor de salida que menor que el cutoff    
end 	

for i_cutoff=[1:length(v_cutoff)]
    %i_cutoff
	if (i_cutoff==1)
       		vni(1)=0;
	else
       		vni(i_cutoff)=vn(i_cutoff)-vn(i_cutoff-1);
	end
    
    if (i_cutoff==length(v_cutoff))
        vpi(i_cutoff)=0;
    else
        vpi(i_cutoff)=vp(i_cutoff)-vp(i_cutoff+1);
    end
end

%disp('fin')
%vpi
%sum(vpi)==np

%vni
%sum(vni)==nn

W=sum((1)*vni.*vp+(1/2)*vni.*vpi)/(nn*np);

Q2=sum(vpi.*(vn.^2+vn.*vni+(1/3)*vni.^2))/(np*nn^2);
Q1=sum(vni.*(vp.^2+vp.*vpi+(1/3)*vpi.^2))/(nn*np^2);
EE=sqrt((W*(1-W)+(np-1)*(Q1-W^2)+(nn-1)*(Q2-W^2))/(np*nn)); 

area=-trapz(1-sp,se);

