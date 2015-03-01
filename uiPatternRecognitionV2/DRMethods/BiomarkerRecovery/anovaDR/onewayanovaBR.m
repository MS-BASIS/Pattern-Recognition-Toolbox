function [pvalues,stats] = onewayanovaBR(X,y,type)
%%   onewayanovaPWCA performs one-way ANOVA for comparing the means of two or more 
%%   groups of data. 
%%  Input:
%        X   - data matrix [observations x variables]
%        y   - class labels [observations x 1]
%       type - {'anova','Welch'}; 
%              Welch assumes unequal variances between groups
%              anova assumes equal variances between groups
%%  Output:
%      pvalue    - p values for the null hypothesis that the
%                  means of the groups are equal.
%      stats.F   - F statistic
%      stats.dfb - model degrees of freedom
%      stats.dfw - residual degrees of freedom
%% Author: Veselkov Kirill, Imperial College London, 2012

y               = getDummyY(y,'no');
nGrps           = size(y,2);
[nSmpls,nVrbls] = size(X); % the total number of samples 
nSmplsGrp       = sum(y);  % the number of samples per a group

%% Compute group means for ANOVA
grpMean = zeros(nGrps,nVrbls); % group means
grpVar  = zeros(nGrps,nVrbls);
for iGrp = 1:nGrps
    grpMean(iGrp,:) = mean(X(y(:,iGrp)==1,:));
end

switch type
    case 'ANOVA'
        meanX = mean(X);
        SSw   = 0;           
        SSb   = 0;
        for iGrp = 1:nGrps
            SSw = SSw + sum((bsxfun(@minus,X(y(:,iGrp)==1,:),grpMean(iGrp,:))).^2);
            SSb = SSb + nSmplsGrp(iGrp).*((grpMean(iGrp,:)-meanX).^2);
        end
        dfb   = (nGrps - 1);
        dfw   = (nSmpls - nGrps);
        MSb   = SSb/dfb;
        MSw   = SSw/dfw;
        noiseInd = MSw<=10.^-4;
        Fstat = MSb(~noiseInd)./MSw(~noiseInd);
    case 'Welch ANOVA'
        grpWeight = ones(nGrps,nVrbls);
        for iGrp = 1:nGrps
            grpVar(iGrp,:)    = var(X(y(:,iGrp)==1,:));
            grpWeight(iGrp,:) = nSmplsGrp(iGrp)./grpVar(iGrp,:);
        end       
        meanX = sum((grpWeight.*grpMean))./sum(grpWeight);
        SSb    = 0;
        lambda = 0;
        for iGrp = 1:nGrps
            SSb    = SSb + grpWeight(iGrp,:).*(grpMean(iGrp,:)-meanX).^2; 
            lambda = lambda + ((1 - grpWeight(iGrp,:)./sum(grpWeight)).^2)./(nSmplsGrp(iGrp) - 1);
        end
        lambda = 3*lambda./(nGrps.^2 - 1);
        MSb    = SSb/(nGrps - 1);
        Fstat  = MSb./((1+(2*lambda*(nGrps-2))./3));
        dfb    = (nGrps - 1);
        dfw    = 1./lambda;
end
pvalues = ones(1,nVrbls);
pvalues(~noiseInd) = 1 - fcdf(Fstat,dfb,dfw);
if nargout>1
    stats.F      = Fstat;
    stats.method = type;
    stats.dfb    = dfb; 
    stats.dfw    = dfw;
end
return;

function p = fcdf(x,v1,v2,uflag)
%FCDF   F cumulative distribution function.
%   P = FCDF(X,V1,V2) returns the F cumulative distribution function
%   with V1 and V2 degrees of freedom at the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   P = FCDF(X,V1,V2,'upper') returns the upper tail probability of the
%   F distribution with V1 and V2 degrees of freedom at the values in X.
%
%   See also FINV, FPDF, FRND, FSTAT, CDF.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.6.

%   Copyright 1993-2013 The MathWorks, Inc. 


if nargin < 3, 
    error(message('stats:fcdf:TooFewInputs')); 
end

[errorcode, x, v1, v2] = distchck(3,x,v1,v2);

if errorcode > 0
    error(message('stats:fcdf:InputSizeMismatch'));
end

if nargin>=4
    if ~strcmpi(uflag,'upper')
        error(message('stats:cdf:UpperTailProblem'));
    end
    k = ~isnan(x);
    x(k) = 1./max(0,x(k));
    a=v1;
    b=v2;
    v1=b;
    v2=a;
end

% Initialize P to zero.
if isa(x,'single') || isa(v1,'single') || isa(v2,'single')
   p = zeros(size(x),'single');
else
   p = zeros(size(x));
end

t = (v1 <= 0 | v2 <= 0 | isnan(x) | isnan(v1) | isnan(v2));
p(t) = NaN;
s = (x==Inf) & ~t;
if any(s(:))
   p(s) = 1;
   t = t | s;
end

% Compute P when X > 0.
k = find(x > 0 & ~t & isfinite(v1) & isfinite(v2));
if any(k)
    k1 = (v2(k) <= x(k).*v1(k));
    % use A&S formula 26.6.2 to relate to incomplete beta function 
    % Also use 26.5.2 to avoid cancellation by subtracting from 1
    if any(k1)
        kk = k(k1);
        xx = v2(kk)./(v2(kk)+x(kk).*v1(kk));
        p(kk) = betainc(xx, v2(kk)/2, v1(kk)/2,'upper');
    end
    if any(~k1)
        kk = k(~k1);
        num = v1(kk).*x(kk);
        xx = num ./ (num+v2(kk));
        p(kk) = betainc(xx, v1(kk)/2, v2(kk)/2,'lower');
    end
end

if any(~isfinite(v1(:)) | ~isfinite(v2(:)))
   k = find(x > 0 & ~t & isfinite(v1) & ~isfinite(v2) & v2>0);
   if any(k)       
      p(k) = gammainc(v1(k).*x(k)./2, v1(k)./2, 'lower'); % chi2cdf(v1(k).*x(k),v1(k))
   end
   k = find(x > 0 & ~t & ~isfinite(v1) & v1>0 & isfinite(v2));
   if any(k)
      p(k) = gammainc(v2(k)./x(k)./2, v2(k)./2, 'upper'); % 1 - chi2cdf(v2(k)./x(k),v2(k))
   end
   k = find(x > 0 & ~t & ~isfinite(v1) & v1>0 & ~isfinite(v2) & v2>0);
   if any(k)
       if nargin>=4 && x(k)==1
           p(k) = 0;
       else
           p(k) = (x(k)>=1);
       end
   end
end  


function [errorcode,varargout] = distchck(nparms,varargin)
%DISTCHCK Checks the argument list for the probability functions.

%   Copyright 1993-2004 The MathWorks, Inc. 


errorcode = 0;
varargout = varargin;

if nparms == 1
    return;
end

% Get size of each input, check for scalars, copy to output
isscalar = (cellfun('prodofsize',varargin) == 1);

% Done if all inputs are scalars.  Otherwise fetch their common size.
if (all(isscalar)), return; end

n = nparms;

for j=1:n
   sz{j} = size(varargin{j});
end
t = sz(~isscalar);
size1 = t{1};

% Scalars receive this size.  Other arrays must have the proper size.
for j=1:n
   sizej = sz{j};
   if (isscalar(j))
      vj = varargin{j};
      if isnumeric(vj)
         t = zeros(size1,class(vj));
      else
         t = zeros(size1);
      end
      t(:) = varargin{j};
      varargout{j} = t;
   elseif (~isequal(sizej,size1))
      errorcode = 1;
      return;
   end
end
