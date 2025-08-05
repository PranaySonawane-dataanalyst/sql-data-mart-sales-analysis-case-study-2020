# 🧠 SQL Case Study #1 – Data Mart Sales Analysis 2020

## 📌 Project Title  
**Data Mart Sales Performance Analysis – 2020**

---

## 📄 Description

This case study is based on a sales dataset from a Data Mart company of the year 2020. The dataset contains approximately **17,000–18,000 rows**.

According to the company, **major supply chain changes** were implemented in **June 2020**, including a shift to **sustainable packaging methods** at every step — from farm to customer.  
This analysis aims to understand the **impact of those changes on sales performance** across different platforms, demographics, and regions.

---

## 🧱 Database Schema

### Original Table

```sql
CREATE TABLE IF NOT EXISTS weekly_sales (
    week_date DATE,
    region VARCHAR(100),
    platform VARCHAR(100),
    segment VARCHAR(100),
    customer_type VARCHAR(100),
    transactions INT,
    sales INT
);
```

## 🧼 Data Cleaning Steps
I created a new table called **clean_weekly_sales** with the following transformations:

1.Week Number: Assign week numbers based on week_date (1st–7th Jan → Week 1, etc.).

2.Month Number: Extract month number from week_date.

3.Calendar Year: Extract year (2018, 2019, or 2020).

4.Age Band: Created from the number in segment:

    1 → Young Adults
    
    2 → Middle Aged
    
    3 or 4 → Retirees

5.Demographic: Derived from the first character of segment:

    C → Couples
    
    F → Families

6.Null Handling: Replaced NULL or empty values with "Unknown" in relevant columns.

7.Average Transaction: sales / transactions, rounded to 2 decimals as avg_transaction.

## ❓ Key Analysis Questions
1.Which week numbers are missing from the dataset?

2.Total transactions per year?

3.Monthly total sales per region?

4.Transaction count per platform?

5.Retail vs Shopify: monthly sales percentages?

6.Yearly sales breakdown by demographic?

7.Top age_band and demographic contributors to Retail sales?

## 📊 Insights
1.Sales by Year:

    2018: ₹3,464,064,60
    
    2019: ₹3,656,392,85
    
    2020: ₹3,758,136,51

2.Regional Trends:

    Oceania had the highest sales month-over-month.
    
    Europe saw a gradual decline in monthly sales.

3.Platform Performance:

    Retail had the highest transaction count.
    
    Retail also dominated in percentage sales vs Shopify.
    
    Shopify may need performance improvements moving forward.

4.Demographic & Age Band Insights:

    Retirees contributed ₹13,005,266,930 to total sales.
    
    Families demographic contributed ₹12,759,667,763.

## ✅ Conclusion
This SQL case study provided insights into:

Sales performance before and after packaging changes.

Key regions, platforms, and customer segments.

Opportunities for growth (e.g. improving Shopify sales).

## 📎 Author
**Pranay Sonawane** 
Data Analyst | SQL Enthusiast | Case Study Builder
📫 Connect on LinkedIn :- www.linkedin.com/in/sonawane-pranay
