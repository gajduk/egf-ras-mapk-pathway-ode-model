%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  measurements and comparisons of computing performance are required,
%  e.g. cpu time vs. the size of the problem (genes x interactions).
% 
%   Y = Omega q
%   Y in n*M
%   Omega in (n*M)x(n*N)
%   q in n*N
%   n : the number of genes
%   M : the number of time steps
%   N : the number of possible candidate bases
%   S : the number of interactions in q
%   
% We use l1-magic code in MATLAB. 
% Since we are interested in computation time w.r.t measurements, genes, and
% interaction, we generate measurement matrix and observations as below.
%
% You may need to download l1-magic code from http://users.ece.gatech.edu/~justin/l1magic/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
rand('state',0);  % initialize random generators
randn('state',0);   


% parameter
N_dic = 3; % number of dictionary for each state (for example, linear, hill_inh, hill_act ...
n = 20; N = n*N_dic; k = 5; % avrg. connectivity for each node;
M = 5*k; % practical case (n*M >= 4S, thus M=4k)(for larger network, since the number of columns increases, we choose slightly bigger M>4k)



L = n*N;  % signal length, or number of columns in Omega
S = n*k;  % sparsity (interactions in the signal)
K = n*M;  % number of observations to make or number of rows in Omega


%% random +/0 1 signal 
% (for real application, we don't need to need this step since we want to
% construct q from Y=Omega *q 
q = zeros(L,1);
p = randperm(L);
q(p(1:S)) = sign(randn(S,1));


%% measurement matrix Omega
disp('create measurement matrix...');
Omega = randn(K,L);
Omega = orth(Omega')'; 
disp('Done.');

% ======================================================
% TO DO for real application, you need to construct Omega based on Equation (12)
% with time series gene expression

% you can also include module to reduce coherence either 
% 1. Randomly chosen matrix Psi based on Equation (21) or
% 2. Finding the optimal transformation
% ======================================================


%% observation Y
Y = Omega * q;

% ======================================================
% TO DO for real application, you need to construct Y based on Equation (12) with
% time series gene expression
% ======================================================

%% Reconstruction based on Equation (26)
q0 = Omega'*Y; %  initial guess = min energy

% solve the LP
tic
q_est = l1eq_pd(q0, Omega, [], Y, 1e-3);
toc



% error
norm(q-q_est)



