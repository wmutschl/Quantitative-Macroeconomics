function f = USOil_fSR(B0inv,hatSigmaU)
% f = USOil_fSR(B0inv,hatSigmaU)
% -------------------------------------------------------------------------
% Evaluates the system of nonlinear equations
%   vech(hatSigmaU) = vech(B0inv*B0inv')
% subject to specified short-run restrictions
% -------------------------------------------------------------------------
% INPUTS
%   - B0inv     : candidate for short-run impact matrix. [nvars x nvars]
%   - hatSigmaU : covariance matrix of reduced-form residuals. [nvars x nvars]
% -------------------------------------------------------------------------
% OUTPUTS
%   - f : function value, see below
% -------------------------------------------------------------------------
% Willi Mutschler, December 8, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------
f = [vech(B0inv*B0inv' - hatSigmaU);
     B0inv(1,2) - 0;
     B0inv(1,3) - 0;
     B0inv(2,3) - 0;
    ];

% % more general way to implement the restrictions
% % nan means unconstrained, 0 (or any other number) restricts to this number
% Rshort = [nan   0   0;
%           nan nan   0;
%           nan nan nan;
%           ];
% selSR = ~isnan(Rshort); % index for short-run restrictions on impact
% f = [vech(B0inv*B0inv'-hatSigmaU);
%      B0inv(selSR) - Rshort(selSR);
%     ];
end