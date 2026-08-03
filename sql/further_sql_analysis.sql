   WITH 
         ranked_trusts AS 
         ( SELECT
               t.trust_name,
               round(MAX(f.median_wait_weeks),2) AS max_median_wait_weeks,
               MAX(f.total_waiting) AS max_total_waiting,
               RANK() OVER (ORDER BY MAX(f.median_wait_weeks) DESC, MAX(f.total_waiting) DESC) AS rank
            FROM `nhs_analysis`.`nhs_waiting_list`.`fact_rtt_incomplete_star` f
            JOIN `nhs_analysis`.`nhs_waiting_list`.`dim_trust` t ON f.trust_key = t.trust_key
            WHERE f.median_wait_weeks IS NOT NULL
            AND f.total_waiting IS NOT NULL
            AND EXTRACT(YEAR FROM f.period_date) = 2021
            GROUP BY
               t.trust_name
         )
   SELECT
         trust_name,
         max_median_wait_weeks,
         max_total_waiting,
         rank
      FROM ranked_trusts
      WHERE rank <= 10
      ORDER BY
         rank;
         
         
         
         
        -- code 2
        WITH ranked_trusts AS (
  SELECT
    t.trust_name,
    MAX(f.total_waiting) AS max_total_waiting,
    MAX(f.median_wait_weeks) AS max_median_wait_weeks,
    RANK() OVER (ORDER BY MAX(f.total_waiting) DESC, MAX(f.median_wait_weeks) DESC) AS rank
  FROM
    `nhs_analysis`.`nhs_waiting_list`.`fact_rtt_incomplete_star` f
      JOIN `nhs_analysis`.`nhs_waiting_list`.`dim_trust` t
        ON f.trust_key = t.trust_key
  WHERE
    f.total_waiting IS NOT NULL
    AND f.median_wait_weeks IS NOT NULL
    AND EXTRACT(YEAR FROM f.period_date) = 2021
  GROUP BY
    t.trust_name
)
SELECT
  trust_name,
  max_total_waiting,
  max_median_wait_weeks,
  rank
FROM
  ranked_trusts
WHERE
  rank <= 10
ORDER BY
  rank;