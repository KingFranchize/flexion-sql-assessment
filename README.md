#  Flexion SQL Technical Assessment – Data Analyst Submission

Hi, I'm David, and this repository contains my completed SQL technical assessment for the Data Analyst role at Flexion.

This project was designed to test analytical thinking, SQL fluency and the ability to reason through imperfect real world data. I’ve treated this assessment like I would a scoped production task, focusing not just on writing correct SQL, but on making it maintainable, explainable and reflective of real business needs.

---

##  Repository Structure

| File                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `answers.sql`        | Fully annotated T-SQL code with step-by-step logic                         |
| `analysis_report.md` | A deeper dive into my reasoning, decisions, and assumptions                |
| `README.md`          | Overview, methodology, and considerations for reviewers                    |

---

##  Tools & Skills Demonstrated

- **SQL Server (T-SQL)**
- Joins (exact & fuzzy matching with `SOUNDEX` and `DIFFERENCE`)
- Window functions (`ROW_NUMBER()`)
- Aggregation & grouping (`AVG`, `GROUP BY`, date formatting)
- Conditional logic (`CASE`, boolean flags)
- Use of CTEs for clarity and modularity
- Real-world production practices: code commenting, normalization, type handling

---

##  Project Overview

This assessment involved 4 core SQL tasks related to claims and policyholder data. The data provided was intentionally imperfect in places (e.g. inconsistent email fields), requiring both technical accuracy and business judgment.

---

###  Exercise 1: Join Tables with Fuzzy Matching

> **Objective:** Join `claim_results` and `policy_holders` using email addresses, which may contain typos.

- First attempt: Normalize both emails using `LOWER()`, `LTRIM()`, and `RTRIM()`
- Fallback: Apply fuzzy matching using T-SQL’s `SOUNDEX()` and `DIFFERENCE()` functions
- Approach prioritizes exact matches but allows near matches when exact fails

 **Why it matters:** Inconsistent identifiers are common in healthcare and insurance datasets. This logic reduces the risk of missing true matches due to minor user entry errors.

---

###  Exercise 2: Rank Claims by Recency

> **Objective:** Add a `customer_claim_recency_number` for each visit

- Used `ROW_NUMBER()` to rank each beneficiary’s visits by descending service date
- Ensures each customer’s most recent claim is ranked 1, next visit is 2, and so on

 **Use case:** This technique is often applied in cohort analysis, churn prediction, or behavioral segmentation.

---

###  Exercise 3: Monthly Aggregation by Policy Length

> **Objective:** Calculate average claim score by month and `policy_length`

- Used `FORMAT()` to extract month from `service_date`
- Grouped by month and policy length
- Used float division (`medical_answer * 1.0`) to ensure decimal accuracy

 **Why it matters:** Knowing how claim behavior varies by policy type and seasonality is essential for underwriting and forecasting.

---

###  Exercise 4: Flag Claims for Review

> **Objective:** Flag any average claim score < 8, *except* for visits in April

- Built on Exercise 3 using a CTE (`MonthlyScores`)
- Used `CASE` to add a `flag_for_review` column
- Ensured April is excluded using `MONTH(service_date) <> 4`

 **Why it matters:** Business rules often include logic exceptions. Hard-coding those exceptions into scalable, documented logic ensures both accuracy and auditability.

---

##  Production Considerations

If this were a production task, I’d also consider:

- Adding **unit tests or validation checks** for the joins and ranking logic
- Exporting monthly summary reports or dashboards (e.g., Power BI)
- Building out **stored procedures** or **views** for reusability
- Logging unmatched or ambiguously matched records for QA
- Adding indexing suggestions for large datasets on `email`, `service_date`, etc.

---

##  Reflection

I enjoyed working through this assessment because it balanced SQL fundamentals with messy data realities — which mirrors what we often deal with in real-world analytics work.

My goal wasn’t just to write code that runs, but to create something that could:
- Be understood other analysts
- Be expanded upon by engineers
- Be trusted by stakeholders

---

## 🙋‍♂️ About Me

I’m a data analyst with experience in SQL, Python, and data visualization, and I bring a mix of analytical precision and business context to everything I build. I care about clean logic, scalable workflows, and clear communication.

Thanks for taking the time to review my work.

Best regards,  
**David**
