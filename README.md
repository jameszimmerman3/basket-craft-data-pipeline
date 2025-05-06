# Basket Craft: Website Sessions Data Pipeline (Dec 2023)

This project builds a complete end-to-end data pipeline to extract, transform, and analyze website sessions data for the month of December 2023. The pipeline follows modern analytics engineering best practices, combining Python, dbt, GitHub Actions, and Looker Studio to deliver insights into total sessions, repeat visits, and source attribution. The work replicates and extends concepts from previous lesson exercises to a new dataset, implementing secure automation, modular transformation layers, and interactive dashboarding.

## Data Pipeline Diagram

![basket_craft_quiz_diagram_JamesZ drawio](https://github.com/user-attachments/assets/965eeab3-e593-4ed5-8ddf-84c5ffcf4fb2)

This diagram illustrates the full data flow from source to dashboard, covering each layer and the tools used:

- **Source Layer**: AWS RDS (MySQL) – `basket_craft.website_sessions`
- **Raw Layer**:
  - Extracted using a Python script: `elt/basket_craft_website_sessions_extract_load_raw.py`
  - Orchestrated with GitHub Actions and protected by GitHub Secrets
  - Loaded into AWS RDS (Postgres) as `raw.website_sessions`
- **Staging Layer**:
  - dbt model: `stg_website_sessions.sql`
  - Renames `created_at → website_session_created_at` and adds `loaded_at`
- **Warehouse Layer**:
  - dbt model: `fct_website_sessions_utm_source_daily.sql`
  - Aggregates daily session metrics by UTM source
- **Visualization Layer**:
  - Built in Looker Studio with cross-filtering enabled
  - Components:
    - Table: Sessions by Day
    - Heatmap: Repeat % by UTM Source
    - Scorecard: Total Sessions (Dec 2023)
    - Time Series: Daily Sessions Trend
    - Bar Chart: Sessions by UTM Source

## Dashboard

https://lookerstudio.google.com/reporting/b1b38a60-cec9-4ef8-8573-454ee7d2db36
