SELECT
  item.item_category AS category,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNT(*) AS event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
  AND event_name IN ('view_item', 'add_to_cart', 'purchase')
GROUP BY category
ORDER BY event_count DESC

#iteams + confounders
SELECT
  item.item_category AS category,
  traffic_source.medium AS channel,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
  AND event_name = 'view_item'
GROUP BY category, channel
ORDER BY category, users DESC

SELECT
  item.item_category AS category,
  device.category AS device,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
  AND event_name = 'view_item'
GROUP BY category, device
ORDER BY category, users DESC

# Traffic with device TYPE
SELECT
  traffic_source.medium AS channel,
  device.category AS device,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
  AND event_name = 'page_view'
GROUP BY channel, device
ORDER BY channel, users DESC

# Traffic with user TYPE
SELECT
  CASE
    WHEN (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_number') = 1
      THEN 'new'
    ELSE 'returning'
  END AS user_type,
  COUNT(DISTINCT CASE WHEN event_name = 'page_view' THEN user_pseudo_id END) AS page_view_users,
  COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_pseudo_id END) AS purchase_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
GROUP BY user_type