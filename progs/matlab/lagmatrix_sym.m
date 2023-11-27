%% THIS IS MATLAB's lagmatrix.m with a slight change to make it work with symbolic variables
% in line 85 a sym() is included
function YLag = lagmatrix_sym(Y,lags)
%LAGMATRIX Create matrix of lagged time series
%
% Syntax:
%
%   YLag = lagmatrix(Y,lags)
%
% Description:
%
%   Create a matrix of lagged (time-shifted) series. Positive lags
%   correspond to delays; negative lags correspond to leads.
%
% Input Arguments:
%
%   Y - Time series data. Y may be a vector or a matrix. If Y is a vector,
%     it represents a single series. If Y is a numObs-by-numSeries matrix,
%     it represents numObs observations of numSeries series, with
%     observations across any row assumed to occur at the same time. The
%     last observation of any series is assumed to be the most recent.
%
%   lags - Vector of integer delays or leads, of length numLags, applied to
%     each series in Y. The first lag is applied to all series in Y, then
%     the second lag is applied to all series in Y, and so forth. To
%     include an unshifted copy of a series in the output, use a zero lag.
%
% Output Argument:
%
%   YLag - numObs-by-(numSeries*numLags) matrix of lagged versions of the
%     series in Y. Columns of YLag are, in order, all series in Y lagged by
%     the first lag in lags, all series in Y lagged by the second lag in
%     lags, and so forth. Unspecified observations (presample and
%     postsample data) are padded with NaN values.
%
% Example:
%
%       Y = [(1:5)' (-2:2)']     % 2 series
%       lags = [-1 0 1];         % 3 lags
%       YLag = lagmatrix(Y,lags) % 2*3 = 6 lagged series
%
% See also FILTER.

% Copyright 1999-2010 The MathWorks, Inc.   

if nargin ~= 2
    
    error(message('econ:lagmatrix:UnspecifiedInput'))
      
end

% Check for a vector:

if numel(Y) == length(Y)
   Y = Y(:); % Ensure a column vector
end

% Ensure lags is a vector of integers:

if numel(lags) ~= length(lags) % Check for vector
    
   error(message('econ:lagmatrix:NonVectorLags'))
     
end

lags = lags(:); % Ensure a column vector

if any(round(lags)-lags)
    
   error(message('econ:lagmatrix:NonIntegerLags'))
     
end

missingValue = NaN;  % Assign default missing value

% Cycle through the lags vector and shift the input time series. Positive 
% lags are delays, and can be processed by FILTER. Negative lags are leads,
% and series are flipped (reflected in time), run through FILTER, and then
% flipped again. Series with zero lags are simply copied.

numLags = length(lags); % Number of lags to apply to each time series

[numObs,numSeries] = size(Y);

YLag = sym(missingValue(ones(numObs,numSeries*numLags))); % Preallocate

for c = 1:numLags

    L       = lags(c);
    columns = (numSeries*(c-1)+1):c*numSeries; % Columns to fill, this lag

    if L > 0 % Time delays

       YLag((L + 1):end,columns) = Y(1:(end - L), :);

    elseif L < 0 % Time leads

       YLag(1:(end + L),columns) = Y((1 - L):end, :);

    else % No shifts

       YLag(:,columns) = Y;

    end

end