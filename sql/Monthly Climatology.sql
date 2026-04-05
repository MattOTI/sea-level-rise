## Calculates the average GMSL for each calendar month across all years.
## Demonstrates seasonal cycle in the sea level record.

SELECT
  month,
  ROUND(AVG(gmsl_cm), 4) AS mean_gmsl_cm,
  ROUND(MIN(gmsl_cm), 4) AS min_gmsl_cm,
  ROUND(MAX(gmsl_cm), 4) AS max_gmsl_cm,
  COUNT(*) AS observations
FROM
  `sea_level_rise.gmsl_observations`
GROUP BY
  month
ORDER BY
  month ASC;