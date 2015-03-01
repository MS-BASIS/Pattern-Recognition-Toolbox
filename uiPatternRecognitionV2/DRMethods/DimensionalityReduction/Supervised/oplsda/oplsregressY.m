function oplsmodel = oplsregressY(Xtrain,Ytrain,ncomp,nortcomp)
%% oplsregress returns a structure, oplsmodel, containing information
%% about the fitted opls regression model on multiple response variable (Y)

%% Input: 
%         Xtrain   - training data set           [samples x variables in X]
%         Ytrain   - training data class lebels  [samples x variables in Y]
%         ncomp    - number of latent components          
%         nortcomp - number of orthogonal components to be computed  
%
%%  Output:
%         oplsmodel.t    - predictive scores
%                  .w    - weights
%                  .p    - predictive loadings
%                  .c    - regression coefficients
%                  .Tort - orthogonal scores
%                  .Port - orthogonal loadings 
%                  .Wort - orthogonal weights
%                  .ytrain_hat - predicted class labels
%
%       Reference: Trygg J, Wold S: Orthogonal projections to latent...
%                  structures (O-PLS).  J Chemometrics 2002, 16:119-128.
%% Author: Kirill A. Veselkov, Imperial College London, 2011

if nargin < 3
    ncomp = 1;
end
if nargin < 4
    nortcomp = 1;
end

%% Initialize model parameters
[nObsX,nVarX] = size(Xtrain); [nObsY,nVarY] = size(Ytrain); assert(nObsX==nObsY,'Number of observations in X must be equal to Y');
T    = zeros(nObsX,ncomp); W    = zeros(nVarX,ncomp); P    = zeros(nVarX,ncomp);   
Tort = zeros(nObsX,ncomp); Wort = zeros(nVarX,ncomp); Port = zeros(nVarX,ncomp);   
C    = zeros(nObsY,ncomp); U    = zeros(nObsY,ncomp); B    = zeros(ncomp,ncomp);


%% Calculate cross pruduct between X and Y matrices, and perform SVD
for i = 1:ncomp
    Wcross      = Ytrain'*Xtrain;
    [Tw,Pw]     = pcasvd(Wcross);
    dimTw       = size(Tw,1);
    
    %% Estimate a regular PLS component using NIPALS
    for j = 1:nortcomp
        [i,tidx] =  max(sum(Xtrain.*Xtrain));
        [i,uidx] =  max(sum(Ytrain.*Ytrain));
        t        = Xtrain(:,tidx);
        unew     = Ytrain(:,uidx);
        uold     = zeros(nObsY,1);
        while norm(unew-uold) > 10^-10
            w    = Xtrain'*unew;
            w    = w/norm(w);
            t    = Xtrain*w;
            c    = Ytrain'*t;
            c    = c/norm(c);
            uold = unew;
            unew = Ytrain*c;
        end
        p      = Xtrain'*t/(t'*t);
        T(:,i) = t; W(:,i) = w; P(:,i) = p; 
        C(:,i) = c; U(:,i) = unew;
        
        %% orthogonalize p to each column of T
        wort = p;        
        for k = 1:dimTw
            wort  = wort - ((Tw(:,k)'*wort)/(Tw(:,k)'*Tw(:,k)))*Tw(:,k);
        end
        Wort(:,j) = wort; Tort(:,j) = Xtrain*wort;
        Port(:,j) = Xtrain*Tort(:,j)./(Tort(:,j)'*Tort(:,j));
        Xtrain    = Xtrain -  Tort(:,j)*Port(:,j);
    end
    Xtrain     = Xtrain - T(:,i)*P(:,i);
    Ytrain     = Ytrain - T(:,i)*C(:,i)';
end

oplsmodel.T          = T;           % scores
oplsmodel.W          = W;           % weights
oplsmodel.P          = P;           % loadings
oplsmodel.C          = C;           % regression coefficients
oplsmodel.Tort       = Tort;        % orthogonal scores
oplsmodel.Port       = Port;        % orthogonal loadings 
oplsmodel.Wort       = Wort;        % orthogonal weights
oplsmodel.ncomp      = ncomp;       % number of predictive components
oplsmodel.nortcomp   = nortcomp;    % number of orthogonal components
oplsmodel.Ytrain     = Ytrain;      % class labels
return