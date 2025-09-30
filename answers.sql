-- ===========================
-- Flexion SQL Technical Assessment
-- Author: David Boateng
-- Date: September 26, 2025
-- ===========================

-- ================================================
-- Exercise 1: Join claim data with policy data using fuzzy email matching
-- ================================================

-- Objective:
-- Attach 'claim_type' from policy_holders to each record in claim_results.
-- However, emails in claim_results (entered by users) may include casing issues,
-- whitespace, or minor typos — so we need both normalization and fuzzy matching.

SELECT 
    cr.*,                    -- Select all columns from the claim_results table
    ph.claim_type            -- Add the claim_type column from the policy_holders table
FROM 
    claim_results cr         -- Base table containing 1 row per medical claim
LEFT JOIN 
    policy_holders ph        -- Reference table containing policyholder details
    ON 
    (
        -- === Step 1: Try an exact match after normalization ===

        -- LOWER() makes both emails lowercase — email addresses are case-insensitive,
        -- so this prevents mismatches like 'JOHN@example.com' vs. 'john@example.com'
        -- LTRIM() and RTRIM() remove any leading or trailing whitespace that may have been accidentally entered
        LOWER(LTRIM(RTRIM(cr.beneficiary_email))) = LOWER(LTRIM(RTRIM(ph.patient_email)))
    )
    OR 
    (
        -- === Step 2: Fallback to fuzzy matching if exact match fails ===

        -- SOUNDEX() creates a phonetic code based on how the email "sounds"
        -- Useful for catching simple typos or character swaps that sound similar
        SOUNDEX(cr.beneficiary_email) = SOUNDEX(ph.patient_email)

        -- DIFFERENCE() returns a similarity score from 0 (no match) to 4 (perfect match)
        -- Here I use a threshold of 3+, which allows for minor character differences
        AND DIFFERENCE(cr.beneficiary_email, ph.patient_email) >= 3
    );




-- ================================================
-- Exercise 2: Add a recency ranking for each customer's claims
-- ================================================

-- Objective:
-- For each beneficiary, assign a number to their claims based on how recent the visit was.
-- The most recent visit should have a rank of 1, second most recent = 2, etc.

SELECT 
    *,  -- Select all columns from claim_results (could explicitly name fields in production)
    
    -- ROW_NUMBER() assigns a sequential rank to rows within a partition.
    -- Partitioning by 'beneficiary_email' ensures ranking happens per customer.
    -- Ordering by 'service_date DESC' puts the most recent claim first (rank 1).
    ROW_NUMBER() OVER (
        PARTITION BY beneficiary_email        -- Grouping by customer
        ORDER BY service_date DESC            -- Sort by date, most recent first
    ) AS customer_claim_recency_number        -- Alias: describes what this column represents

FROM 
    claim_results;

-- Result:
-- Each customer’s claims will be numbered from most recent (1) to oldest (N),
-- enabling time-based claim analysis or recency modeling.




-- ================================================
-- Exercise 3: Calculate average claim score by visit month and policy length
-- ================================================

-- Objective:
-- Summarize claim scores over time, segmented by the length of the policy (6 or 12 months).
-- This can help identify trends, seasonal effects, or differences between policy types.

SELECT 
    -- FORMAT() extracts the year and month from service_date in 'YYYY-MM' format.
    -- This gives a clean label for grouping and is easily human-readable.
    FORMAT(cr.service_date, 'yyyy-MM') AS visit_month,

    ph.policy_length,   -- Bring in policy length for segmentation (6 or 12 months)

    -- AVG() calculates the mean of medical_answer (claim score from 1–10)
    -- Multiply by 1.0 to ensure float division (prevents rounding errors if all integers)
    AVG(cr.medical_answer * 1.0) AS average_claim_score

FROM 
    claim_results cr

-- Joining claim data to policy data using cleaned email match
JOIN 
    policy_holders ph
    ON LOWER(LTRIM(RTRIM(cr.beneficiary_email))) = LOWER(LTRIM(RTRIM(ph.patient_email)))

-- Grouping by both month and policy_length to allow dual-segmentation
GROUP BY 
    FORMAT(cr.service_date, 'yyyy-MM'),
    ph.policy_length;

-- Result:
-- This query produces one row per (month, policy_length) combination with the average claim score.
-- Useful for dashboarding or historical performance tracking.




-- ================================================
-- Exercise 4: Flag claim groups with low average scores, excluding April
-- ================================================

-- Objective:
-- Based on results from Exercise 3, flag groups where the average claim score is below 8.
-- However, per the business rule, April claims should never be flagged regardless of score.

-- Step 1: Create a Common Table Expression (CTE) to compute average scores by month + policy_length

WITH MonthlyScores AS (
    SELECT 
        FORMAT(cr.service_date, 'yyyy-MM') AS visit_month,     -- Human-readable month format
        MONTH(cr.service_date) AS visit_month_number,          -- Numeric month for easier logic (e.g., April = 4)
        ph.policy_length,
        AVG(cr.medical_answer * 1.0) AS average_claim_score    -- Average claim score as float
    FROM 
        claim_results cr
    JOIN 
        policy_holders ph
        ON LOWER(LTRIM(RTRIM(cr.beneficiary_email))) = LOWER(LTRIM(RTRIM(ph.patient_email)))
    GROUP BY 
        FORMAT(cr.service_date, 'yyyy-MM'),
        MONTH(cr.service_date),
        ph.policy_length
)

-- Step 2: Add logic to flag low-score groups, but exclude April (month = 4)

SELECT 
    *,  -- All fields from CTE

    -- CASE statement to flag low-scoring months (score < 8), except April
    CASE 
        WHEN average_claim_score < 8 AND visit_month_number <> 4 THEN CAST(1 AS BIT)  -- Flag as TRUE (1)
        ELSE CAST(0 AS BIT)                                                           -- Otherwise FALSE (0)
    END AS flag_for_review

FROM 
    MonthlyScores;

-- Result:
-- Each (month, policy_length) combination includes a flag indicating if review is needed.
-- Business exception for April is enforced explicitly.
