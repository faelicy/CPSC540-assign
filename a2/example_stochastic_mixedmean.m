clear all
load quantum.mat
[n,d] = size(X);
lambdaFull = 1;

% Initialize
maxPasses = 10;
progTol = 1e-4;
w = zeros(d,1);
lambda = lambdaFull/n; % The regularization parameter on one example

% Stochastic gradient
w_old = w;
%grecord = [];
wrecord = zeros(d,1,n);
for t = 1:maxPasses*n
    
    % Choose variable to update
    i = randi(n);
    
    % Evaluate the gradient for example i
    [f,g] = logisticL2_loss(w,X(i,:),y(i),lambda);
    
    % Choose the step-size
    alpha = 1/(lambda*t^(1.11));
    
    % Take the stochastic gradient step
    %grecord = [grecord; g];
    w = w - alpha*g;
    
    if mod(t,n) == 0
        wrecord(:,:,n) = w;
        w = sum(wrecord,3)/(n);
        wrecord = [];
        change = norm(w-w_old,inf);
        fprintf('Passes = %d, function = %.4e, change = %.4f\n',t/n,logisticL2_loss(w,X,y,lambdaFull),change);
        if change < progTol
            fprintf('Parameters changed by less than progTol on pass\n');
            break;
        end
        w_old = w;
    else
        wrecord(:,:,mod(t,n)) = w;
    end
end