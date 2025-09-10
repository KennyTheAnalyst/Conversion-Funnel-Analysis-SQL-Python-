-- 02_funnel_counts.sql
-- Assumes table: `project.dataset.raw_events`

WITH events AS (
  SELECT
    user_id,
    session_id,
    event_name,
    TIMESTAMP(event_time) AS event_ts,
    revenue
  FROM `project.dataset.raw_events`
),

session_step AS (
  SELECT
    session_id,
    MIN(CASE WHEN event_name = 'session_start' THEN event_ts END) AS ts_session_start,
    MIN(CASE WHEN event_name = 'product_view' THEN event_ts END) AS ts_product_view,
    MIN(CASE WHEN event_name = 'add_to_cart' THEN event_ts END) AS ts_add_to_cart,
    MIN(CASE WHEN event_name = 'begin_checkout' THEN event_ts END) AS ts_begin_checkout,
    MIN(CASE WHEN event_name = 'purchase' THEN event_ts END) AS ts_purchase,
    ANY_VALUE(user_id) AS user_id
  FROM events
  GROUP BY session_id
),

funnel_counts AS (
  SELECT
    COUNT(DISTINCT session_id) AS sessions_total,
    COUNT(DISTINCT CASE WHEN ts_product_view IS NOT NULL THEN session_id END) AS sessions_product_view,
    COUNT(DISTINCT CASE WHEN ts_add_to_cart IS NOT NULL THEN session_id END) AS sessions_add_to_cart,
    COUNT(DISTINCT CASE WHEN ts_begin_checkout IS NOT NULL THEN session_id END) AS sessions_begin_checkout,
    COUNT(DISTINCT CASE WHEN ts_purchase IS NOT NULL THEN session_id END) AS sessions_purchase
  FROM session_step
)

SELECT
  sessions_total,
  sessions_product_view,
  sessions_add_to_cart,
  sessions_begin_checkout,
  sessions_purchase,
  SAFE_DIVIDE(sessions_product_view, sessions_total) AS rate_session_to_product,
  SAFE_DIVIDE(sessions_add_to_cart, sessions_product_view) AS rate_product_to_cart,
  SAFE_DIVIDE(sessions_begin_checkout, sessions_add_to_cart) AS rate_cart_to_checkout,
  SAFE_DIVIDE(sessions_purchase, sessions_begin_checkout) AS rate_checkout_to_purchase,
  SAFE_DIVIDE(sessions_purchase, sessions_total) AS overall_conversion_rate
FROM funnel_counts;
