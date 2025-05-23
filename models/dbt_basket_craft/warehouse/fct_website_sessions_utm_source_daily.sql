{{ config(materialized='view') }}

WITH sessions_by_day_source AS (
    SELECT
        DATE(website_session_created_at) AS website_session_day,
        utm_source,
        COUNT(website_session_id) AS sessions,
        SUM(is_repeat_session)::int AS repeat_sessions,
        ROUND(
            (SUM(is_repeat_session)::numeric / COUNT(website_session_id)) * 100,
            2
        ) AS repeat_sessions_pct
    FROM {{ ref('stg_website_sessions') }}
    GROUP BY DATE(website_session_created_at), utm_source
)

SELECT *
FROM sessions_by_day_source