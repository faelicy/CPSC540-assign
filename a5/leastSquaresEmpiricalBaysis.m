function [model] = leastSquaresEmpiricalBaysis(x,y)
n = length(x);
% Construct Basis
Xpoly = polyBasis(x,degree);

% Solve least squares problem (assumes that Xpoly'*Xpoly is invertible)
w = (Xpoly'*Xpoly)\Xpoly'*y;

C = eye(n)/sigma^2 + Xpoly*Xpoly'/lambda;
v = C\y;
nlml = logdet(C)+y'*v;

model.w = w;
model.degree = degree;
model.predict = @predict;

end

function [yhat] = predict(model,Xtest)
Xpoly = polyBasis(Xtest,model.degree);
yhat = Xpoly*model.w;
end

function [Xpoly] = polyBasis(x,m)
n = length(x);
Xpoly = zeros(n,m+1);
for i = 0:m
    Xpoly(:,i+1) = x.^i;
end
end