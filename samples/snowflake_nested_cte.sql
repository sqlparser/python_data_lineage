create or replace view CH_LATEST_JIRA_ISSUE(
    JIRA_ISSUE_ID,
    KEY,
    PARENT_ID,
    RESOLUTION_ID,
    LAST_VIEWED,
    _ORIGINAL_ESTIMATE,
    ASSIGNEE_ID,
    ISSUE_TYPE_ID,
    ENVIRONMENT,
    DUE_DATE,
    REMAINING_ESTIMATE,
    STATUS_ID,
    _REMAINING_ESTIMATE,
    CREATOR_ID,
    TIME_SPENT,
    _TIME_SPENT,
    WORK_RATIO,
    REPORTER_ID,
    PROJECT_ID,
    RESOLVED,
    UPDATED_AT,
    ORIGINAL_ESTIMATE,
    ISSUE_DESCRIPTION,
    ISSUE_SUMMARY,
    STATUS_CATEGORY_CHANGED,
    PRIORITY_ID,
    ISSUE_CREATED_AT,
    IS_DELETED,
    SYNCED_AT,
    FIRST_IN_AMT,
    FIRST_OUT_AMT
) as (
  

WITH tran_in_base1 AS (
    SELECT COMPANY_ID, min(CREATED_AT) CREATED_AT_MIN FROM tide.pres_core.cleared_transactions WHERE AMOUNT>0 GROUP BY COMPANY_ID
),

tran_out_base1 AS (
    SELECT COMPANY_ID, min(CREATED_AT) CREATED_AT_MIN FROM tide.pres_core.cleared_transactions WHERE AMOUNT<0 GROUP BY COMPANY_ID
),

tran_in_base2 AS (
    SELECT a.COMPANY_ID,MAX(a.AMOUNT) AS FIRST_IN_AMT FROM tide.pres_core.cleared_transactions a
    INNER JOIN tran_in_base1 b
    on a.COMPANY_ID=b.COMPANY_ID and a.CREATED_AT=b.CREATED_AT_MIN GROUP BY a.COMPANY_ID
),

tran_out_base2 AS (
    SELECT a.COMPANY_ID,MAX(a.AMOUNT) AS FIRST_OUT_AMT FROM tide.pres_core.cleared_transactions a
    INNER JOIN tran_out_base1 b
    on a.COMPANY_ID=b.COMPANY_ID and a.CREATED_AT=b.CREATED_AT_MIN GROUP BY a.COMPANY_ID
),

jira_issues_tab AS (
  SELECT *
  FROM tide.intg_jira.latest_jira_issues
)

SELECT a.*, b.FIRST_IN_AMT, c.FIRST_OUT_AMT
FROM jira_issues_tab a
LEFT JOIN tran_in_base2 b ON cast(REGEXP_SUBSTR(a.issue_summary,'[0-9]+') AS bigint)=b.COMPANY_ID
LEFT JOIN tran_out_base2 c ON cast(REGEXP_SUBSTR(a.issue_summary,'[0-9]+') AS bigint)=c.COMPANY_ID
  );
