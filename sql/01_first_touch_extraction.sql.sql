CREATE OR REPLACE TABLE `funnel-analysis-project-503810.funnel_analysis.funnel_first_touch` as


with first_touch as (
  SELECT
  user_pseudo_id,
  event_name,
  MIN (TIMESTAMP_MICROS(event_timestamp)) as first_event_time
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  Where _table_suffix between '20201101' AND '20201130'
    AND event_name IN ('page_view', 'view_item', 'add_to_cart', 'begin_checkout', 'purchase')
  GROUP BY user_pseudo_id, event_name
)

SELECT
 user_pseudo_id,
  max(case when event_name = 'page_view' then first_event_time end) as t_page_view,
  max(case when event_name = 'view_item'then first_event_time end) as t_view_item, 
  max(case when event_name = 'add_to_cart'then first_event_time end) as t_add_to_cart, 
  max(case when event_name = 'begin_checkout'then first_event_time end) as t_begin_checkout, 
  max(case when event_name = 'purchase'then first_event_time end) as t_purchase
FROM first_touch
GROUP BY user_pseudo_id


