function [W, T, U, Q, P, B, SS] = plsr(x, y, a)
% PLS: calculates a PLS component.
% The output matrices are W, T, U, Q and P.
% B contains the regression coefficients and SS the sums of
% squares for the residuals.
% a is the numbers of components.
%
% For a components: use all commands to end.

for i=1:a
    % Calculate the sum of squares. Use the function ss.
    sx = [sx; ss(x)];
    sy = [sy; ss(y)];
    
    % Use the function pls to calculate one component.
    [w, t, u, q, p] = pls(x, y);
    
    % Calculate the residuals.
    x = x - t * p';
    y = y - t * q';
    
    % Save the vectors in matrices.
    W = [W w];
    T = [T t];
    U = [U u];
    Q = [Q q];
    P = [P p];
end;

% Calculate the regression coefficients after the loop.
B=W*inv(P'*W)*Q';

% Add the final residual SS to the sum of squares vectors.
sx=[sx; ss(x)];
sy=[sy; ss(y)];

% Make a matrix of the ss vectors for X and Y.
SS = [sx sy];

%Calculate the fraction of SS used.
[a, b] = size(SS);
tt     = (SS*diag(SS(1,:).^(-1)) - ones(a, b)) * (-1);

%End of plsr

function [ss] = ss(x)
%SS: calculates the sum of squares of a matrix X.
%
ss=sum(sum(x.*x));
%End of ss




function [w, t, u, q, p] = pls(x, y)
%%PLS: calculates a PLS component.
u = y(:, 1);

%% The convergence criterion is set very high.
plsConv = 1;

%% The commands from here to end are repeated until convergence.
while (plsConv > 10^-10)
    
    %% Each starting vector u is saved as uold.
    uold = u; w = (u' * x)'; w = w/norm(w);
    t = x * w; q = (t' * y)'/(t' * t);
    u = y * q/(q' * q);
    
    %% The convergence criterion is the norm of u-uold divided by the norm of u.
    plsConv = norm(uold - u)/norm(u);
end

%% After convergence, calculate p.
p = (t' * x)'/(t' * t);