[![Build LaTeX](../../actions/workflows/latex.yml/badge.svg)](../../actions/workflows/latex.yml)
[![Run MATLAB](../../actions/workflows/matlab.yml/badge.svg)](../../actions/workflows/matlab.yml)
# Quantitative Macroeconomics

These are my course materials for the graduate course on Quantitative Macroeconomics taught at the University of Tübingen.

The compiled PDF materials are available under [Releases](https://github.com/wmutschl/Quantitative-Macroeconomics/releases) (make sure to click *Show all assets*).

Please feel free to use this for teaching or learning purposes; however, taking into account the [GPL 3.0 license](https://choosealicense.com/licenses/gpl-3.0/).

## Schedule with To-Do Lists

<details>
  <summary>Week 1: Introductions</summary>

### Goals

* understand what Quantitative Macroeconomics is about
* decide whether you want to take the course
* prepare your computer for the course with MATLAB or Octave
* do your first steps in MATLAB or Octave
* (optionally) install GitKraken and do your first steps with git

### To Do

* [x] read the general course information.
* [x] have a look at the [exercises for week 1](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_1.pdf); we will do them together in class
* [x] prepare your computer
  * [x] install MATLAB R2023b following [this guide](https://uni-tuebingen.de/einrichtungen/zentrum-fuer-datenverarbeitung/dienstleistungen/clientdienste/software/matlab-einzelplatzlizenz/) if you are a student of the University of Tübingen
  * [x] watch [Introduction to MATLAB](https://youtu.be/_CbLr11aeQ4)
  * [x] (optionally) create an account on [GitHub.com](https://github.com/signup)
  * [x] (optionally) sign up for the [GitHub Students Developer Pack](https://education.github.com/pack) to get a free Pro license for GitKraken (among other things)
  * [x] (optionally) install the [GitKraken Client](https://gitkraken.com/download)  
* [x] write down all your questions
* [x] [schedule an online meeting](https://schedule.mutschler.eu) with me
  * [x] put *"I am interested in this course"* under *"What is the meeting about?"*
  * [x] check your emails and cancel the meeting again using the link in the email
  * [x] now you know how easy it is to schedule a meeting with me :-)
* [x] participate in the Q&A sessions

</details>

<details>
  <summary>Week 2: Time series data and fundamental concepts</summary>

### Goals

* learn how to obtain macroeconomic data from different sources
* learn how to visualize macroeconomic time series data and do some basic descriptive statistics with MATLAB
* learn about different frequencies and what they can be useful for
* understand the concept of a white noise process
* get intuition about stationarity, autocovariance function, lag-operator, conditional and unconditional moments
* simulate white noise processes and moving-averages in MATLAB

### To Do

* [x] review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_1.pdf) and write down all your questions
* [x] read Bjørnland and Thorsrud (2015, Ch.1 and Ch.2) and Lütkepohl (2004, Sec. 2.1, 2.2, 2.3). Make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand
* [x] do exercises 1 and 2, write down all your questions and problems; we'll do exercise 3 in class
* [x] participate in the Q&A sessions with all your questions and concerns
* [x] for immediate help: [schedule a meeting](https://schedule.mutschler.eu)
* [x] (optionally) checkout the short [Beginner Git Video Tutorials from GitKraken](https://www.gitkraken.com/learn/git/tutorials#beginner)

</details>

<details>
  <summary>Week 3: Dependent time series data and the autoregressive process</summary>

### Goals

* understand the concept of an AR(1) and AR(p) process
* get intuition about the law of large numbers and the central limit theorem
* visualize the law of large numbers and the central limit theorem for dependent data using Monte Carlo simulations

### To Do

* [x] review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_2.pdf) and write down all your questions.
* [x] read Lütkepohl (2004, Sec. 2.2, 2.3, 2.5.2), Lütkepohl (2005, Appendix C) and Bjørnland and Thorsrud (2015, Ch.1 and Ch.2); make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand
* [x] prepare exercise sheet 3: do exercises 1 and 3 at home, we'll do exercises 2 and 4 in class
* [x] participate in the Q&A sessions with all your questions and concerns
* [x] for immediate help: [schedule a meeting](https://schedule.mutschler.eu)
* [x] (optionally) checkout the short [Intermediate Git Video Tutorials from GitKraken](https://www.gitkraken.com/learn/git/tutorials#intermediate)

</details>

<details>
  <summary>Week 4: Ordinary Least Squares (OLS) and Maximum Likelihood (ML) estimation of the autoregressive process</summary>

### Goals

* review OLS and ML for the AR(p) process
* implement OLS and ML estimation of the AR(p) process

### To Do

* [x] review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_3.pdf) and write down all your questions
* [x] read Lütkepohl (2004); make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand
* [x] TRY (!!!) to do exercise sheet 4; particularly, create your own ARpOLS.m and ARpML.m functions
* [x] participate in the Q&A sessions with all your questions and concerns
* [x] for immediate help: [schedule a meeting](https://schedule.mutschler.eu)
* [x] (optionally) checkout the short [Advanced Git Video Tutorials from GitKraken](https://www.gitkraken.com/learn/git/tutorials#advanced)

</details>

<details>
  <summary>Week 5: Information Criteria, Specification Tests, and Bootstrap</summary>

### Goals

* understand the intuition of information criteria, specification tests and the bootstrap
* implement simple examples for information criteria, specification tests and the bootstrap for the univariate AR(p) process

### To Do

* [x] review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_4.pdf) and write down all your questions
* [x] re-read Lütkepohl (2004) and quickly go through Kilian and Lütkepohl (2007, Ch. 12.2); make note of all the aspects and concepts that you are still not familiar with or that you find difficult to understand
* [x] TRY (!!!) to do exercises 1 and 2 of the problem set for week 5; we will do exercise 3 in class (see this [video](https://youtu.be/Itf-8Cp4xHI))
* [x] participate in the Q&A sessions with all your questions and concerns
* [x] for immediate help: [schedule a meeting](https://schedule.mutschler.eu)
* [x] (optionally) fork the course repository on GitHub

</details>

<details>
  <summary> Week 6: Multivariate Time Series Concepts</summary>

### Goals

Familiarize yourself with

* important matrix concepts such as Eigenvalues, Kronecker product, orthogonality, rotation matrices, Cholesky decomposition and Lyapunov equations
* multivariate notation and dimensions of vectors and matrices for VAR(p) models
* autocovariances, stability and covariance-stationarity in multivariate VAR(p) models
* the companion form

### To Do

* [x] Review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_5.pdf) (except the bootstrap one) and write down all your questions
* [x] Read Kilian and Lütkepohl (2007, Ch. 2.2) and Lütkepohl (2005, Chapter 2 and Appendix A); make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand
* [x] Do exercise sheet 6 (the solutions are already available)
* [x] If you have questions, get in touch with me via email or (better) [schedule a meeting](https://schedule.mutschler.eu)

</details>

<details>
  <summary> Week 7: Estimating VAR model with OLS and ML; The identification problem in SVAR models</summary>

### Goals

* estimate VAR models with Ordinary Least Squares (OLS) and Maximum Likelihood (ML)
* understand the identification problem in SVAR models

### To Do

* [x] Review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_6.pdf) and write down all your questions
* [x] Read Kilian and Lütkepohl (2007, Ch. 2.3 and Ch. 2.6); make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand
* [x] Do exercises 1 and 2 of problem set 7; we will do exercise 3 in class
* [x] If you have questions, get in touch with me via email or (better) [schedule a meeting](https://schedule.mutschler.eu)

</details>

<details>
  <summary> Week 8: Short-run restrictions in Structural Vector Autoregressive (SVAR) Models</summary>

### Goals

* understand recursive identification, short-run restrictions and the impact matrix
* implement recursive identification both via Cholesky or numerical optimization
* implement short-run restrictions using numerical optimization

### To Do

* [x] Review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_7.pdf) and write down all your questions
* [x] Read Kilian and Lütkepohl (2007, Ch. 4.1, Ch. 7.6, Ch.8, Ch.9); make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand
* [x] Do exercises 1 and 2 from problem set 8; we will do exercise 3 in class
* [x] If you have questions, get in touch with me via email or (better) [schedule a meeting](https://schedule.mutschler.eu)

</details>


<details>
  <summary> Week 9: Short-run and Long-run restrictions in Structural Vector Autoregressive (SVAR) Models, Asymptotic and Bootstrap Inference in SVARs Identified By Exclusion Restrictions: Theory</summary>

### Goals

* understand long-run restrictions and the long-run multiplier matrix
* implement short-run and long-run restrictions using numerical optimization
* understand pros and cons of asymptotic inference for the impulse-response function of SVAR models
* understand pros and cons of bootstrap inference for the impulse-response function of SVAR models

### To Do

* [x] Review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_8.pdf) and write down all your questions
* [x] Read Kilian and Lütkepohl (2007, Ch. 4.1, Ch. 7.6, Ch.8, Ch.9, Ch.10.1, 10.3, 10.4, 10.5, 11.1, 11.2, 11.3). Make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand.
* [x] Do exercises 1 and 2 of problem set 9
* [x] If you have questions, get in touch with me via email or (better) [schedule a meeting](https://schedule.mutschler.eu)

</details>


<details>
  <summary> Week 10: Bootstrap Inference in SVARs Identified By Exclusion Restrictions</summary>

### Goals

* implement and compare asymptotic and bootstrap standard deviations of structural IRFs
* implement and compare asymptotic and bootstrap confidence intervals of structural IRFs

### To Do

* [ ] Review the solutions of [last week's exercises](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_9.pdf) and write down all your questions
* [ ] Read Kilian and Lütkepohl (2007, Ch. 12.1-12.5, Ch. 12.9). Make note of all the aspects and concepts that you are not familiar with or that you find difficult to understand.
* [ ] We will do the exercises in class.
* [ ] If you have questions, get in touch with me via email or (better) [schedule a meeting](https://schedule.mutschler.eu)

</details>

## Content

We cover modern theoretical macroeconomics (the study of aggregated variables such as economic growth, unemployment and inflation by means of structural macroeconomic models) and combine it with econometric methods (the application of formal statistical methods in empirical economics). We focus on the quantitative aspects and methods for solving and estimating the most prominent model classes in macroeconomics: Structural Vector Autoregressive (SVAR) and Dynamic Stochastic General Equilibrium (DSGE) models. Using these two model strands, the theoretical and methodological foundations of quantitative macroeconomics is taught. The students are thus enabled to understand the analyses and forecasts of public (universities, central banks, economic research institutes) as well as private (business banks, political consultations) research departments, but also to derive and empirically evaluate their own structural macroeconomic models.

As Quantitative Macroeconomics is highly computational, the course is interactive and *hands-on*, so there is no formal separation between the lecture and the exercise class. Each topic begins with a theoretical input and presentation of methods. These concepts are practiced directly thereafter by means of exercises and implemented on the computer in MATLAB and Dynare.

## Topics

#### Time Series Analysis
- Fundamentals of macroeconomic time series data
- Autoregressive processes and dependent series
- Estimation methods for autoregressive processes (Ordinary Least Squares & Maximum Likelihood)
- Evaluation tools: Information criteria, specification tests, and bootstrap
- Multivariate time series and Vector Autoregressive (VAR) models
- VAR model estimation (Ordinary Least Squares & Maximum Likelihood)

#### Structural Vector Autoregressive (SVAR) Models
- Identification problem in Structural Vector Autoregressive (SVAR) models
- Recursive identification, short-run and long-run restrictions in SVAR models
- Asymptotic and Bootstrap Inference in SVARs Identified By Exclusion Restrictions
- Introduction to Bayesian estimation and the Gibbs sampler
- Bayesian estimation of (S)VAR models and the Minnesota prior
- Narrative identification in SVAR models
- Local Projections

#### Dynamic Stochastic General Equilibrium (DSGE) Models
- Algebra of RBC and New Keynesian Models
- First-order perturbation of DSGE models
- Generalized/Simulated Method of Moments
- Kalman Filter and Smoother
- Maximum Likelihood
- Bayesian Markov Chain Monte-Carlo (MCMC) techniques
  - Random-Walk Metropolis Hastings
  - Slice Sampling

## Case Studies and Replications (TBA)

## Learning target

Students acquire knowledge of advanced methods of quantitative research in the field of modern macroeconomics. This knowledge is relevant for the realization of a wide variety of macroeconomic research projects and is applied in central banks, ministries, research institutes (e.g. DIW, ifo, IfW, IWH, RWI) and research departments of international organizations (e.g. IMF, World Bank). Upon successful completion of this module, students are prepared to work in these areas. At the same time, the module prepares students for the requirements of a quantitatively oriented macroeconomic dissertation.

The gained methodological skills enable a precise understanding and largely independent empirical analysis of the most important model classes in quantitative macroeconomics. Students are familiar with a variety of examples and situations in which quantitative thinking is useful in explaining abstract macroeconomic phenomena. They recognize and appreciate the connections between theory and evidence and use their training to find possible avenues of research. While constructing abstract models, they identify appropriate economic and statistical tools and evaluate their strengths and weaknesses in the context of problem solving. They utilize computers and software effectively as tools for solving and estimating macroeconomic models. In addition, because students work on the problem sets as a team, students' coordination, organization, and communication skills are enhanced.

## Requirements

Basic undergraduate knowledge of macroeconomics as well as econometrics are required, programming skills in a scripting language are advantageous, but not necessary.

## Software used

* [MATLAB](https://mathworks.com) or [Octave](https://octave.org)
* [Dynare](https://www.dynare.org)

## Getting Involved
If you spot mistakes, let me know by opening an issue or write me an email to [willi@mutschler.eu](mailto:willi@mutschler.eu).
Moreover, solutions to the exercises in other computer languages (e.g. Julia, Python or R) are highly appreciated.
Please sent me those either [via email](mailto:willi@mutschler.eu) or (better) open a pull request.
