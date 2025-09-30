# 🧠 Flexion SQL Technical Assessment — Data Analyst Submission

Hi there 👋 — I'm David, and this repo contains my completed submission for the SQL technical assessment provided by Flexion.

This project reflects how I approach analytical problems: blending clean logic with practical handling of real-world data issues like typos and missing consistency. I’ve structured the repo and SQL code to be both readable and scalable — just how I’d build it if this were a live production task.

---

## 🗂️ What's in this Repo?

| File               | Description                                                  |
|--------------------|--------------------------------------------------------------|
| `answers.sql`       | Fully commented T-SQL solutions to all 4 exercises            |
| `analysis_report.md`| Walkthrough of my logic, choices, and assumptions            |
| `README.md`         | This file — overview and how to navigate the repo            |

---

## 🛠️ Tech Used

- **SQL Server (T-SQL)**
- GitHub for version control & documentation
- SQL techniques: `JOIN`, `ROW_NUMBER`, `GROUP BY`, CTEs, fuzzy matching (`SOUNDEX`, `DIFFERENCE`)

---

## ✍️ Thought Process & Highlights

- **Messy Data? Bring it on.**  
  Real-world email data often has inconsistencies, so I built in fuzzy matching logic to help simulate a more production-level join. I used T-SQL's `SOUNDEX()` and `DIFFERENCE()` to handle typos gracefully.

- **Recency Ranking Made Clean.**  
  I used `ROW_NUMBER()` to track most recent visits per customer — the kind of thing that comes up often in lifecycle or behavior-based analysis.

- **Aggregation with Precision.**  
  When calculating averages, I made sure to cast to float to avoid hidden bugs due to integer division.

- **Business Rules = Logic + Exceptions.**  
  For the review flag in Exercise 4, I combined simple thresholds with an exception for April — highlighting the balance between logic and business nuance.

---

## 🧩 If This Were Production...

If I were building this for a production environment, I’d go further by:
- Creating temp views or stored procedures
- Auditing fuzzy joins to identify false matches
- Building unit tests for critical logic
- Adding visuals or dashboards to tell the story behind the data

---

## 🙌 Final Thoughts

Thanks for taking the time to review my submission. I enjoyed working through this assessment — especially the mix of SQL logic and data intuition required. Let me know if you'd like me to walk through any part in more detail.

Looking forward to the next steps!

Best,  
David
