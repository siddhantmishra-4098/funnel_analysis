Create or replace table `funnel-analysis-project-503810.funnel_analysis.funnel_survival` as

Select 
  user_pseudo_id,
  ARRAY_AGG(traffic_source.medium order by event_timestamp asc limit 1) [offset(0)] as channel,
  ARRAY_AGG(device.category order by event_timestamp asc limit 1)[offset(0)] as device_category,
  Case
    when
      ARRAY_AGG((
        SELECT value.int_value 
        FROM UNNEST(event_params) 
        WHERE key = 'ga_session_number')ORDER BY event_timestamp asc limit 1)[offset(0)] = 1
        then 'new'
    else
      'returning'
  end as user_type
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
GROUP BY user_pseudo_id
