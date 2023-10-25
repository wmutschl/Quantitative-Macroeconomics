% =========================================================================
% definitionFrequenciesTimeSeriesData.m
% =========================================================================
% Hint:
% 1. Always look at the Excel/csv file first (outside MATLAB)
% 2. Use Matlab's "Import Data" tool, select the data you want to include.
%    Then click on the arrow below "Import Selection" and "Generate Script"
% =========================================================================
% Willi Mutschler (willi@mutschler.eu)
% Version: October 26, 2022
% =========================================================================

%% Housekeeping
clearvars; clc;close all;
figure('Name','Various time series for Norway')
sgtitle('Various time series for Norway');

%% GDP growth (% quarterly)
opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "FRED Graph"; % Specify sheet
opts.DataRange = "A12:B185"; % Specify range
opts.VariableNames = ["observation_date", "real_gdp"]; % Specify column names
opts.VariableTypes = ["datetime", "double"]; % Specify column types
opts = setvaropts(opts, "observation_date", "InputFormat", "yyyy-MM-dd"); % Specify variable properties
NorwayGDP = readtable("../../data/NorwayGDP.xls", opts, "UseExcel", false); % Import the data
gpd_growth = 100*(log(NorwayGDP.real_gdp(4:end)) - log(NorwayGDP.real_gdp(3:end-1)));
subplot(3,2,1)
h = plot(NorwayGDP.observation_date(4:end),gpd_growth);
title('GDP growth (% - quarterly)')
xtickformat('yyyy-QQQ')
set(h.Parent, 'XTick', NorwayGDP.observation_date(4:16:end)) % get more ticks
sampleSize(1,1) = length(gpd_growth);

%% Unemployment rate (rate - monthly)
opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "FRED Graph"; % Specify sheet
opts.DataRange = "A12:B332"; % Specify range
opts.VariableNames = ["observation_date", "unemployment_rate"]; % Specify column names
opts.VariableTypes = ["datetime", "double"]; % Specify column types
opts = setvaropts(opts, "observation_date", "InputFormat", "yyyy-MM-dd"); % Specify variable properties
NorwayUnemploymentRate = readtable("../../data/NorwayUnemploymentRate.xls", opts, "UseExcel", false); % Import the data

subplot(3,2,2)
h = plot(NorwayUnemploymentRate.observation_date,NorwayUnemploymentRate.unemployment_rate);
title('Unemployment rate (monthly)')
xtickformat('yyyy-MMM')
set(h.Parent, 'XTick', NorwayUnemploymentRate.observation_date(4:20:end)) % get more ticks
sampleSize(1,2) = length(NorwayUnemploymentRate.unemployment_rate);

%% interest rates (rate - monthly)
opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "FRED Graph"; % Specify sheet
opts.DataRange = "A12:B523"; % Specify range
opts.VariableNames = ["observation_date", "interest_rate_3m"]; % Specify column names
opts.VariableTypes = ["datetime", "double"]; % Specify column types
opts = setvaropts(opts, "observation_date", "InputFormat", "yyyy-MM-dd"); % Specify variable properties
NorwayInterestRate3m = readtable("../../data/NorwayInterestRate3m.xls", opts, "UseExcel", false); % Import the data

opts.DataRange = "A12:B452"; % Specify range
opts.VariableNames = ["observation_date", "interest_rate_10yrs"]; % Specify column names
NorwayInterestRate10yrs = readtable("../../data/NorwayInterestRate10yrs.xls", opts, "UseExcel", false); % Import the data

subplot(3,2,3)
hold on;
h = plot(NorwayInterestRate10yrs.observation_date,NorwayInterestRate10yrs.interest_rate_10yrs);
plot(NorwayInterestRate3m.observation_date,NorwayInterestRate3m.interest_rate_3m);
legend('Interbank rate (3-month)','Long-term Govt bond (10yrs)')
title('interest rates (monthly)')
xtickformat('yyyy-MMM')
set(h.Parent, 'XTick', NorwayInterestRate3m.observation_date(4:30:end)) % get more ticks
hold off;
sampleSize(1,3) = length(NorwayInterestRate3m.interest_rate_3m);

%% Oslo Stock Exchange Benchmark Index (OSEBX:IND)
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["time", "OSEBXGR", "Var3"];
opts.SelectedVariableNames = ["time", "OSEBXGR"];
opts.VariableTypes = ["datetime", "double", "string"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "Var3", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var3", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "time", "InputFormat", "yyyy-MM-dd HH:mm");
NorwayOSEBXGR = readtable("../../data/NorwayOSEBXGR.csv", opts);

subplot(3,2,4)
h = plot(NorwayOSEBXGR.time,NorwayOSEBXGR.OSEBXGR);
title('Oslo Stock Exchange (index - daily)')
xtickformat('yyyy-MMM-dd')
set(h.Parent, 'XTick', NorwayOSEBXGR.time(1:400:end)) % get more ticks
sampleSize(1,4) = length(NorwayOSEBXGR.OSEBXGR);

%% Population (millions - yearly)
opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "FRED Graph"; % Specify sheet
opts.DataRange = "A12:B72"; % Specify range
opts.VariableNames = ["observation_date", "population"]; % Specify column names
opts.VariableTypes = ["datetime", "double"]; % Specify column types
opts = setvaropts(opts, "observation_date", "InputFormat", "yyyy-MM-dd"); % Specify variable properties
NorwayPopulation = readtable("../../data/NorwayPopulation.xls", opts, "UseExcel", false); % Import the data

subplot(3,2,5)
plot(NorwayPopulation.observation_date,NorwayPopulation.population./1e6)
title('Population (millions - yearly)')
xtickformat('yyyy')
sampleSize(1,5) = length(NorwayPopulation.population);

%% Real house prices (index - yearly)
opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "Composite house price indices";
opts.DataRange = "A15:B216";
opts.VariableNames = ["Year", "Real_House_Prices"];
opts.VariableTypes = ["string", "double"];
%opts = setvaropts(opts, "Year", "InputFormat", "yyyy"); % Specify variable properties
NorwayRealHousePrices = readtable("../../data/NorwayRealHousePrices.xlsx", opts, "UseExcel", false);
NorwayRealHousePrices.Year = datetime(NorwayRealHousePrices.Year,'InputFormat','yyyy');
subplot(3,2,6)
plot(NorwayRealHousePrices.Year,NorwayRealHousePrices.Real_House_Prices./1000)
title('Real house prices (in thousand, index - yearly)')
xtickformat('yyyy')
ylim([-1 25])
sampleSize(1,6) = length(NorwayRealHousePrices.Real_House_Prices);

%% Save as pdf
print(gcf, '../../plots/NorwayDataOverviewMatlab.pdf', '-dpdf', '-fillpage')

%% display sample sizes
%note that "..." enables you to continue writing the command in the next line
array2table(sampleSize,...
            'VariableNames',{'GDP Growth (q)',... 
                             'Unemployment (m)',...
                             'Interest Rates (m)',...
                             'Stock Exchange (d)',...
                             'Population (y)',...
                             'House prices (y)'})