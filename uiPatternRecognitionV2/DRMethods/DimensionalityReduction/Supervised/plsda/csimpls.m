function result=csimpls(Xtrain,Ytrain,ncomp)

%CSIMPLS performs Partial Least Squares regression using the SIMPLS 
% algorithm of de Jong (1993).
%
%
% Required input arguments:
%            Xtrain : Data matrix of the explanatory variables
%                (n observations in rows, p variables in columns)
%            Ytrain : Data matrix of the response variables
%                (n observations in rows, q variables in columns)
%     
% Optional input arguments:
%          ncomp : Number of components to be used.  

%   result.slope     : Classical slope estimate
%   result.int       : Classical intercept estimate
%   result.fitted    : Classical prediction vector
%   result.res       : Classical residuals
%   result.cov       : Estimated variance-covariance matrix of the residuals 
%   result.M         : Classical center of the matrix [Xtrain;Ytrain]
%   result.T         : Classical scores
%   result.weights.r : Classical simpls weights
%   result.weights.p : Classical simpls weights
%   result.Tcov      : Classical covariance matrix of the scores
%   result.ncomp         : Number of components used in the regression

% Reference: 
%    de Jong, S. (1993),
%    "SIMPLS: an alternative approach to Partial Least Squares Regression", 
%    Chemometrics and Intelligent Laboratory Systems, 18, 251-263.
%Written by Karlien Vanden Branden

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

covYX = Xtrain'*Ytrain;
for i=1:ncomp
    covYX = covYX';
    if nVarY>nVarX        
        [RR,LL] = eig(covYX*covYX);  
        [LL,I]  = sort(diag(LL),'descend');
        rr      = RR(:,I(1));
        qq      = covYX*rr; 
        qq      = qq/norm(qq);
    else
        if q1==1
            qq = 1;
            rr = covYX;
        else
            [QQ,LL] = eig(covYX*covYX);
            [LL,I]  = sort(diag(LL),'descend');
            qq      = QQ(:,I(1));
            rr      = covYX*qq;
        end
    end
    tt = Xtrain*rr;
    nttc=norm(tt);
    rr=rr/nttc;
    tt=tt/nttc;
    qq=Ytrain'*tt;
    uu=Ytrain*qq;
    pp=Xtrain'*tt;
    vv=pp;
    if i>1 												
        vv = vv -v*(v'*pp);
    end
    vv = vv/norm(vv);
    covYX = covYX - vv*(vv'*covYX);
    v(:,i)=vv;
    q(:,i)=qq;
    t(:,i)=tt;
    u(:,i)=uu;
    p(:,i)=pp;
    r(:,i)=rr;
end

%Second Stage : Classical Regression and transformation

b=r*q';
int=cy-cx*b;

%classical output
out.T=t;
out.weights.p=p;
out.weights.r=r;
out.coef=[b; int];
out.b=b;
out.int=int;
out.yhat=Xtrain*b+repmat(int,n,1);
out.res=Ytrain-out.yhat;
out.covar=cov(out.res);
if q1==1
    out.stdres=out.res./sqrt(out.covar);
end
out.ncomp=options.ncomp;
STTm=sum((Ytrain-repmat(mean(Ytrain),length(Ytrain),1)).^2);
SSE=sum(out.res.^2);
out.rsquare=1-SSE/STTm;
out.class='CSIMPLS';

%calculating classical distances in Xtrain-space
out.Tcov=cov(t);
out.sd=sqrt(mahalanobis(t,zeros(1,out.ncomp),'cov',out.Tcov))';
out.cutoff.sd=sqrt(chi2inv(0.975,out.ncomp));

%calculating classical orthogonal distances
xt=t*p';
tempo=Xtrain-xt;
for i=1:n
    out.od(i,1)=norm(tempo(i,:));
end
r=rank(Xtrain);
if out.ncomp~=r
    m=mean(out.od.^(2/3));
    s=sqrt(var(out.od.^(2/3)));
    out.cutoff.od = sqrt(norminv(0.975,m,s)^3); 
else
    out.cutoff.od=0;
end

%calculating residual distances
if q1>1
    if (-log(det(out.covar)/(p1+q1-1)))>50
        out.resd='singularity';
    else
       cen=zeros(q1,1);
       out.resd=sqrt(mahalanobis(out.res,cen','cov',out.covar))';
   end
else    %here q==1
    out.resd=out.stdres; %standardized residuals
end
out.cutoff.resd=sqrt(chi2inv(0.975,q1));

%Computing flags
out.flag.od=out.od<=out.cutoff.od;
out.flag.resd=abs(out.resd)<=out.cutoff.resd;
out.flag.all=(out.flag.od & out.flag.resd);


result=struct('slope',{out.b}, 'int',{out.int},'fitted',{out.yhat},'res',{out.res}, 'cov',{out.covar},...
    'M', {out.M},'T',{out.T} ,'weights', {out.weights},'Tcov',{out.Tcov},'ncomp',{out.ncomp},'sd', {out.sd},'od',{out.od},'resd',{out.resd},...
    'cutoff',{out.cutoff},'flag',{out.flag},'class',{out.class});

try
    if options.plots
        makeplot(result)
    end
catch %output must be given even if plots are interrupted 
end






