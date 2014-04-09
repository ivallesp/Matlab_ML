function [yp,res,model] = AutomaticSVM(yv,xv,yt,xt)

% function [yp,res,model] = AutomaticSVM(yv,xv,yt,xt)
%
% Inputs:
%   yv: validation labels
%   xv: validation samples
%   yt: training labels
%   xt: training samples
%
% Outputs:
%   yp:    classification.
%   res:   results.
%   model: SVM model

% (c) 2011 JoRdI, Emilio Soria

verb = 1;
kernel_type = 'rbf'; %'linear'; % 'rbf'

switch kernel_type
    case 'linear'
        svm_param = '-s 0 -t 0 -g %f -c %f';
        vueltas = 1;
    case 'rbf'
        svm_param = '-s 0 -t 2 -g %f -c %f';
        vueltas = 1:2;
end

% Search ranges
npoints = 20;
C = [10 50 100 500 1000];
[v,ic] = min(abs(C-100));

if strcmp(kernel_type, 'rbf')
    % Estimate sigma
    % g = logspace(-2,2,npoints); %[1 10 100];
    % mstd = round(log10(mean(std(xt))));
    fprintf('Estimating sigma ... ')
    dist = pdist(xt);
    mdist = round(log10(mean(dist)));
    fprintf('%f\n', mdist)

    s = logspace(mdist-1,mdist+1,npoints);

    %s = logspace(1,100,npoints);
    
    [v,is] = min(abs(s-exp(mdist)));
else
    s = 1; is =1;
end

fprintf('Adjusting free parameters ...\n')

for vuelta = vueltas
    if strcmp(kernel_type, 'rbf')
        % Sigma
        err = zeros(2,length(s));
        for i = 1:length(s)
            if verb, fprintf('s: %7.2f ... ', s(i)), end
            sparam = sprintf(svm_param, 1/(2*s(i)*s(i)), C(ic));
            model = svmtrain(yt, xt, sparam);
            yp = svmpredict(yv, xv, model);
            res = assessment(yv, yp,'class');
            err(1,i) = res.OA;
            err(2,i) = res.Kappa;
            if verb,
                %plot(1:length(yp),yp,1:length(yv),yv), axis('tight'), shg
                %fprintf('SV: %d, OA: %f, Kappa: %f\n', model.totalSV, err(:,i))
		%disp(res.ConfusionMatrix)
		%pause
            end
        end
        [val,newis] = max(err(2,:));
        if vuelta > 1 && newis == is
            fprintf('Same sigma: stop\n')
            break
        end
        is = newis;
    end

    % C
    err = zeros(2,length(C));
    for i = 1:length(C)
        if verb, fprintf('C: %7.2f ... ', C(i)), end
        sparam = sprintf(svm_param, 1/(2*s(is)*s(is)), C(i));
        model = svmtrain(yt, xt, sparam);
        yp = svmpredict(yv, xv, model);
        res = assessment(yv, yp,'class');
        err(1,i) = res.OA;
        err(2,i) = res.Kappa;
        if verb,
            %plot(1:length(yp),yp,1:length(yv),yv), axis('tight'), shg
       %     fprintf('SV: %d, OA: %f, Kappa: %f\n', model.totalSV, err(:,i))
            disp(res.ConfusionMatrix)
            %pause
        end
    end
    [val,newic] = max(err(2,:));
    if newic == ic
        fprintf('Same C: stop\n')
        break
    end
    ic =  newic;
end

fprintf('Training with s %f and C %f ...\n', 1/(2*s(is)*s(is)), C(ic))
sparam = sprintf(svm_param, 1/(2*s(is)*s(is)), C(ic));

model = svmtrain(yt, xt, sparam);
yp = svmpredict(yv, xv, model);
res = assessment(yv, yp,'class');

if verb,
    %plot(1:length(yp),yp,1:length(yv),yv), axis('tight'), shg
    %fprintf('SV: %d, OA: %f, Kappa: %f\n', model.totalSV, res.OA, res.Kappa)
    disp(res.ConfusionMatrix)
end
