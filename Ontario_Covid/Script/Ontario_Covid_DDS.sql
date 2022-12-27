Create database Ontario_Covid_DDS;

Use Ontario_Covid_DDS;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Gender](
	[ID_Gender] [int] IDENTITY(1,1) NOT NULL,
	[GenderCode] [nvarchar](5) NULL,
	[Gender] [nvarchar](255) NULL,
	Constraint PK_Gender primary key (ID_Gender)
);
CREATE TABLE [dbo].[Dim_Age_Group](
	[ID_Age_Group] [int] IDENTITY(1,1) NOT NULL,
	[AgeGroupCode] [varchar](5) NULL,
	[Age_group] [nvarchar](255) NULL,
	Constraint PK_Age_Group primary key (ID_Age_Group)
);
CREATE TABLE [dbo].[Dim_Case_Status](
	[ID_Case_Status] [int] IDENTITY(1,1) NOT NULL,
	[CaseStatusCode] [nvarchar](5) NULL,
	[Case_Status] [nvarchar](255) NULL,
	Constraint PK_Case_Status primary key (ID_Case_Status)
);
CREATE TABLE [dbo].[Dim_Outbreak_Group](
	[ID_Outbreak_Group] [int] IDENTITY(1,1) NOT NULL,
	[OutbreakGroupCode] [nvarchar](5) NULL,
	[Outbreak_group] [nvarchar](255) NULL,
	Constraint PK_Outbreak_Group primary key (ID_Outbreak_Group)
);
CREATE TABLE [dbo].[Dim_Case_Severity](
	[ID_Case_Severity] [int] IDENTITY(1,1) NOT NULL,
	[SeverityCode] [nvarchar](5) NULL,
	[Severity] [nvarchar](255) NULL,
	Constraint PK_Severity primary key (ID_Case_Severity)
);
CREATE TABLE [dbo].[Dim_CaseAccquistionInfo](
	[ID_CaseAccquistionInfo] [int] IDENTITY(1,1) NOT NULL,
	[CaseAccquistionInfoCode] [nvarchar](5) NULL,
	[CaseAccquistionInfo] [nvarchar](255) NULL,
	Constraint PK_CaseAccquistionInfo primary key (ID_CaseAccquistionInfo)
);
CREATE TABLE [dbo].[Dim_Year](
	[ID_Year] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NULL,
	Constraint PK_Year primary key (ID_Year)
);
CREATE TABLE [dbo].[Dim_Quarter](
	[ID_Quarter] [int] IDENTITY(1,1) NOT NULL,
	[Quarter] [int] NULL,
	[ID_Year] [int] NULL,
	Constraint PK_Quarter primary key (ID_Quarter),
	Constraint FK_Quarter_Year FOREIGN KEY (ID_Year) REFERENCES Dim_Year(ID_Year),
);

CREATE TABLE [dbo].[Dim_Month](
	[ID_Month] [int] IDENTITY(1,1) NOT NULL,
	[Month] [int] NULL,
	[ID_Quarter] [int] NULL,
	Constraint PK_Month primary key (ID_Month),
	Constraint FK_Month_Year FOREIGN KEY (ID_Quarter) REFERENCES Dim_Quarter(ID_Quarter),
);
CREATE TABLE [dbo].[Dim_Date](
	[ID_Date] [int] IDENTITY(1,1) NOT NULL,
	[Date] [int] NULL,
	[ID_Month] [int] NULL,
	Constraint PK_Date primary key (ID_Date),
	Constraint FK_Date_Month FOREIGN KEY (ID_Month) REFERENCES Dim_Month(ID_Month),
);
CREATE TABLE [dbo].[Dim_PHU_GROUP](
	[ID_PHU_GROUP] [int] IDENTITY(1,1) NOT NULL,
	[PHU_Group ] [nvarchar](255) NULL,
	Constraint PK_PHU_GROUP primary key (ID_PHU_GROUP)
);
CREATE TABLE [dbo].[Dim_PHU_City](
	[ID_PHU_City] [int] IDENTITY(1,1) NOT NULL,
	[PHU_City] [nvarchar](255) NULL,
	[ID_PHU_GROUP] [int] NULL,
	Constraint PK_PHU_City primary key (ID_PHU_City),
	Constraint FK_PHU_City_PHU_GROUP FOREIGN KEY (ID_PHU_GROUP) REFERENCES Dim_PHU_GROUP(ID_PHU_GROUP),

);
CREATE TABLE [dbo].[Dim_PHU](
	[ID_PHU] [int] IDENTITY(1,1) NOT NULL,
	[PHU_ID] [int] NULL,
	[PHU_Name] [nvarchar](255) NULL,
	[ID_PHU_City] [int] NULL,
	Constraint PK_PHU primary key (ID_PHU),
	Constraint FK_PHU_PHU_City FOREIGN KEY (ID_PHU_City) REFERENCES Dim_PHU_City(ID_PHU_City),

);


CREATE TABLE [dbo].[FACT_NumberOfCovidCases](
	[ID_NumberOfCovidCases] [int] IDENTITY(1,1) NOT NULL,
	[ID_PHU] [int] NULL,
	[ID_Gender] [int] NULL,
	[ID_Age_Group] [int] NULL,
	[ID_Case_Severity] [int] NULL,
	[ID_Case_Status] [int] NULL,
	[ID_CaseAccquistionInfo] [int] NULL,
	[ID_Date] [int] NULL,
	[ID_Outbreak_Group] [int] NULL,
	[Number_of_Covid_Cases] [int] NULL,
	Constraint PK_FACT_NumberOfCovidCases primary key (ID_NumberOfCovidCases),
	Constraint FK_FACT_NumberOfCovidCases_PHU FOREIGN KEY (ID_PHU) REFERENCES Dim_PHU(ID_PHU),
	Constraint FK_FACT_NumberOfCovidCases_Gender FOREIGN KEY (ID_Gender) REFERENCES Dim_Gender(ID_Gender),
	Constraint FK_FACT_NumberOfCovidCases_Age_Group FOREIGN KEY (ID_Age_Group) REFERENCES Dim_Age_Group(ID_Age_Group),
	Constraint FK_FACT_NumberOfCovidCases_Case_Severity FOREIGN KEY (ID_Case_Severity) REFERENCES Dim_Case_Severity(ID_Case_Severity),
	Constraint FK_FACT_NumberOfCovidCases_Case_Status FOREIGN KEY (ID_Case_Status) REFERENCES Dim_Case_Status(ID_Case_Status),
	Constraint FK_FACT_NumberOfCovidCases_Date FOREIGN KEY (ID_Date) REFERENCES Dim_Date(ID_Date),
	Constraint FK_FACT_NumberOfCovidCases_Outbreak_Group FOREIGN KEY (ID_Outbreak_Group) REFERENCES Dim_Outbreak_Group(ID_Outbreak_Group),
	Constraint FK_FACT_NumberOfCovidCases_CaseAccquistionInfo FOREIGN KEY (ID_CaseAccquistionInfo) REFERENCES Dim_CaseAccquistionInfo(ID_CaseAccquistionInfo),
)
CREATE TABLE [dbo].[FACT_NumberOfVaccinesByYear](
	[ID_NumberOfVaccinesByYear] [int] IDENTITY(1,1) NOT NULL,
	[ID_Year] [int] NULL,
	[Number_of_VaccinesByYear] [bigint] NULL,
	Constraint PK_FACT_NumberOfVaccinesByYear primary key (ID_NumberOfVaccinesByYear),
	Constraint FK_FACT_NumberOfVaccinesByYear_Year FOREIGN KEY (ID_Year) REFERENCES Dim_Year(ID_Year)
)