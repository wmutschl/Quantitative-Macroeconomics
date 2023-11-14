% -------------------------------------------------------------------------
% Compares different ways to compute solution of Lyapunov equation
% SIGy = A*SIGy*A' + SIGu, i.e. analytically using the Kronecker formula
% and the doubling algorithm
% -------------------------------------------------------------------------
% Willi Mutschler, November 16, 2021
% willi@mutschler.eu
% -------------------------------------------------------------------------
clearvars; clc; close all;

%% Small example
A = [0.5,   0,   0;
     0.1, 0.1, 0.3;
     0,   0.2, 0.3];
SIGu = [2.25 0 0; 0 1 0.5; 0 0.5 0.74];

tic
vecSIGy   = (eye(size(A,1)^2)-kron(A,A)) \ SIGu(:);
SIGy_kron = reshape(vecSIGy,size(A));
toc

tic
SIGy_dlyap = dlyapdoubling(A,SIGu);
toc
fprintf('The maximum absolute difference of entries is %d\n',max(abs(SIGy_kron(:)-SIGy_dlyap(:))));

% re-run to see that dlyapdoubling becomes faster
% (quicker access to ram and just-in-time compilation)

%% Example with larger matrices
% Define the matrix size
n = 100;
% Loop until A has all eigenvalues inside the unit circle
while true
    SIGu = randn(n,n);
    SIGu = SIGu'*SIGu;
    Arand = rand(n, n);
    % Normalize the matrix to ensure its spectral radius (maximum absolute eigenvalue) is less than 1
    spectral_radius = max(abs(eig(Arand)));
    A = Arand / (spectral_radius + 1e-5); % Adding a small value to avoid division by zero
    % Check if all eigenvalues are inside the unit circle
    if max(abs(eig(A))) < 1
        break;
    end
end

% run comparison
tic
vecSIGy   = (eye(size(A,1)^2)-kron(A,A)) \ SIGu(:);
SIGy_kron = reshape(vecSIGy,size(A));
toc

tic
SIGy_dlyap = dlyapdoubling(A,SIGu);
toc
fprintf('The maximum absolute difference of entries is %d\n',max(abs(SIGy_kron(:)-SIGy_dlyap(:))));

% MATLAB's built-in functions
tic
lyap(A,SIGu);
toc
tic
dlyap(A,SIGu); 
toc
tic
dlyapchol(A,chol(SIGu));
toc