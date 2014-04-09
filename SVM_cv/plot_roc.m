

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funcion 
% Entrada: 
% Salida: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function []=plot_roc_j(Se1,Sp1,legend1,Se2,Sp2,legend2,titulo)
	
	figure
	axis([0 1 0 1]);	
	hold on
    	
	title(titulo,'FontSize', 15,'FontWeight','bold');
	xlabel('1-Especificidad','FontSize', 20);
	ylabel('Sensibilidad','FontSize', 20);
	
        plot(1-Sp1,Se1,'r--','LineWidth',1.5)

        plot(1-Sp2,Se2,'b:','LineWidth',1.5)
        legend(legend1,legend2,4);
end
 



