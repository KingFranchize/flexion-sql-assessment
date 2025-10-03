#  Analysis Report: Flexion SQL Technical Assessment

### Candidate: David Boateng 
### Submission Date: September 2025  


---

##  Overview

This report provides a detailed walkthrough of my solution to the SQL technical assessment for the Data Analyst role at Flexion. 

Each exercise is treated as a practical scenario requiring clarity, maintainability, and robustness.

---

## ✅ Exercise 1: Joining `claim_results` and `policy_holders` using fuzzy matching

### Objective

Link claim records with policy data, despite potential typos or inconsistencies in email addresses.

###  Approach

- **Step 1: Normalize email fields** using `LOWER()`, `LTRIM()`, and `RTRIM()` to standardize casing and remove trailing/leading spaces.
- **Step 2: Fallback fuzzy matching** using:
  - `SOUNDEX()` for phonetic similarity (misspellings that sound similar)
  - `DIFFERENCE()` to compute similarity score (0 to 4); threshold set to 3+

###  Why This Matters

In real-world datasets, email fields often suffer from:
- Manual entry errors
- Extra whitespace
- Case sensitivity

Rather than dropping mismatches, I’ve included a soft join condition to retain potentially valuable records.

###  Trade-offs

- **Pros**: Higher match rate; more inclusive data joining
- **Cons**: Potential for false positives; should be reviewed/QA’d before production use

---

## ✅ Exercise 2: Add `customer_claim_recency_number`

### 🔍 Objective

For each beneficiary, rank their claims from most recent to oldest.

### 🛠️ Approach

- Used `ROW_NUMBER()` over a window partitioned by `beneficiary_email` and ordered by `service_date DESC`.
- The result gives us the most recent visit per user as rank 1, second most recent as 2, and so on.

### Why This Matters

Recency-based metrics are common in:
- Customer behavior analysis
- Retention modeling
- Patient visit tracking

This technique is scalable to thousands or millions of users without additional subqueries or joins.

---

## ✅ Exercise 3: Average claim score by month and policy length

### Objective

Aggregate `medical_answer` scores by:
- The month of the claim
- The duration of the policy

### Approach

- Used `FORMAT(service_date, 'yyyy-MM')` to extract year-month
- Grouped by both `visit_month` and `policy_length`
- Used `AVG(medical_answer * 1.0)` to ensure float precision (avoid integer division)

###  Why This Matters

Tracking claim behavior by time and policy type helps uncover:
- Seasonality trends
- Differences between sho

---

### Thank you for reviewing my work!

