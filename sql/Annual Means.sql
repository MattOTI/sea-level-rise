## Calculates the average GMSL for each calendar year.
## Provides a quick insight into the long-term trend.

SELECT
  year,
  ROUND(AVG(gmsl_cm), 4) AS mean_gmsl_cm,
  ROUND(AVG(gmsl_smoothed_cm), 4) AS mean_gmsl_smoothed_cm,
  COUNT(*) AS observations
FROM
  `sea_level_rise.gmsl_observations`
GROUP BY
  year
ORDER BY
  year ASC;
