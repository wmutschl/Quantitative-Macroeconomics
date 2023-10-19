Quantitative macroeconomics combines (i) modern theoretical macroeconomics
  (the study of aggregated variables such as economic growth, unemployment and inflation
  by means of structural macroeconomic models)
  with (ii) state-of-the-art econometric methods (the application of formal statistical methods in empirical economics).
To this end, we will focus on the two workhorse model frameworks, namely SVAR and DSGE,
  and develop the numerical procedures and algorithms required to estimate such models.
Very important: this course is \textbf{NOT ABOUT HOW TO BUILT} structural models,
  but it is \textbf{ABOUT HOW TO ESTIMATE} such models using real data.

This enables us to look at abstract macroeconomic concepts, for example:
\begin{itemize}
  \item Is uncertainty a source of business cycles or an endogenous response to them, and does the type of uncertainty matter?
  What are the effects on the real price of oil and on macroeconomic aggregates of
    oil supply shocks, shocks to the global demand for all industrial commodities,
    or demand shocks that are specific to the crude oil market?
  That is, we want to understand the propagation of shocks by means of an \textbf{impulse response analysis}.
  In other words, we want to \textbf{quantify} the dynamic effect of identified and economic meaningful shocks over time.
  For example:\\\includegraphics*[width=\textwidth]{plots/NarrativeSignRestrictionsIRFs.png}
  \item How important are monetary policy shocks as opposed to other shocks for movements in aggregate output?
  That is, we want to identify sources of fluctuations by means of a \textbf{variance decomposition}.
  In other words, we want to \textbf{quantify} how important a shock is on explaining the variation in the endogenous variables \textbf{on average}.
  For example:
  \begin{center}  
  \begin{tabular}{@{}llllll@{}}
  \toprule
                & \multicolumn{5}{c}{Shocks}                                      \\ \midrule
                & Monetary & Technology & Preference & Price markup & Wage markup \\
  Output growth & 4.8\%    & 22.3\%     & 57.1\%     & 8.0\%        & 7.1\%       \\
  Inflation     & 27.1\%   & 6.1\%      & 36.3\%     & 13.7\%       & 14.7\%      \\
  Nominal rate  & 5.0\%    & 0.4\%      & 72.3\%     & 9.8\%        & 11.8\%      \\
  Hours         & 0.4\%    & 0.8\%      & 70.0\%     & 17.6\%       & 9.6\%       \\
  Wage          & 0.1\%    & 0.1\%      & 73.6\%     & 12.0\%       & 12.8\%      \\ \bottomrule
  \end{tabular}
  \end{center}
  \item Has monetary policy changed in the early 1980s? Has it caused the 1982 recession?
  That is, we want to study how much a given structural shock explains the historically observed fluctuations in aggregate variables
    at every given point in time by means of a \textbf{historical decomposition}.    
  In other words, we want to \textbf{quantify} how important a shock was in driving the behavior of the endogenous variables in a \textbf{specific time period in the past}.
  For example:\\\includegraphics*[width=\textwidth]{plots/Historical-Decomposition-of-Aggregate-Hours-Worked.jpeg}
  \item To what extent would the financial crises have deepened if monetary policy had not responded to the output contraction at all?
  That is, we want to study \textbf{counterfactual policies}.
  \item How will inflation, growth and unemployment evolve over the next eight quarters?
  That is, we want to predict the values of variables in the future by means of a \textbf{forecast}.  
\end{itemize}

\paragraph*{Traditional Cowles Commission approach}
The prevailing econometric framework was initiated and developed in the 1950s to 1970s by the Cowles Commission by inventing
  many things such as indirect least squares, instrumental variable methods, the full and the limited information maximum likelihood methods.
Broadly speaking they developed the theory and toolkits (based on linear regressions) for estimating large-scale system of equations
  that have a certain structure that enables one to estimate these simultaneous equations one-by-one.
The IS-LM or AS-AD models are examples of such systems,
  where we have some underlying ad-hoc assumptions (e.g. consumption is always equal to a fraction of current output)
  that give us a reduced-form from which we can compute things like fiscal policy multipliers.
This reduced-form also enables us to estimate these parameters.
Of course, these models are useful for gaining intuition,
  but are quite limited for actual \textbf{quantitative} policy advise
  and analysis of how the whole economy responds to particular shocks or policies.
Nevertheless, these models were (and still are\footnote{
  More elaborated versions of such models are still in use at central banks and policy institutions under the label of semi-structural models.})
  empirically somewhat successful when measured in terms of forecast quality.
However, as the ultimate goal in macroeconomics is to gain policy insight and to actually understand the transmission channels,
  this approach came under heavy attack in the mid 1970s by (i) \textcite{Lucas_1976_EconometricPolicyEvaluation} and (ii) \textcite{Sims_1980_MacroeconomicsReality}:
\begin{itemize}
  \item Sims critique: many restrictions that are used to identify behavioral equations in these models are inconsistent with dynamic macroeconomic theories
  $\rightarrow$ (structural) vector autoregressions ((S)VAR)
  \item Lucas critique: models are unreliable for policy analysis
  because they are unable to predict effects of policy regime changes on the expectation formation of economic agents in a coherent manner
  $\rightarrow$ development of micro-founded structural models is necessary
\end{itemize}

\paragraph*{SVAR approach}
Pioneered by Christopher \textcite{Sims_1980_MacroeconomicsReality}.
The basic idea is to model all endogenous variables JOINTLY rather than one equation at a time.
This breaks with the traditional so-called Cowles Commission approach that relies on ad-hoc assumptions to do equation-by-equation estimation,
  which in essence generates implausible exogeneity assumptions (think about estimating the IS-LM model).
The underlying statistical framework is the vector autoregressive model,
  i.e. we do multivariate linear regressions of a vector of observables on its own lags and (possibly) other variables such as a constant, trends or exogenous variables.
Importantly, we have cross-equation constraints that are jointly modeled and estimated.
This is the VAR framework.

Now adding the \textbf{S} to \textbf{VAR} means to add structure on the cross-equation restrictions,
  in order to differentiate between correlation and causation.
The basic idea is to decompose the forecast errors (i.e. the residuals) into so-called structural shocks
  that are mutually uncorrelated and have an economic interpretation (supply shocks, demand shocks, risk shocks, monetary policy shocks, rare disaster shocks, etc.).
More precisely, instead of given every parameter in the VAR model a behavioral interpretation,
  we make explicit identifying assumptions to isolate estimates of policy and/or private agent's behavior
  and its effects on the economy while keeping the model free of many additional restrictive assumptions.  
In principle, this enables us to analyze the causal effects of these structural shocks on the model variables by all kinds of objectives.
But of course, it all depends on the validity of the identifying assumptions.
Typically, these stem from institutional knowledge, economic theory or other extraneous constraints on the model responses.
Most of the recent literature is primarily concerned with finding new and more compelling identifying assumptions (or methods),
in order to consolidate or challenge known results.
The upside of the SVAR approach is that ideally, with very few assumptions about the structure of the economy, 
  we get meaningful and, above all, data-based results.

\paragraph*{DSGE approach}
DSGE models use modern macroeconomic theory to explain and predict co-movements of aggregate time series.
DSGE models start from what we call the micro-foundations of macroeconomics
  (i.e. to be consistent with the underlying behavior of economic agents),
  with a heart based on the rational expectation forward-looking economic behavior of agents.
The dynamic equilibrium is the result from the combination of economic decisions taken by all economic agents.
For example the following agents or sectors are commonly included:
\begin{itemize}
  \item Households: benefit from private consumption, leisure and possibly other things like money holdings or state services;
    subject to a budget constraint in which they finance their expenditures 
    via (utility-reducing) work, renting capital and buying (government) bonds
    $\hookrightarrow$ maximization of utility
  \item Firms produce a variety of products with the help of rented equipment (capital) and labor.
  They (possibly) have market power over their product and are responsible for
    the design, manufacture and price of their products.
    $\hookrightarrow$ cost minimization or profit maximization
  \item Monetary policy follows a feedback rule, so-called Taylor rule, for instance: 
    nominal interest rate reacts to deviations of the current (or lagged) inflation rate
    from its target and of current output from potential output
  \item Fiscal policy (the government) collects taxes from households and companies 
    in order to finance government expenditures (possibly utility-enhancing) 
    and government investment (possibly productivity-enhancing).
    In addition, the government can issue debt securities and might face a probability of sovereign default.
  \item There is no limitation, i.e. you can also add other sectors (financial, trade, R\&D, etc).
\end{itemize}
 We then mathematically solve these problems under uncertainty,
   because we add stochastic processes to the system of equations. 
\begin{itemize}
  \item General Equilibrium (GE): equations must always hold.
  \\
  Short-run: decisions, quantities and prices adjust such that equations are full-filled.
  \\
  Long-run: steady-state, i.e. a condition or situation where variables do not change their value 
  (e.g. balanced-growth path where the rate of growth is constant). 
  \item Stochastic (S): disturbances (or shocks) make the system deviate from its steady-state, 
  we get business cycles or, more general, a data-generating process
  \item Dynamic (D): Agents are forward-looking and solve intertemporal optimization problems. 
  When a disturbance hits the economy, macroeconomic variables do not return to equilibrium instantaneously, 
    but change very slowly over time, producing complex reactions. 
  Furthermore, some decisions like investment or saving only make sense in a dynamic context.
  We can analyze and quantify the effects after
		(i) a temporary shock: how does the economy return to its steady-state, or 
		(ii) a permanent shock: how does the economy move to a new steady-state.
\end{itemize}
DSGE models are intensively used in policy making e.g. by central banks they play a central role in providing an analytical foundation for the decision making.
They have become the standard modelling framework in modern macroeconomic research.
They often serve as a macroeconomic laboratory that allows to analyze how economic agents respond to changes in their environment
  as all variables are determined simultaneously and endogenously given a sound micro-founded theoretical setting.
Real business cycle (RBC) models, New Keynesian models, and asset pricing models
  all belong to this very general modelling class.

Estimating such models is a very challenging task as one has to first find a reduced-form suitable for estimation.
The upside, however, is that ideally, with suitable solution and estimation techniques,
  we have a clear theoretical foundation for our empirical results that enable clear understanding of transmissions channels and policy advise.

\paragraph*{Challenges in Quantitative Macroeconomics}
\begin{itemize}
  \item Macroeconomic time series are indicative of nonlinearities, non-Gaussianity and time-varying volatility.  
  \item Model specification: How to select the \enquote{right} model, how to cope with misspecification?
  \item SVAR
  \begin{itemize}
    \item many free parameters to estimate, need plausible identifying restrictions
    \item sensitive to the identification restrictions used
    \item risk of specification search: researchers look for reasonable answers or puzzles under the cloak of formal statistical inference
  \end{itemize}  
  \item DSGE
  \begin{itemize}
    \item trade-off between theoretical coherence and empirical fit
    \item heavily aggregated and stylized, require a lot of modelling assumptions
    \item solving DSGE models requires knowledge in computational eocnomics
  \end{itemize} 
  \item computational implementation is in both cases often cumbersome and challenging  
\end{itemize}
Despite the challenges and current developments,
  SVAR and DSGE models continue to be the fundamental tools in current macroeconomic analysis.
Be warned: there is quite the investment one needs to undergo to study quantitative macroeconomics
  and there is a huge component of self-teaching involved,
  because most of us lack the required background in econometrics, mathematics, numerics and statistics.
In fact, most macroeconomists doing research in this area are more or less self-taught (I can attest to this for myself),
  or come from a related field.