-- 04_attribution.sql
WITH events AS (
  SELECT
    user_id, event_time, event_name, revenue, utm_source, utm_medium, utm_campaign
  FROM `project.dataset.raw_events`
  WHERE event_name IN ('session_start','product_view','add_to_cart','begin_checkout','purchase')
),

-- identify last non-null UTM for each purchase
purchase_attribution AS (
  SELECT
    e.* EXCEPT(row_num),
    ARRAY_REVERSE_AGG(STRUCT(utm_source, utm_medium, utm_campaign) IGNORE NULLS)[OFFSET(0)] AS last_utm
  FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY TIMESTAMP(event_time) DESC) AS row_num
    FROM events
    WHERE event_name = 'purchase'
  ) e
  GROUP BY e.user_id, e.event_time, e.revenue
)

SELECT
  last_utm.utm_source AS utm_source,
  last_utm.utm_medium AS utm_medium,
  last_utm.utm_campaign AS utm_campaign,
  COUNT(1) AS purchases,
  SUM(revenue) AS revenue,
  AVG(revenue) AS avg_order_value
FROM purchase_attribution
GROUP BY last_utm.utm_source, last_utm.utm_medium, last_utm.utm_campaign
ORDER BY revenue DESC
LIMIT 50;
