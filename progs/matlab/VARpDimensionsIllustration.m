% -------------------------------------------------------------------------
% Illustrate dimensions of VAR(p) model using MATLAB's symbolic toolbox
% -------------------------------------------------------------------------
% Willi Mutschler, November 29, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------
clearvars; clc; close all;

T = 10; % time periods
K = 3;  % number of variables
p = 2;  % number of lags

data = transpose(sym('y', [K T],'real')) % e.g. y2_4 denotes the second variable at t=4

%% y_{t} is [Kx1]
y_1  = data(1,:)'
y_2  = data(2,:)'
y_3  = data(3,:)'
y_4  = data(4,:)'
y_5  = data(5,:)'
y_6  = data(6,:)'
y_7  = data(7,:)'
y_8  = data(8,:)'
y_9  = data(9,:)'
y_10 = data(10,:)'

%% Z_{t-1} is [(1+K*p)x1]; note that we start in t=p not in t=0
Z_2 = [1 y_2' y_1']'
Z_3 = [1 y_3' y_2']'
Z_4 = [1 y_4' y_3']'
Z_5 = [1 y_5' y_4']'
Z_6 = [1 y_6' y_5']'
Z_7 = [1 y_7' y_6']'
Z_8 = [1 y_8' y_7']'
Z_9 = [1 y_9' y_8']'


%% Y = [y_{p+1},..., y_{T}] is [Kx(T-p)]; note that we need to start in t=p+1 not in t=1
% manually by hand
Y_hand = [y_3, y_4, y_5, y_6, y_7, y_8, y_9, y_10]
% more general
Y = transpose(data(p+1:T,:))
% check whether both are equal
isequal(Y,Y_hand)
isequal(size(Y),[K (T-p)])

%% Z = [Z_{p} Z_{p+1} ... Z_{T-1}] is [(1+K*p)x(T-p)]
% manually by hand
Z_hand = [Z_2 Z_3 Z_4 Z_5 Z_6 Z_7 Z_8 Z_9]
% more general
Z = sym(nan(p*K,T));
for ii=1:p
    Z( (K*(ii-1)+(1:K)) , (1+ii):T ) = data(1:T-ii,:)'; % this is basically what transpose(lagmatrix(data,[1:p])) does!
                                                        % note that lagmatrix.m does not work on symbolic variables
                                                        % unless you change line 85 of lagmatrix.m with
                                                        % "YLag = sym(missingValue(ones(numObs,numSeries*numLags)));
end
Z = [ones(1,T-p); Z(:,p+1:T)] % add deterministic term
% check whether both are equal
isequal(Z,Z_hand)
isequal(size(Z),[(1+K*p) (T-p)])