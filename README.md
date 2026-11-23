# Data-Cleaning-Project1

SQL Data Cleaning Pipeline — Global Layoffs Dataset



Built a structured MySQL data-cleaning workflow to transform raw layoff records into an analysis-ready dataset while preserving raw data integrity through staging tables. Key steps included identifying and removing duplicate records using window functions (ROW\_NUMBER() with PARTITION BY), standardizing text fields (TRIM, trailing punctuation cleanup, and grouping inconsistent labels like 'Crypto%'), converting string dates into native DATE types (STR\_TO\_DATE and ALTER TABLE), imputing missing industry values via self-joins after normalizing blank strings to NULL, and filtering out uninformative rows missing both layoff metrics before dropping helper columns.

