1. Standard Dose (SD) and High Dose (HD) of NA and HA (which are two envolope proteins which respond to antigen. We have the response to that antigen at Three different time points (at both SD and HD). The antigens we have are 
NA - H1N1, H3N2, B Phuket, B, HIVGP121. | HA- H1N1, H3N2, B Phuket and B. We have 4 groups of Young HIV+ , Young HIV-, OLD HIV+ and OLD HIV-. Timepoints are T0- Baseline prior to vaccination. T3- 21-28 days after vaccination, T4- 6 months after vaccination.
Everyone was given influenza vaccine, vaccine may have differed from year to year, keep in mind and control for that. 180 participants (100 HIV- 80 HIV+)
2. The question is - The individual protein-antigen response over time how does it change for each doseage and across time points
-> 1. Young HIV+ and HIV- Vs Old HIV+ and HIV- [4 groups)(SD and HD are seperate each protein-antigen is also seperately plotted, all timepoints in the same plot)
-> 1. Young Vs Old  [4 groups)(SD and HD are seperate each protein-antigen is also seperately plotted, all timepoints in the same plot)
-> HIV+ Vs HIV-  [4 groups)(SD and HD are seperate each protein-antigen is also seperately plotted, all timepoints in the same plot)
SD vs HD at each time point individually, split across all 4 groups
1. Does AGE predict response or is it a primary predictor of response ABOVE and BEYOND other variables
2. Does HD improve response vs SD. Id YES, which protein-antigen combinations does it help, and when controling for variables liek AGE and HIV
3.Decay of the response over time - does it change between groups (4 groups)
4.Foes T3 Titre corelate with Decay
For graphs - line graph with error bar?

nR=NR (Non-Responder). Fold Change above 4 from T3/T0 -> Responder
Vaccine Score -> some arbitarary value calculate bd by prab -> Score >4 responder 
5. Add Variable -> HAI Titre (FIXED EFFECT at each Time Point) How does HAI relate to HA and NA


Age as a Predictor:

To assess if age predicts response above and beyond other variables,
include it in your model and look at its significance and effect size. 
We can also use hierarchical regression models to see the change in variance explained when age is added to the model.

In a mixed-effects model, you have both fixed effects and random effects:

Fixed Effects: These are the effects of interest that you expect to be consistent across all individuals or groups. 
In your study, fixed effects might include the time points (T0, T3, T4), age group (Young, Old), HIV status (HIV+, HIV-), and vaccine dose (Standard Dose, High Dose).

Random Effects: These account for variations that are not captured by the fixed effects and can differ across individuals or groups. 
In your study, a random effect might be the individual participants, as each participant might have a unique baseline response or change over time that is not explained by the fixed effects.

Dependent Variable: This would be the antigen response for each measurement.

Fixed Effects: Include time points, age group, HIV status, vaccine dose, and possibly the interaction between these variables (e.g., time*vaccine dose).

Random Effects: At the very least, you would include a random intercept for each participant. This means that each participant has their own baseline level of the dependent variable. 
You might also consider random slopes, which allow the effect of time (or other variables of interest) to vary by individual.

Take extra group and compare SD of the same season. HD does it return to baseline????

PID | AGE Group | HIV Status |Race |Ethinicity |Age |Sex |Year SD| Year HD|-> Demographics
WV (SD) -> PID| WV T1|T2|T3|T4 SD
WV (SD) -> PID| WV T1|T2|T3|T4 HD
...
...
...
...
Antigen-SP Combinations
Isotypes Same Style
OTher Data
