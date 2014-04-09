function [yp,res] = PredictSVMM(yt,xt,model)

% function [yp,res] = PredictSVMM(ty,xt,model)

fprintf('Predicting ...\n')
yp = svmpredict(yt,xt,model);

res = assessment(yt,yp,'class');
disp(res)
disp(res.ConfusionMatrix)

