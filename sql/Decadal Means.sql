## Groups observations into decades and calculates the average GMSL per decade.
## Used for identifying acceleration in the rate of rise.

SELECT
  CASE
    WHEN year BETWEEN 1993 AND 2002 THEN '1993-2002'
    WHEN year BETWEEN 2003 AND 2012 THEN '2003-2012'
    WHEN year BETWEEN 2013 AND 2026 THEN '2013-2026'
  END AS decade,
  ROUND(AVG(gmsl_cm), 4) AS mean_gmsl_cm,
  ROUND(MIN(gmsl_cm), 4) AS min_gmsl_cm,
  ROUND(MAX(gmsl_cm), 4) AS max_gmsl_cm,
  COUNT(*) AS observations
FROM
  `sea_level_rise.gmsl_observations`
GROUP BY
  decade
ORDER BY
  decade ASC;