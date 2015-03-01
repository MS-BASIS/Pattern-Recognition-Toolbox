function [P,T,W,varX,Q,U,varY] = plssimpls(Xtrain,Ytrain,ncomp)
%% plssimpls performs Partial Least Squares regression using the SIMPLS 
%% algorithm of de Jong (1993).

% Input:  Xtrain    - data-block [objects Xtrain variables]
%         Ytrain    - data-block [objects Xtrain classes]
%        ncomp -  number of components (latent variables)

% Output: T - Xtrain scores [objects Xtrain ncomp]
%         P - Xtrain loadings [nvrbls Xtrain ncomp]
%         W - Xtrain orthogonal weights [nvrbls Xtrain ncomp]
%         U - Ytrain-scores [objects Xtrain ncomp]
%         Q - Ytrain-weights
% Reference: 
%    de Jong, S. (1993),"SIMPLS: an alternative approach to Partial Least Squares Regression", 
%    Chemometrics and Intelligent Laboratory Systems, 18, 251-263.

%% Author: Kirill A. Veselkov, Imperial College London, 2011

[nObs,nVar] = size(Xtrain);
nClasses    = size(Ytrain,2);

%% Preallocate outputs
P = zeros(nVar,ncomp);
Q = zeros(nClasses,ncomp);
T = zeros(nObs,ncomp);
U = zeros(nObs,ncomp);
W = zeros(nVar,ncomp);
V = zeros(nVar,ncomp);

covXY = Xtrain'*Ytrain;
for icomp = 1:ncomp
    [w,s,c] = svd(covXY,'econ'); w = w(:,1); 
    %% iteration
    %w = covXY*q;                   % Xtrain block factor weights
    t = Xtrain*w;                  % Xtrain block factor scores
    t = t - mean(t); normt = norm(t);  
    t = t/normt; w = w/normt;           
    p = Xtrain'*t; q = Ytrain'*t;   % Xtrain and Ytrain block factor loadings
    u = Ytrain*q;                   % Ytrain block factor scores
    v = p;
    if icomp > 1
        for repeat = 1:2
            for jcomp = 1:icomp-1
                v = v - V(:,jcomp)*(V(:,jcomp)'*v); %
                u = u - T(:,jcomp)*(T(:,jcomp)'*u);
            end
        end
    end
    v     = v/norm(v);
    covXY = covXY - v*(v'*covXY);
    
    %% save iteration results to outputs:
    T(:,icomp) = t;
    P(:,icomp) = p;
    U(:,icomp) = u;
    Q(:,icomp) = q;
    W(:,icomp) = w;
    V(:,icomp) = v;
end
    
if nargout > 3
    varX = 100*diag(P'*P)./ssq(Xtrain);
end

if nargin>4
    varY = diag(Q'*Q)./ssq(Ytrain);
end
return;