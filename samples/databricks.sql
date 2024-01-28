-- databricks
CREATE OR REPLACE VIEW experienced_employee
    (id COMMENT 'Unique identification number', Name)
    COMMENT 'View for experienced employees'
    AS SELECT id, name
         FROM all_employee
        WHERE working_years > 5;