# Cyclistic Bike-Share Data Analysis
_This project is my Capstone Project for the Google Data Analytics Professional Certificate._

The goal of this project is to analyze bike-share usage data and provide actionable recommendations to help Cyclistic design marketing strategies that convert casual riders into annual members.

## Overview

Cyclistic, a fictional bike-share company in Chicago, wants to increase profitability by converting casual riders into annual members. This project aims to ***understand how annual members and casual riders use bikes differently.***

## Dataset
- Downloaded 12 months of raw trip data (CSV files) (~5M+ rows total).
- Stored data locally and structured it in a way that could be queried efficiently.

## Data Cleaning & Preparation
- **Excel:** Cleaned each monthly CSV (removed nulls, duplicates, invalid trip durations).

- **SQL (conceptual exploration & practice):**
    - Wrote sample queries to understand trip counts, date ranges, and summary statistics.
    - Practiced filtering and aggregating data (e.g., `COUNT`, `AVG`, `GROUP BY` ride type and weekday).
    - These queries helped validate that the combined dataset in Excel matched expectations.
- Combined all 12 months into a single master CSV file for further analysis.
- Used the course-provided smaller dataset in R for reproducibility.

## Key Findings

- Casual riders take longer trips but mostly on weekends & holidays.
- Peak hours for weekaday trips are same for both Annual members and Casual riders.(likely commuting)
- Casual riders are more seasonal, while members ride year-round.

## Dashboard
- Tableau Dashboard shows:
    - Types of Customers
    - Prefered Biketype
    - Day-wise & Month-wise Usage
    - Average Ridetime Day-wise
    - Usage Peak-hour

![Dashboard Screenshot](dashboard/dashboard.png)

## Final Recommendations

- **Weekend promotions:** Target casual riders with discounts/membership offers on weekends.

- **Commuter plans:** Highlight convenience and cost-saving benefits for weekday riders.

- **Seasonal campaigns:** Encourage casual riders during high-use summer months.

## Author & Contact
**Shubham Rathore**
📧 Email:shubhamrathore7078@gmail.com
