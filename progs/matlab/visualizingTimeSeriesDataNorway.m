% -------------------------------------------------------------------------
% Visualization and descriptive statistics and plots for GDP growth in Norway
% -------------------------------------------------------------------------
% Willi Mutschler (willi@mutschler.eu)
% Version: October 26, 2022
% -------------------------------------------------------------------------

%% Housekeeping
clearvars; clc;close all;

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["DATE", "DATA"];
opts.VariableTypes = ["datetime", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, "DATE", "InputFormat", "yyyy-MM-dd");
% Import the data; load data from different folders, e.g. '../' goes one subdirectory down
NorwayGDP = readtable("../../data/NorwayGDP.csv", opts);
% Clear temporary variables
clear opts
NorwayGDP % note readtable has already detected dates as datetime arrays and we specified the format as "yyyy-MM-dd"
% let's change the format of the dates
NorwayGDP.DATE.Format = 'yyyy-QQQ'; % note that under the hood we did not really change the date string


%% Computations
gdp_mean = nan(1,3); %initialize variable to contain the means for different subsamples
gdp_sd = nan(1,3);   %initialize variable to contain the standard deviations for different subsamples
gdp = NorwayGDP.DATA; 
dates = NorwayGDP.DATE;

for select_sample = 1:4 % this loop runs from 1,2,3,4
    
    if select_sample == 1  % note the double equal sign for comparisons!
        str_sample = '1978-Q1 to 2022-Q2'; %full sample
        sample_start = 1;
        sample_end   = length(gdp);
    elseif select_sample == 2
        str_sample = '1980-Q1 to 2012-Q4';
        % dates == '01-Jan-1980' gives you a vector of 0s and 1s
        % find() finds the position of the 1        
        sample_start = find(dates == '1980-Q1');
        sample_end   = find(dates == '2012-Q4');
    elseif select_sample == 3
        str_sample = '2012-Q4 to 2019-Q4';
        sample_start = find(dates== '2012-Q4');
        sample_end   = find(dates == '2019-Q4');
    elseif select_sample == 4
        str_sample = '2020-Q1 to 2022-Q2';
        sample_start = find(dates== '2020-Q1');
        sample_end   = find(dates == '2022-Q2');
    else
        error('select_sample needs to be 1,2,3,4');
    end

    % Compute growth rate, note that I make use of ":" and of "./"
    gdp_growth = ( gdp((sample_start+1):sample_end) - gdp(sample_start:(sample_end-1)) ) ./ gdp(sample_start:(sample_end-1)); % exact
    gdp_log_dev = log(gdp((sample_start+1):sample_end)) - log(gdp(sample_start:(sample_end-1))); % log approximation
    dates_subsample = dates((sample_start+1):sample_end);

    %% Make figures
    figure('name',['Plot of Q-on-Q growth in Norway from ',str_sample]); % this opens a new window and names it
    hold on; %this enables you to draw in the same window
    plot(dates_subsample,gdp_growth,'linewidth',2,'Color','red','LineStyle','-.');   % simple plot with some options
    plot(dates_subsample,gdp_log_dev,'linewidth',2,'Color','blue','LineStyle','--'); % simple plot with some options
    legend('Exact','Log') % this creates a legend, there are more options to it
    title(['Plot of Q-on-Q growth in Norway from',str_sample]); %add title
    hold off; %turn off drawing in same windows

    figure('name',['Histogram of Q-on-Q growth in Norway from ',str_sample]);
    hold on;
    subplot(1,2,1); % number of rows x number of columns x number of plot, so here first plot in left column
    histfit(gdp_growth,10,'normal'); % 'normal' adds a fitted normal distribution
    title('10 bins');
    subplot(1,2,2); % number of rows x number of columns x number of plot, so here second plot in right column
    histfit(gdp_growth,30,'normal');
    title('30 bins');
    sgtitle(['Histogram of Q-on-Q growth in Norway from ',str_sample]); % add common title for subplots
    hold off;

    figure('name',['Normplot of data from ',str_sample]);
    normplot(gdp_growth);
    title(['Normal Probability Plot of data from ',str_sample])

    figure('name',['Boxplot of data from ',str_sample]);
    boxplot(gdp_growth);
    title(['Box Plot of data from ',str_sample])

    %% Estimates
    gdp_mean(select_sample) = mean(gdp_growth,'omitnan'); % 'omitnan' removes the Not-A-Number values in the computations
    gdp_sd(select_sample) = std(gdp_growth,'omitnan');
    fprintf('%s:The empirical mean is %.4f, the empirical standard deviation is %f\n',str_sample,gdp_mean(select_sample),gdp_sd(select_sample));
    % "%s" is a placeholder for strings
    % "%.2.f" is a placeholder for floating numbers, the .2 prints 2 numbers after the decimal
end


