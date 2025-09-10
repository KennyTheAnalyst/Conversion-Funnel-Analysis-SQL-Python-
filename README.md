
```markdown
# Conversion Funnel Analysis — BigQuery + SQL + Python

**TL;DR:** End-to-end conversion funnel analysis for GA4-style event data (Sessions → Product View → Add to Cart → Checkout → Purchase).  
Includes BigQuery SQL for funnel counts, cohort retention, and last-touch attribution; a reproducible Jupyter notebook for analysis & visualizations; and data quality checks to validate tracking. Ideal portfolio piece for Digital Marketing / Web Analytics roles (GTM, GA4, Looker Studio, Power BI).

---

## What this project demonstrates
- Designing GA4-style event model and data layer concepts (event_name, session_id, user_id, utm fields).  
- BigQuery SQL for funnel metrics, cohort retention, and last-touch attribution.  
- Python (Pandas, Matplotlib) for visualization, statistical checks and A/B test examples.  
- Data quality & tracking validation checks (missing UTMs, logical event sequence anomalies).  
- Dashboard-ready outputs (Looker Studio / Power BI screenshots included in `/docs`).  
- Business-focused insights (ROAS / CPA / conversion improvements, retention patterns).

---

## Tech stack
- Google BigQuery (SQL)  
- Python 3 (pandas, matplotlib, google-cloud-bigquery)  
- Jupyter Notebook (`notebooks/funnel_analysis.ipynb`)  
- Looker Studio / Power BI (optional dashboards)  
- Optional: Docker for reproducible environments

---

## Repo structure
```

conversion-funnel-analysis/
├── README.md
├── requirements.txt
├── data/
│   └── sample\_events.csv           # small simulated dataset (committed)
├── sql/
│   ├── 01\_raw\_events.sql           # (optional) staging / schema notes
│   ├── 02\_funnel\_counts.sql        # funnel step counts & conversion rates
│   ├── 03\_cohort\_retention.sql     # cohort retention heatmap SQL
│   └── 04\_attribution.sql          # last-touch attribution by UTM
├── notebooks/
│   └── funnel\_analysis.ipynb       # Python analysis, charts, A/B test examples
├── src/
│   ├── utils.py                    # data quality checks & helpers
│   └── run\_queries.py              # run SQL queries using bigquery client
├── docs/
│   └── dashboard\_screenshots.png
└── LICENSE

````

---

## Quickstart (local + BigQuery)

### 1) Clone repo
```bash
git clone https://github.com/<your-username>/conversion-funnel-analysis.git
cd conversion-funnel-analysis
````

### 2) Python environment

```bash
python -m venv .venv
source .venv/bin/activate        # macOS / Linux
# .venv\Scripts\activate         # Windows
pip install -r requirements.txt
```

`requirements.txt` includes:

```
pandas
matplotlib
numpy
google-cloud-bigquery
scipy
jupyter
```

### 3) Option A — Use the included simulated CSV (quick demo)

* Open the notebook:

```bash
jupyter notebook notebooks/funnel_analysis.ipynb
```

* The notebook loads `data/sample_events.csv`, runs funnel counts, cohort and attribution, and produces plots.

### 3) Option B — Use BigQuery

1. Upload your data to BigQuery (or create a dataset and use the public GA4 sample):

   * Replace `project.dataset.raw_events` in the SQL files with your project and dataset name.
2. Authenticate (set credentials):

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account.json"
```

3. Load CSV to BigQuery (example):

```bash
bq load --autodetect --source_format=CSV \
  your_project:your_dataset.raw_events data/sample_events.csv
```

4. Run SQL files in BigQuery UI or using `src/run_queries.py` (which uses `google-cloud-bigquery`).

---

## SQL files (what they do)

* `sql/02_funnel_counts.sql` — computes distinct sessions/users at each funnel step and conversion rates (session → product\_view → add\_to\_cart → begin\_checkout → purchase).
* `sql/03_cohort_retention.sql` — builds weekly cohort retention (first session date → subsequent activity) suitable for heatmap visualizations.
* `sql/04_attribution.sql` — simple last-touch attribution by UTM (purchase-level revenue aggregation).
* `sql/01_raw_events.sql` — optional file documenting expected raw events schema and example ingestion SQL.

**Tip:** Replace `project.dataset.raw_events` in SQL with your BigQuery table and run in the Console or via a script.

---

## Notebook highlights (`notebooks/funnel_analysis.ipynb`)

* Pulls results from BigQuery (or loads CSV) and demonstrates:

  * Funnel bar chart & stage-level conversion rates
  * Cohort retention heatmap
  * Last-touch revenue by UTM table
  * Basic A/B test (t-test) example using simulated variant data
  * Data quality checks and examples of flagged anomalies

---

## Data quality checks (why it matters)

This repo includes QC examples to replicate real-world needs:

* Missing UTM checks (`src/utils.py`)
* Sessions with `purchase` but no `product_view`
* Event ordering and duplicate session checks
* Anomaly detection for sudden drops/spikes in event counts


---

## Dashboard (Looker Studio / Power BI)

* Connect Looker Studio to your BigQuery dataset to build a dashboard with:

  * Funnel visualization (bar or waterfall)
  * KPI cards (Sessions, Conversion Rate, ROAS, CPA)
  * Cohort heatmap (retention)
  * Top campaigns by revenue (from attribution SQL)

---

## How to extend

* Add multi-touch attribution (time decay / algorithmic).
* Add server-side tagging example (server GTM + BigQuery ingestion).
* Integrate revenue modeling for CLTV (cohort-level LTV calculation).
* Add LookML / dbt models for better modularity if using dbt or Looker.

---

## Commit & presentation tips

* Use incremental commits with descriptive messages:

  * `feat: add funnel counts SQL`
  * `feat: add cohort retention SQL`
  * `docs: add README and screenshots`
* In README TL;DR include 1–2 screenshots or a GIF to grab attention.
* Add repository topics: `analytics`, `bigquery`, `ga4`, `gtm`, `funnel-analysis`, `python`.

---

## License

This project is MIT licensed — see `LICENSE` for details.

---

## Contact / Attribution

Created by **Kudavuta Kennedy Kujinga** — Web & Marketing Data Analyst.
LinkedIn: [https://www.linkedin.com/in/kudavuta-kujinga-59a387252/](https://www.linkedin.com/in/kudavuta-kujinga-59a387252/)
GitHub: [https://github.com/](https://github.com/)KennyTheAnalyst

---

**Notes**

* This repo is intended as a demonstration of analytics workflows commonly used in GA4 / GTM environments. Replace placeholder project/dataset names with your own BigQuery identifiers before running SQL.
* If you publish screenshots or a dashboard, ensure any sample data is anonymized.

```

