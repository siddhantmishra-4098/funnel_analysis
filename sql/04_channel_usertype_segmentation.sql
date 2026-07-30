SELECT
  traffic_source.medium AS channel,
  CASE
    WHEN (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_number') = 1
      THEN 'new'
    ELSE 'returning'
  END AS user_type,
  COUNT(DISTINCT CASE WHEN event_name = 'page_view' THEN user_pseudo_id END) AS page_view_users,
  COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_pseudo_id END) AS purchase_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
GROUP BY channel, user_type
ORDER BY channel, user_type