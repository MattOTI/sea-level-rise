# Case Study: Global Sea Level Rise
### Google Data Analytics Professional Certificate Capstone Project

---

## Scenario

As a junior data analyst working for a business intelligence consultant, I was asked to lead an independent project. I selected global mean sea level rise as my topic, motivated by its direct relevance to oceanography, climate policy, and risk management.

---

## Ask

**Business task:** Quantify the long-term trend in global mean sea level rise using satellite altimetry data, assess whether the rate of rise is accelerating, and project future sea level to 2050 and 2100 with associated uncertainty, benchmarked against IPCC AR6 likely ranges.

**Key factors:**
- Is the long-term rate of rise statistically significant?
- Is the rate accelerating over the satellite record?
- What is the projected sea level by 2050 and 2100, and how uncertain is that projection?
- How do the projections compare to established IPCC AR6 scenarios?

**Stakeholders:** Climate scientists, marine data organisations, coastal planners, and policymakers requiring evidence-based sea level projections for infrastructure and adaptation planning.

**Metrics:** Rate of rise (mm/year), R², Durbin-Watson statistic, 95% confidence intervals, decadal acceleration, IPCC AR6 scenario comparison at 2050 and 2100.

---

## Prepare

**Data source:** NASA-SSH Global Mean Sea Level Indicator, Version 1. Produced by the JetPropulsion Laboratory, California Institute of Technology. Distributed via NASA Physical Oceanography DAAC (PO.DAAC).

**Citation:** NASA-SSH. 2025. SSH Global Mean Sea Level from Simple Gridded Sea Surface Height. PO.DAAC, CA, USA. Dataset accessed 2026-03-22 at https://doi.org/10.5067/NSIND-GMSV1

**Organisation:** A single ASCII text file containing a weekly time series of three columns i.e. decimal year, raw GMSL (cm), and 60-day smoothed GMSL (cm). This data spans from January 1993 to March 2026, with HDR header rows preceding the data.

**ROCCC assessment:**
- **Reliable:** Produced by NASA JPL using reference satellite altimeter missions (TOPEX/Poseidon, Jason-1/2/3, Sentinel-6)
- **Original:** Primary observational data, not aggregated from secondary sources
- **Comprehensive:** Continuous 33-year global record at weekly resolution
- **Current:** Updated to within approximately two weeks of present
- **Cited:** Full user guide and DOI provided by PO.DAAC

**Licensing:** Open access. Acknowledgement required per user guide. Data preparation carried out in part at the Jet Propulsion Laboratory, California Institute of Technology, under contract with NASA (80NM0018D0004).

**Known limitations:** The GMSL estimate has not been adjusted for Glacial Isostatic Adjustment (GIA). Maps are computed using 10 days of observations but updated every 7 days, introducing minor overlap between successive timesteps.

---

## Process

**Tools:** Python 3 (pandas, NumPy, SciPy, statsmodels, matplotlib) in VS Code with Jupyter Notebooks. BigQuery and SQL for temporal aggregation.

**Cleaning steps:**
1. Skipped all HDR header lines during file parsing
2. Replaced missing value flags (9.96921E36) with NaN. No missing values were present in the downloaded record
3. Converted decimal year format to Python datetime objects, extracting year and month as integer columns
4. Confirmed 1,723 observations with no nulls across all columns
5. Exported a clean CSV (`gmsl_clean.csv`) for upload to BigQuery

**Integrity verification:** Row count matched expected weekly cadence across 33 years. Date range confirmed as 1993-01-04 to 2026-03-23. No duplicate dates detected.

---

## Analyze

**Python analysis (see `notebooks/sea_level_analysis.ipynb`):**

- OLS linear regression established a long-term rate of rise of **3.099 mm/year** (R² = 0.96)
- Durbin-Watson statistic of 0.0413 confirmed strong positive autocorrelation in OLS residuals
- GLSAR(52) correction inflated standard errors by a factor of 15.6x, yielding a corrected rate of **3.236 mm/year**
- Decadal analysis revealed acceleration from **2.826 mm/year** (1993-2002) to **3.544 mm/year** (2013-2026), a 25% increase within the satellite record
- Residual analysis independently confirmed non-linearity, validating a quadratic model
- Quadratic fit with 52-week block bootstrap (1,000 iterations) projected **22.2 cm** (95% CI: 21.3-24.3 cm) above the 1993 baseline by 2050, and **57.3 cm** (95% CI: 52.5-68.8 cm) by 2100
- Seasonal amplitude analysis found no statistically significant trend (p = 0.12), consistent with the acceleration finding

**SQL analysis in BigQuery (see `sql/`):**

- Annual mean GMSL calculated across the full record
- Decadal mean, min, and max GMSL quantified across three periods
- Monthly climatology isolated the seasonal cycle across all years
- Year-on-year change highlighted periods of faster and slower rise

---

## Share

**Visualisations produced (see `images/`):**

- `gmsl_historical.png` — full GMSL time series with OLS and GLSAR trend lines
- `residual_comparison.png` — OLS vs GLSAR residuals illustrating autocorrelation correction
- `acf_residuals.png` — ACF plot confirming autocorrelation structure
- `gmsl_projection.png` — quadratic projection to 2100 with bootstrap confidence interval
- `gmsl_ipcc_comparison.png` — projections benchmarked against IPCC AR6 scenarios
- `amplitude_analysis.png` — seasonal amplitude over time

**Audience:** Marine scientists and data organisations, climate policy teams, and coastal planners. Findings are presented with full statistical context for technical audiences, with plain-language conclusions accessible to non-specialists.

**Key finding:** The satellite record shows a statistically significant and accelerating rate of sea level rise. Projections to 2050 are consistent with the IPCC AR6 SSP1-1.9 (very low emissions) likely range, suggesting current trends align with lower-end scenarios — though the widening uncertainty interval to 2100 reflects the limitations of purely observational extrapolation.

---

## Act

**Final conclusions:**
- Global mean sea level has risen at a statistically significant rate of 3.236 mm/year across the 33-year satellite record, with clear evidence of acceleration
- Without modelling future emissions or ice sheet dynamics, observational extrapolation alone projects approximately 22 cm of rise by 2050
- Current trends are broadly consistent with IPCC AR6 lower-emission scenarios, though long-range projections carry substantial uncertainty

**How stakeholders can apply these insights:**
- Marine data organisations can use this methodology as a baseline for regional sea level monitoring and anomaly detection
- Coastal planners can use the 2050 projection range (21.3-24.3 cm) as a conservative near-term planning benchmark
- Climate policy teams can reference the acceleration finding as evidence for emissions reduction urgency

**Recommended next steps:**
- Incorporate regional sea level data from the NASA-SSH gridded product to identify areas of above-average rise
- Apply formal seasonal decomposition to separate trend, seasonal, and residual components
- Integrate ENSO signal extraction to quantify interannual variability
- Extend the BigQuery SQL layer to support automated monthly updates as new data is released

**Additional data that could expand findings:**
- NASA-SSH gridded SSH product for regional basin-level analysis
- GRACE/GRACE-FO ice sheet mass loss data for attribution of acceleration
- Tide gauge records for pre-satellite era context

---

*This case study was completed as part of the Google Data Analytics Professional Certificate.
Full analysis available at: [github.com/MattOTI/sea-level-rise](https://github.com/MattOTI/sea-level-rise)*
