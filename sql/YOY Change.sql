## Compares each year's mean GMSL against the previous year.
## Highlights periods of faster rise within the record.

SELECT
  current_year.year,
  ROUND(current_year.mean_gmsl_cm, 4) AS mean_gmsl_cm,
  ROUND(current_year.mean_gmsl_cm - previous_year.mean_gmsl_cm, 4) AS yoy_change_cm
FROM
  (SELECT year, AVG(gmsl_cm) AS mean_gmsl_cm
   FROM `sea_level_rise.gmsl_observations`
   GROUP BY year) AS current_year
LEFT JOIN
  (SELECT year, AVG(gmsl_cm) AS mean_gmsl_cm
   FROM `sea_level_rise.gmsl_observations`
   GROUP BY year) AS previous_year
  ON current_year.year = previous_year.year + 1
ORDER BY
  current_year.year ASC;