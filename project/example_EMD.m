load MNIST_images.mat
% earthmover distance for computer vision example

% thing to convolve
filter = [0 -1 0; -1 0 1; 0 1 0];

Xtest = X(:,:,randi(size(X,3)));
samples = 20;
%X = X(:,:,(0:8)*7000+1); % distinct numbers
X = X(:,:,randsample(size(X,3),samples)); % random
n = size(X,2);

% convolve
for i=1:samples
    Xc(:,:,i) = convolve(X(:,:,i),filter,1);
end
Xctest = convolve(Xtest(:,:),filter,1);

[n m] = size(Xctest);
% build cost matrix
cost = zeros(n*m,n*m);
for i=1:n*m
    for j = 1:n*m
        % Earth mover cost on reshapen images
        cost(i,j) = sqrt((ceil(i/n)-ceil(j/n))^2+(mod(i,n)-mod(j,n))^2); 
    end
end


% vectorize inputs and solve transportation
x = reshape(Xctest,[n*m 1]); 
y = squeeze(reshape(Xc,[n*m 1 samples]));
tol = 0.5; lambda = 5;
[C gamma] = OTsolve(cost,x,y,tol,lambda);

% find optimal match
[Cmin xi] = min(C); 
fprintf('Error (transportation cost) is %.3f\n',Cmin)
figure(1)
subplot(2,1,1);
imshow(X(:,:,xi)) % show match
subplot(2,1,2);
imshow(Xtest) % show test
