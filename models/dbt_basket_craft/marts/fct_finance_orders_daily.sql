WITH fct_finance_orders_daily AS (
   SELECT
       -- Time dimensions for financial reporting periods
       fdo.order_day,
       DATE_TRUNC('month', fdo.order_day) AS order_month,
       DATE_TRUNC('quarter', fdo.order_day) AS order_quarter,
      
       -- High-level financial KPIs (aggregated across all products)
       SUM(fdo.total_revenue_usd) AS daily_revenue_usd,
       SUM(fdo.total_cost_usd) AS daily_cost_usd,
       SUM(fdo.total_profit_usd) AS daily_profit_usd,
      
       -- Financial ratios CFOs track
       ROUND((SUM(fdo.total_profit_usd) / NULLIF(SUM(fdo.total_revenue_usd), 0) * 100)::numeric, 2) AS profit_margin_pct,
      
       -- Order volume
       SUM(fdo.total_orders) AS daily_order_count,
      
       -- Monthly running totals for performance tracking
       SUM(SUM(fdo.total_revenue_usd)) OVER (
           PARTITION BY DATE_TRUNC('month', fdo.order_day)
           ORDER BY fdo.order_day
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       )::numeric AS mtd_revenue_usd,
      
       SUM(SUM(fdo.total_profit_usd)) OVER (
           PARTITION BY DATE_TRUNC('month', fdo.order_day)
           ORDER BY fdo.order_day
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       )::numeric AS mtd_profit_usd,
      
       -- Audit/metadata fields
       CURRENT_TIMESTAMP AS finance_report_generated_at
   FROM {{ ref('fct_orders_products_daily') }} fdo
   GROUP BY
       fdo.order_day
   ORDER BY
       fdo.order_day DESC
)
SELECT *
FROM fct_finance_orders_daily