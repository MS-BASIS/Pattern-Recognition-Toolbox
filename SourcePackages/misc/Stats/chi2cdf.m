function p = chi2cdf(x,v,uflag)
%CHI2CDF Chi-square cumulative distribution function.
%   P = CHI2CDF(X,V) returns the chi-square cumulative distribution
%   function with V degrees of freedom at the values in X.
%   The chi-square density function with V degrees of freedom,
%   is the same as a gamma density function with parameters V/2 and 2.
%
%   The size of P is the common size of X and V. A scalar input   
%   functions as a constant matrix of the same size as the other input.    
%
%   P = CHI2CDF(X,V,'upper') returns the upper tail probability of 
%   the chi-square distribution. 
%
%   See also CHI2INV, CHI2PDF, CHI2RND, CHI2STAT, CDF.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.4.
%
%   Notice that we do not check if the degree of freedom parameter is integer
%   or not. In most cases, it should be an integer. Numerically, non-integer 
%   values still gives a numerical answer, thus, we keep them.

%   Copyright 1993-2013 The MathWorks, Inc. 


if nargin < 2, 
    error(message('stats:chi2cdf:TooFewInputs'));
end



if nargin>2
    if ~strcmpi(uflag,'upper')
        error(message('stats:cdf:UpperTailProblem'));
    end
else
    uflag=[];
end

% Call the gamma distribution function. 
p = gamcdf(x,v/2,2,uflag);


function [varargout] = gamcdf(x,varargin)
%GAMCDF Gamma cumulative distribution function.
%   P = GAMCDF(X,A,B) returns the gamma cumulative distribution function
%   with shape and scale parameters A and B, respectively, at the values in
%   X.  The size of P is the common size of the input arguments.  A scalar
%   input functions as a constant matrix of the same size as the other
%   inputs.
%
%   Some references refer to the gamma distribution with a single
%   parameter.  This corresponds to the default of B = 1. 
%
%   [P,PLO,PUP] = GAMCDF(X,A,B,PCOV,ALPHA) produces confidence bounds for
%   P when the input parameters A and B are estimates.  PCOV is a 2-by-2
%   matrix containing the covariance matrix of the estimated parameters.
%   ALPHA has a default value of 0.05, and specifies 100*(1-ALPHA)%
%   confidence bounds.  PLO and PUP are arrays of the same size as P
%   containing the lower and upper confidence bounds.
%
%   [...] = GAMCDF(...,'upper') returns the upper tail probability of 
%   the gamma distribution. 
%
%   See also GAMFIT, GAMINV, GAMLIKE, GAMPDF, GAMRND, GAMSTAT, GAMMAINC.

%   GAMMAINC does computational work.

%   References:
%      [1] Abramowitz, M. and Stegun, I.A. (1964) Handbook of Mathematical
%          Functions, Dover, New York, section 26.1.
%      [2] Evans, M., Hastings, N., and Peacock, B. (1993) Statistical
%          Distributions, 2nd ed., Wiley.

%   Copyright 1993-2013 The MathWorks, Inc.


if nargin < 2
    error(message('stats:gamcdf:TooFewInputs'))
end
if nargin>2 && strcmpi(varargin{end},'upper')
    %Compute upper tail and remove 'upper' flag
    uflag=true;
    varargin(end) = [];
elseif nargin>2 && ischar(varargin{end})&& ~strcmpi(varargin{end},'upper')
    error(message('stats:cdf:UpperTailProblem'));
else
    uflag=false;
end
[varargout{1:max(1,nargout)}] = localgamcdf(uflag,x,varargin{:});

function [p,plo,pup] = localgamcdf(uflag,x,a,b,pcov,alpha) 
if nargin < 4
    b = 1;
end

% More checking if we need to compute confidence bounds.
if nargout > 1
    if nargin < 5
        error(message('stats:gamcdf:TooFewInputsNeedCov'));
    end
    if ~isequal(size(pcov),[2 2])
        error(message('stats:gamcdf:BadCovarianceSize'));
    end
    if nargin < 6
        alpha = 0.05;
    elseif ~isnumeric(alpha) || numel(alpha) ~= 1 || alpha <= 0 || alpha >= 1
        error(message('stats:gamcdf:BadAlpha'));
    end
end

% Set things up to make GAMMAINC up to return NaN for out of range parameters, and
% zero for negative x.  It handles Infs the way we want.
a(a < 0) = NaN;
b(b <= 0) = NaN;
x(x < 0) = 0;

try
    z = x ./ b;
    if uflag==true
        p = gammainc(z, a,'upper');
    else
        p = gammainc(z, a);
    end
catch
    error(message('stats:gamcdf:InputSizeMismatch'));
end

% Compute confidence bounds if requested.
if nargout >= 2
    % Approximate the variance of p on the logit scale
    logitp = log(p./(1-p));
    dp = 1 ./ (p.*(1-p)); % derivative of logit(p) w.r.t. p
    da = dgammainc(z,a) .* dp; % dlogitp/da = dp/da * dlogitp/dp
    db = -exp(a.*log(z)-z-gammaln(a)-log(b)) .* dp; % dlogitp/db = dp/db * dlogitp/dp
    varLogitp = pcov(1,1).*da.^2 + 2.*pcov(1,2).*da.*db + pcov(2,2).*db.^2;
    if any(varLogitp(:) < 0)
        error(message('stats:gamcdf:BadCovariancePosSemiDef'));
    end
    
    % Use a normal approximation on the logit scale, then transform back to
    % the original CDF scale
    halfwidth = -norminv(alpha/2) * sqrt(varLogitp);
    explogitplo = exp(logitp - halfwidth);
    explogitpup = exp(logitp + halfwidth);
    plo = explogitplo ./ (1 + explogitplo);
    pup = explogitpup ./ (1 + explogitpup);
end
