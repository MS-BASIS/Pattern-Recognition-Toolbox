function [T,P,W,varX,U,Q,varY] = pls2nipals(Xtrain,Ytrain,ncomp)
%% pls2nipals returns parameters of  the fitted pls regression model derived via NIPALS algorithm...
%% on multiple response variable (Ytrain)

%% Input: 
%         Xtrain   - training data set           [samples Xtrain variables in Xtrain]
%         Ytrain   - training data class lebels  [samples Xtrain variables in Ytrain]
%         ncomp    - number of latent components          
%%  Output:
%          T    - predictive scores of X
%          U    - predictive scores of Y
%          W    - weights of X
%          P    - predictive loadings of X
%          Q    - predictive loadings of Y
% Reference:
% Geladi, P and Kowalski, B.R., "Partial Least-Squares Regression: A
% Tutorial", Analytica Chimica Acta, 185 (1986) 1--7.

%% Author: Kirill A. Veselkov, Imperial College London, 2011


% Size of Xtrain and Ytrain
[nObsX,nVarX]  =  size(Xtrain);
[nObsY,nVarY]  =  size(Ytrain);
%Ytrain         =  scaleDataSet(Ytrain,'yes','no');
assert(nObsX==nObsY,'Sizes of Xtrain and Ytrain mismatch.');

%% Allocate algorithm's variables to a maximum size
T = zeros(nObsX,ncomp);
P = zeros(nVarX,ncomp);
U = zeros(nObsY,ncomp);
Q = zeros(nVarY,ncomp);
W = zeros(nVarX,ncomp);

%% Initiate data matrices
X = Xtrain; 
Y = Ytrain; 

for icomp = 1:ncomp 
    [~,tidx] = max(sum(X.*X)); % choose the column of X with the largest norm
    [~,uidx] = max(sum(Y.*Y)); % choose the column of Y with the largest norm
    t    = X(:,tidx);
    u    = Y(:,uidx);
    told = t - t;

    % iteration for outer modeling until convergence
    while norm(t-told)/(norm(t)) > 10^-10
        w    = X'*u;
        w    = w/norm(w);
        told = t;
        t    = X*w;
        q    = Y'*t;
        q    = q/norm(q);
        u    = Y*q;
    end
    
    %% update p based on t
    p = X'*t/(t'*t);
    q = Y'*u/(u'*u);
    X = X - t*p';
    Y = Y - u*q';

    %% save iteration results to outputs:
    T(:,icomp) = t;
    P(:,icomp) = p;
    U(:,icomp) = u;
    Q(:,icomp) = q;
    W(:,icomp) = w;

   % if norm(Y)< 10^-10 
   %     ncomp = icomp;
   %     break;
   % end
end

T = T(:,1:icomp);
P = P(:,1:icomp);
U = U(:,1:icomp);
Q = Q(:,1:icomp);
W = W(:,1:icomp);

ssqX = ssq(Xtrain); varX = zeros(1,ncomp);
ssqY = ssq(Ytrain); varY = zeros(1,ncomp);
for i = 1:ncomp
    varX(i) = 100*(1-ssq(Xtrain-T(:,i)*P(:,i)')./ssqX);
    varY(i) = 100*(1-ssq(Ytrain-U(:,i)*Q(:,i)')./ssqY);
end
return;