CREATE OR REPLACE TABLE `funnel-analysis-project-503810.funnel_analysis.funnel_sequential` AS
SELECT
  user_pseudo_id,
  t_page_view,
  CASE 
    WHEN t_view_item > t_page_view THEN t_view_item 
  END AS t_view_item_seq,
  CASE 
    WHEN t_add_to_cart > t_view_item AND t_view_item > t_page_view THEN t_add_to_cart 
  END AS t_add_to_cart_seq,
  CASE 
    WHEN t_begin_checkout > t_add_to_cart AND t_add_to_cart > t_view_item AND t_view_item > t_page_view THEN t_begin_checkout 
  END AS t_begin_checkout_seq,
  CASE 
    WHEN t_purchase > t_begin_checkout AND t_begin_checkout > t_add_to_cart AND t_add_to_cart > t_view_item AND t_view_item > t_page_view THEN t_purchase 
  END AS t_purchase_seq
FROM `funnel-analysis-project-503810.funnel_analysis.funnel_first_touch`
