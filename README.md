# E-Commerce Customer Churn Analysis

## About the Project
Customers of an online store leave without telling anyone. This project finds
which customers are still active, which are slipping away and which have
already left, and shows the result in an interactive Power BI dashboard.

## Dataset
- Source: Kaggle eCommerce events data, October 2019 (about 42 million rows)
- Used: a random sample of 500,000 rows (`random_state=42`) covering the whole month

## Churn Definition
Days since the last purchase, measured against 31 October 2019:
- Active: up to 7 days
- At Risk: 8 to 15 days
- Churned: more than 15 days

## Workflow
1. Sampling: random 500,000-row sample using Python
2. Excel: missing values, pivot tables, price check, conversion rate
3. PostgreSQL: data loaded with COPY, business questions answered with SQL
4. Python (Pandas, Matplotlib): data cleaning, churn labels, charts
5. Power BI: 4-page dashboard (Overview, Brand and Category, Churn Deep-Dive, Key Insights)

## Key Results
- Conversion rate: 1.84% (480,288 views, 10,861 cart events, 8,851 purchases)
- Buyers analysed: 8,536
- Churned: 47.2% | At Risk: 28.3% | Active: 24.5%
- Samsung and Apple lead in purchases; smartphones are the top category
- 31.79% of rows have no category and 14.46% have no brand

## Recommendations
- Target the 2,413 At-Risk customers first
- Run a win-back campaign for Churned customers
- Fix missing brand and category data
- Improve the product page and checkout funnel

## Tools Used
Excel, PostgreSQL (pgAdmin), Python (Pandas, Matplotlib), Power BI

## Future Scope
Machine-learning churn prediction, RFM segmentation, direct database connection.

## Author
Ankita Kumari
