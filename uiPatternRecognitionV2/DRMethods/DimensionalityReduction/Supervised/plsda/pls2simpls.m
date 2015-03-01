function [P,T,W,varX,Q,U,varY] = pls2simpls(X,Y,ncomp)
%% pls2simpls returns parameters of  the fitted pls regression model derived via NIPALS algorithm...
%% on multiple response variable (Ytrain)

%% Input: 
%         Xtrain   - training data set           [samples Xtrain variables in Xtrain]
%         Ytrain   - training data class lebels  [samples Xtrain variables in Ytrain]
%         ncomp    - number of latent components          
%         nortcomp - number of orthogonal components to be computed  
%
%%  Output:
%          T    - predictive scores of X
%          U    - predictive scores of Y
%          W    - weights of X
%          P    - predictive loadings of X
%          Q    - predictive loadings of Y


[nObs,nVar] = size(X);
nClasses    = size(Y,2);
Y           = scaleDataSet(Y,'yes','no');

%% Preallocate outputs
outClass = superiorfloat(X,Y);
P  = zeros(nVar,ncomp,outClass);
Q  = zeros(nClasses,ncomp,outClass);
T  = zeros(nObs,ncomp,outClass);
U  = zeros(nObs,ncomp,outClass);
W  = zeros(nVar,ncomp,outClass);

% An orthonormal basis for the span of the X loadings, to make the successive
% deflation X'*Y simple - each new basis vector can be removed from Cov
% separately.
V    = zeros(nVar,ncomp);
Cov  = X'*Y;
for i = 1:ncomp
    %% SVD on covariance matrix
    [ri,si,ci] = svd(Cov,'econ'); ri = ri(:,1); ci = ci(:,1); si = si(1);    
    ti         = X*ri;
    normti     = norm(ti); ti = ti ./ normti; % ti'*ti == 1
    P(:,i)     = X'*ti;
    qi         = si*ci/normti; % = Y'*ti
    Q(:,i)     = qi;
    T(:,i)     = ti;
    U(:,i)     = Y*qi; 
    W(:,i)     = ri ./ normti; 
    vi         = P(:,i);     
    for repeat = 1:2
        for j = 1:i-1
            vj = V(:,j);
            vi = vi - (vi'*vj)*vj;
        end
    end
    vi     = vi ./ norm(vi);
    V(:,i) = vi;
    Cov    = Cov - vi*(vi'*Cov); % Deflate Cov
    Vi     = V(:,1:i);
    Cov    = Cov - Vi*(Vi'*Cov);
end

if nargout > 3
    ssqX = ssq(X); varX = zeros(1,ncomp);
    for i = 1:ncomp
        varX(i) = 100*(1-ssq(X-T(:,i)*P(:,i)')./ssqX);
    end
end

if nargin>4
    for i = 1:ncomp
        ui = U(:,i);
        for repeat = 1:2
            for j = 1:i-1
                tj = T(:,j);
                ui = ui - (ui'*tj)*tj;
            end
        end
        U(:,i) = ui;
    end  
    ssqY = ssq(Y); varY = zeros(1,ncomp);
    for i = 1:ncomp
        Q(:,i)  = Y'*U(:,i)/(U(:,i)'*U(:,i));
        ssqDiff = ssq(Y-U(:,i)*Q(:,i)')./ssqY;
        varY(i) = 100*(1-ssqDiff);
    end
end
return;