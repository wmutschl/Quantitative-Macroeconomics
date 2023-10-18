# Quantitative Macroeconomics

These are my course materials for the graduate course on Quantitative Macroeconomics taught at the University of Tübingen.
The compiled PDF materials are available under [Releases](https://github.com/wmutschl/Quantitative-Macroeconomics/releases).

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

* [ ] read the general course information
* [ ] have a look at the [exercises for week 1](https://github.com/wmutschl/Quantitative-Macroeconomics/releases/latest/download/week_1.pdf); we will do them together in class
* [ ] prepare your computer
  * [ ] install MATLAB R2023b following [this guide](https://uni-tuebingen.de/einrichtungen/zentrum-fuer-datenverarbeitung/dienstleistungen/clientdienste/software/matlab-einzelplatzlizenz/) if you are a student of the University of Tübingen
  * [ ] create an account on [GitHub.com](https://github.com/signup)
  * [ ] (optionally) sign up for the [GitHub Students Developer Pack](https://education.github.com/pack) to get a free Pro license for GitKraken (among other things)
  * [ ] (optionally) install the [GitKraken Client](https://gitkraken.com/download)  
* [ ] write down all your questions
* [ ] [schedule an online meeting](https://schedule.mutschler.eu) with me
  * [ ] put *"I am interested in this course"* under *"What is the meeting about?"*
  * [ ] check your emails and cancel the meeting again using the link in the email
  * [ ] now you know how easy it is to schedule a meeting with me :-)
* [ ] participate in the Q&A sessions

</details>

## Content

We cover modern theoretical macroeconomics (the study of aggregated variables such as economic growth, unemployment and inflation by means of structural macroeconomic models) and combine it with econometric methods (the application of formal statistical methods in empirical economics). We focus on the quantitative aspects and methods for solving and estimating the most prominent model classes in macroeconomics: Structural Vector Autoregressive (SVAR) and Dynamic Stochastic General Equilibrium (DSGE) models. Using these two model strands, the theoretical and methodological foundations of quantitative macroeconomics is taught. The students are thus enabled to understand the analyses and forecasts of public (universities, central banks, economic research institutes) as well as private (business banks, political consultations) research departments, but also to derive and empirically evaluate their own structural macroeconomic models.

As Quantitative Macroeconomics is highly computational, the course is interactive and *hands-on*, so there is no formal separation between the lecture and the exercise class. Each topic begins with a theoretical input and presentation of methods. These concepts are practiced directly thereafter by means of exercises and implemented on the computer in MATLAB and Dynare.

## Topics
- Fundamentals of macroeconomic time series data
- Autoregressive processes and dependent series
- Estimation methods for autoregressive processes (Ordinary Least Squares & Maximum Likelihood)
- Evaluation tools: Information criteria, specification tests, and bootstrap
- Multivariate time series data and Vector Autoregressive (VAR) models
- VAR model estimation (Ordinary Least Squares & Maximum Likelihood)
- Identification problem in Structural Vector Autoregressive (SVAR) models
- Recursive identification, short-rund and long-run restrictions in SVAR models
- Asymptotic and Bootstrap Inference in SVARs Identified By Exclusion Restrictions
- Introduction to Bayesian estimation and the Gibbs sampler
- Bayesian estimation of (S)VAR models and the Minnesota prior
- Narrative identification in SVAR models
- Local Projections
- Algebra of New Keynesian Models
- First-order perturbation of DSGE models
- Estimation of linearized DSGE models with Generalized/Simulated Method of Moments, Maximum Likelihood, and Bayesian Markov Chain Monte-Carlo techniques

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
