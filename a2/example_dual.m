X = load('statlog.heart.data');
y = X(:,end);
y(y==2) = -1;
X = X(:,1:end-1);
n = size(X,1);

% Add bias and standardize
X = [ones(n,1) standardizeCols(X)];
d = size(X,2);

% Set regularization parameter
lambda = 1;

% Initialize dual variables
z = zeros(n,1);

% Some values used by the dual
YX = diag(y)*X;
G = YX*YX';

maxIter = 3000; % maybe excessive, but it gets precise results
for j = 1:n*maxIter
    i = randi(n);
    % set partial derivative = 0
    z(i) = 0;
    Dg(i) = 1 - G(i,:)*z/lambda; % partial without zi
    z(i) = Dg(i)*lambda/G(i,i);
    % apply constraints
    if z(i) > 1
        z(i) = 1;
    elseif z(i) < 0
        z(i) = 0;
    end
end

% Evaluate dual objective:
D = sum(z) - (z'*G*z)/(2*lambda);
%z = G\e % solve by gradient minimization (doesn't work, condition # too high?)

% Convert from dual to primal variables
w = (1/lambda)*(YX'*z);

% Evaluate primal objective:
P = sum(max(1-y.*(X*w),0)) + (lambda/2)*(w'*w);

fprintf('Dual value: %2.4f\t Primal value: %3.4f\t %3.f support vectors\n',D,P,sum(z~=0))