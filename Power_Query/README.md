# Power Query — Data Cleaning & Transformation

## Overview

Power Query was used to clean and validate the HR Analytics dataset before performing SQL analysis and building the Power BI dashboard.

The objective was to improve data quality while preserving valid employee records and ensuring the dataset was ready for analysis.

## Data Cleaning Steps

### 1. Duplicate Removal

Duplicate employee records were identified using employee identifiers and removed to ensure each employee was represented only once.

The `EmpID` and `EmployeeNumber` fields were used to verify employee uniqueness.

### 2. Removal of Unnecessary Columns

The following columns were removed because they contained no analytical value:

* `EmployeeCount` — constant value
* `Over18` — constant value
* `StandardHours` — constant value
* `AgeGroup` — redundant because the exact `Age` column was available

Removing these columns simplified the dataset without losing useful information.

### 3. Standardization

Inconsistent values in categorical fields were standardized.

For example:

* `TravelRarely` → `Travel_Rarely`
* `Not-Travel` → `Not_Travel`

This ensured consistent category names for analysis.

### 4. Missing Values

The `YearsWithCurrManager` column contained 57 missing values.

These records were **not removed**, because the employees themselves were still valid records.

A validation column was created to identify the missing values and distinguish them from valid records.

### 5. Data Validation

Important numerical fields were checked for their minimum and maximum values, including:

* `Age`
* `DailyRate`
* `HourlyRate`
* `MonthlyIncome`
* `MonthlyRate`
* `PercentSalaryHike`
* `YearsAtCompany`
* `TotalWorkingYears`

Relationship checks were also performed between relevant experience fields, including `YearsInCurrentRole` and `YearsAtCompany`.

### 6. Rate and Income Investigation

`DailyRate` and `MonthlyRate` were investigated because their ranges initially required validation.

The observed ranges were:

* `DailyRate`: 102–1499
* `MonthlyRate`: 2,094–26,999
* `MonthlyIncome`: 1,009–19,999
* `HourlyRate`: 30–100

After investigation, the values were retained rather than arbitrarily modified.

## Final Validation

The final dataset contained **1,470 employee records**.

Validation of the `YearsWithCurrManager` field resulted in:

* **Valid records:** 1,413
* **Missing records:** 57
* **Invalid records:** 0

The missing values were retained because they represented missing information rather than invalid employee records.

## Outcome

The cleaned dataset was prepared for the next stages of the project:

**Power Query → SQL Server → Power BI**

The cleaning process focused on removing duplication, eliminating unnecessary fields, standardizing categorical values, investigating numerical data, and validating missing information while preserving legitimate employee records.
