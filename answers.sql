-- ===========================
-- Flexion SQL Technical Assessment
-- Author: David Boateng
-- Date: September 26, 2025
-- ===========================

-- ================================================
-- Exercise 1: Join claim data with policy data using fuzzy email matching
-- ================================================
SELECT 
    cr.*,
    ph.claim_type
FROM 
    claim_results cr
LEFT JOIN 
    policy_holders ph
    ON 
    (
        -- Normalized email match
        LOWER(LTRIM(RTRIM(cr.beneficiary_email))) = LOWER(LTRIM(RTRIM(ph.patient_email)))
    )
    OR 
    (
        -- Fuzzy match using SOUNDEX and DIFFERENCE
        SOUNDEX(cr.beneficiary_email) = SOUNDEX(ph.patient_email)
        AND DIFFERENCE(cr.beneficiary_email, ph.patient_email) >= 3
    );

-- ================================================
-- Exercise 2: Add customer_claim_recency_number using ROW_NUMBER
-- ================================================
SELECT 
    *,
    ROW_NUMBER() OVER (
        PARTITION BY beneficiary_email 
        ORDER BY service_date DESC
    ) AS customer_claim_recency_number
FROM 
    claim_results;

-- ================================================
-- Exercise 3: Average claim score by month and policy_length
-- ================================================
SELECT 
    FORMAT(cr.service_date, 'yyyy-MM') AS visit_month,
    ph.policy_length,
    AVG(cr.medical_answer * 1.0) AS average_claim_score
FROM 
    claim_results cr
JOIN 
    policy_holders ph
    ON LOWER(LTRIM(RTRIM(cr.beneficiary_email))) = LOWER(LTRIM(RTRIM(ph.patient_email)))
GROUP BY 
    FORMAT(cr.service_date, 'yyyy-MM'),
    ph.policy_length;

-- ================================================
-- Exercise 4: Add flag_for_review where score < 8, excluding April
-- ================================================
WITH MonthlyScores AS (
    SELECT 
        FORMAT(cr.service_date, 'yyyy-MM') AS visit_month,
        MONTH(cr.service_date) AS visit_month_number,
        ph.policy_length,
        AVG(cr.medical_answer * 1.0) AS average_claim_score
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
SELECT 
    *,
    CASE 
        WHEN average_claim_score < 8 AND visit_month_number <> 4 THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END AS flag_for_review
FROM 
    MonthlyScores;

