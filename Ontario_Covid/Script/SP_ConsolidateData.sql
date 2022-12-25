USE Ontario_Covid_Stage
GO

CREATE OR ALTER PROC SP_UPDATE_CasesReport
 AS 
BEGIN
	DECLARE @RowCnt INT;
	DECLARE @CR_ID INT = 1;
 
	SELECT @RowCnt = COUNT(*) FROM [CasesReport];
 
	WHILE @CR_ID <= @RowCnt
	BEGIN
		BEGIN 
			UPDATE [dbo].[CasesReport]
			SET     Outcome = CASE  
									WHEN Outcome = 'Resolved' THEN 'Active' 
									WHEN Outcome = 'Fatal' THEN 'Deceased' 
									ELSE Outcome
								END,
					Age = CASE
									WHEN Age = '<20' THEN '<20' 
									WHEN Age = '20s' THEN '20-29' 
									WHEN Age = '30s' THEN '30-39' 
									WHEN Age = '40s' THEN '40-49' 
									WHEN Age = '50s' THEN '50-59' 
									WHEN Age = '60s' THEN '60-69' 
									WHEN Age = '70s' THEN '70-79' 
									WHEN Age = '80s' THEN '80+' 
									WHEN Age = '90+' THEN '80+' 
									ELSE Age
								END,
					Gender = CASE
									WHEN Gender = 'FEMALE' THEN 'Female' 
									WHEN Gender = 'MALE' THEN 'Male' 
									ELSE Gender
								END,
					CaseAcquisitionInfo = CASE
									WHEN CaseAcquisitionInfo = 'OB' THEN 'Outbreak' 
									WHEN CaseAcquisitionInfo = 'CC' THEN 'Close Contact' 
									WHEN CaseAcquisitionInfo = 'No known Epi-link' THEN 'Not Reported' 
									WHEN CaseAcquisitionInfo = 'Travel' THEN 'Travel-Related' 
									ELSE CaseAcquisitionInfo
								END
			WHERE ObjectId = @CR_ID
		END
		SET @CR_ID += 1
	END 
END
GO

CREATE OR ALTER PROC SP_UPDATE_VaccinesByAgePhu
 AS 
BEGIN
	DECLARE @RowCnt INT;
	DECLARE @CR_ID INT = 1;
 
	SELECT @RowCnt = COUNT(*) FROM [dbo].[VaccinesByAgePhu];
 
	WHILE @CR_ID <= @RowCnt
	BEGIN
		BEGIN 
			UPDATE [dbo].[VaccinesByAgePhu]
			SET     Agegroup = CASE
									WHEN Agegroup = 'Ontario_5plus' THEN '<20' 
									WHEN Agegroup = '05-11yrs' THEN '<20' 
									WHEN Agegroup = 'Ontario_12plus' THEN '<20' 
									WHEN Agegroup = '12-17yrs' THEN '<20' 
									WHEN Agegroup = 'Adults_18plus' THEN '<20' 
									WHEN Agegroup = '18-29yrs' THEN '20-29' 
									WHEN Agegroup = '30-39yrs' THEN '30-39' 
									WHEN Agegroup = '40-49yrs' THEN '40-49' 
									WHEN Agegroup = '50-59yrs' THEN '50-59' 
									WHEN Agegroup = '60-69yrs' THEN '60-69' 
									WHEN Agegroup = '70-79yrs' THEN '70-79' 
									WHEN Agegroup = '80+' THEN '80+' 
									WHEN Agegroup = 'Undisclosed_or_missing' THEN 'Not Reported' 
									ELSE Agegroup
								END
			WHERE Id = @CR_ID
		END
		SET @CR_ID += 1
	END 
END

EXEC SP_UPDATE_CasesReport
EXEC SP_UPDATE_VaccinesByAgePhu