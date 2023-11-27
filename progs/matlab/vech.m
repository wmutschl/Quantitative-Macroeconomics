function B = vech(A)
% function B = vech(A)
% -------------------------------------------------------------------------
% This function calculates the vech of a square matrix
% -------------------------------------------------------------------------
% INPUTS
%   - A: a square matrix
% -------------------------------------------------------------------------
[m,n] = size(A);
if m ~= n
    error('The input matrix must be square');
end
B      = zeros(n*(n+1)/2,1);
index  = 0;
for i=1:n
    B(1+index:index+n+1-i,1) = A(i:n,i);    
    index = index + n+1-i;    
end