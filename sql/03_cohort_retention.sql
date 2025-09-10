-- 03_cohort_retention.sql
WITH events AS (
  SELECT
    user_id,
    TIMESTAMP(event_time) AS event_ts,
    DATE(TIMESTAMP(event_time)) AS event_date
  FROM `project.dataset.raw_events`
),

first_session AS (
  SELECT user_id, MIN(event_date) AS cohort_date
  FROM events
  GROUP BY user_id
),

user_activity AS (
  SELECT
    e.user_id,
    f.cohort_date,
    DATE_DIFF(e.event_date, f.cohort_date, WEEK) AS week_offset
  FROM events e
  JOIN first_session f USING(user_id)
),

cohort AS (
  SELECT
    cohort_date,
    week_offset,
    COUNT(DISTINCT user_id) as users_active
  FROM user_activity
  WHERE week_offset BETWEEN 0 AND 11
  GROUP BY cohort_date, week_offset
),

cohort_sizes AS (
  SELECT cohort_date, COUNT(DISTINCT user_id) as cohort_size
  FROM first_session
  GROUP BY cohort_date
)

SELECT
  c.cohort_date,
  c.week_offset,
  c.users_active,
  cs.cohort_size,
  SAFE_DIVIDE(c.users_active, cs.cohort_size) AS retention_rate
FROM cohort c
JOIN cohort_sizes cs USING (cohort_date)
ORDER BY cohort_date, week_offset;
