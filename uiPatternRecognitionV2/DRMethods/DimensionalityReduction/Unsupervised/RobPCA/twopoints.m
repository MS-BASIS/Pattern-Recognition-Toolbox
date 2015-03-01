function result = twopoints(data,ndirect,seed)
%TWOPOINTS calculates ndirect directions through two randomly chosen data points from data.
% If ndirect is larger than the number of all possible directions, then all
% these combinations are considered.
%
% Required input arguments: 
%     data    : Data matrix
%     ndirect : Number of directions through two random data points that
%               needs to be constructed
%
% Optional input arguments:
%     seed : To define the state of the generator (default=0)
%            (0 sets the generator to its default initial state)
%
%I/O:
%    result=twopoints(x,250,0);
%
% Output arguments:
%   result : matrix containing the ndirect directions (each row is a
%            direction)
% 
% This function is part of LIBRA: the Matlab Library for Robust Analysis,
% available at: 
%              http://wis.kuleuven.be/stat/robust.html
% 
% Last modified: 09/06/2008

 if nargin==2
     seed=0;
 end

[n,p]   = size(data);
nrich1  = n*(n-1)/2;
ndirect = min(ndirect,nrich1);
true    = (ndirect == nrich1);
B       = zeros(ndirect,p);
if true
    perm = [1 1];
end
k=1;
for ndir=1:ndirect
    if true
        k1 = 2;
        perm(k1) = perm(k1)+1;
        while ~(k1==1 || perm(k1) <=(n-(k+1-k1)))
            k1       = k1-1;
            perm(k1) = perm(k1)+1;
            for j=(k1+1):k+1
                perm(j) = perm(j-1)+1;
            end
        end
        index=perm; % index : contains trial subsample.
    else
        [index,seed] = randomset(n,2,seed);
    end
    B(ndir,:)=data(index(1),:)-data(index(2),:);
end
result=B;

function [ranset,seed]=randomset(tot,nel,seed)
%RANDOMSET draws randomly a subsample of nel cases out of tot.
%(It is called if not all (p+1)-subsets out of n will be considered.) 
%
% Required input arguments: 
%     tot : The total number of observations to consider
%     nel : The number of observations that the subsample must contain
% Optional input arguments:    
%     seed : To define the state of the generator (default=0)
%            (0 sets the generator to its default initial state)
%
% Output arguments:
%   ranset : Random subset of nel cases out of tot.
%   seed   : The corresponding state.
% 
%
% I/O:
%    [ranset,seed]=randomset(n,n/2,0)
%
% This function is part of LIBRA: the Matlab Library for Robust Analysis,
% available at: 
%              http://wis.kuleuven.be/stat/robust.html
    
if nargin==2
    seed=0;
end

for j=1:nel
   [random,seed]=uniran(seed);       
   num=floor(random*tot)+1;
   if j > 1
      while any(ranset==num)
         [random,seed]=uniran(seed);       
         num=floor(random*tot)+1;
      end   
   end
   ranset(j)=num;
end

function [random,seed]=uniran(seed)
%UNIRAN is the uniform random generator used in mcdcov.m and ltsregres.m

% This function is part of LIBRA: the Matlab Library for Robust Analysis,
% available at: 
%              http://wis.kuleuven.be/stat/robust.html

seed   = floor(seed*5761)+999;
quot   = floor(seed/65536);
seed   = floor(seed)-floor(quot*65536);
random = seed/65536.D0;