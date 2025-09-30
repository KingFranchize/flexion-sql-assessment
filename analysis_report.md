# Analysis Report: Flexion SQL Technical Assessment

### Author: David Boateng  
### Date: September 2025

---

## Exercise 1: Join claim data with policy data using fuzzy email matching

The challenge here is that `beneficiary_email` in `claim_results` may contain typos, while `patient_email` in `policy_holders` is clean.  
To address this:
- I first normalized both emails using `LOWER()`, `LTRIM()`, and `RTRIM()`.
- I added a fuzzy matching fallback using `SOUNDEX()` and `DIFFERENCE()` (T-SQL's built-in phonetic comparison).

> This ensures robust matching even when user input is inconsistent.

---

##  Exercise 2: Add `customer_claim_recency_number`

For each customer (identified by `beneficiary_email`), I needed to determine the order of their visits by recency:
- Used `ROW_NUMBER()` window function
- Partitioned by email, ordered by `service_date DESC`
- This assigns 1 to the most recent claim, 2 to the second most recent, etc.

> This method is scalable and accurate for tracking claim history.

---

##  Exercise 3: Average claim score by month and policy length

Objective: Group data by **month of visit** and **policy length**, then compute the average of `medical_answer`:
- Used `FORMAT(service_date, 'yyyy-MM')` for clean month formatting
- Used `AVG(medical_answer * 1.0)` to ensure float division
- Grouped by month and `policy_length`

> This helps understand patterns in claim scoring over time and by policy type.

---

##  Exercise 4: Add `flag_for_review`

Flag conditions:
- If `average_claim_score < 8`, then flag as `1` (true)
- But never flag if the month is April

Implementation:
- Built on the previous monthly aggregation (Exercise 3)
- Used `CASE` logic to exclude April (`MONTH(service_date) = 4`)
- Output includes a boolean-like `flag_for_review` field

> This rule helps identify potentially concerning trends while honoring special exceptions.

---

##  Final Notes

This solution was written using T-SQL, designed to be readable, maintainable, and production-ready.  
Edge cases were handled where possible with SQL Server-native tools. In a production environment, I would recommend:
- Deeper data quality checks
- Fuzzy matching audit logs
- Consideration of NULL values and outliers

---

### Thank you for reviewing my work!

