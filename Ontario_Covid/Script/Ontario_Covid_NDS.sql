USE [master];
GO


-- ****************************************
-- Drop Database
-- ****************************************

IF EXISTS (SELECT [name] FROM [master].[sys].[databases] WHERE [name] = N'NDS')
    DROP DATABASE NDS;

-- If the database has any other open connections close the network connection.
IF @@ERROR = 3702 
    RAISERROR('NDS database cannot be dropped because there are still other open connections', 127, 127) WITH NOWAIT, LOG;
GO

-- ****************************************
-- Create Database
-- ****************************************

CREATE DATABASE NDS;
GO

USE NDS;
GO

-- ******************************************************
-- Create tables
-- ******************************************************
CREATE TABLE [dbo].[DataSource](
	[ID_DataSource] [int] IDENTITY(1,1) NOT NULL,
	[DataSourceName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[AgeGroup](
	[ID_AgeGroupSK] [int] NOT NULL,
	[Age_Group] [nvarchar](255) NULL,
	[ID_DataSource] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[Postalcode](
	[ID_PostalCodeSK] [int] IDENTITY(1,1) NOT NULL,
	[City] [nchar](255) NULL,
	[PostalCode] [nchar](255) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[PHU_Group](
	[ID_GROUPSK] [int] IDENTITY(1,1) NOT NULL,
	[PHU_Group] [nvarchar](255) NULL,
	[PHU_City] [nvarchar](255) NULL,
	[PHU_region] [nvarchar](255) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[PublicHealthUnit](
	[IDPHU_SK] [int] IDENTITY(1,1) NOT NULL,
	[PHU_ID] [int] NULL,
	[Reporting_PHU] [nvarchar](255) NULL,
	[Address] [nvarchar](255) NULL,
	[ID_GroupSK] [int] NULL,
	[ID_PostalCodeSK] [int] NULL,
	[Website] [nvarchar](255) NULL,
	[Latitude] [float] NULL,
	[Longtitude] [float] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[Outgoing_outbreaks](
	[IDOutbreakSK] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NULL,
	[IDPHU_SK] [int] NULL,
	[Outbreak_group] [nvarchar](255) NULL,
	[Number_outgoing_outbreaks] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[VaccineByAge](
	[IDVaccineByAge_SK] [int] IDENTITY(1,1) NOT NULL,
	[IDPHU_SK] [int] NULL,
	[Date] [date] NULL,
	[ID_AgeGroupSK] [int] NULL,
	[At_least_one_dose_cumulative] [int] NULL,
	[Second_dose_cumulative] [int] NULL,
	[Fully_vaccinated_cumulative] [int] NULL,
	[Third_dose_cumulative] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];

CREATE TABLE [dbo].[ReportedCases](
	[IDReportedCaseSK] [int] IDENTITY(1,1) NOT NULL,
	[CaseID] [int] NULL,
	[Case_status] [nvarchar](255) NULL,
	[ID_AgeGroupSK] [int] NULL,
	[Gender] [nvarchar](255) NULL,
	[IDPHU_SK] [int] NULL,
	[SpecimenDate] [date] NULL,
	[CaseReportedDate] [date] NULL,
	[TestReportedDate] [date] NULL,
	[CaseAccquistionInfo] [nvarchar](255) NULL,
	[AccurateEpisodeDate] [date] NULL,
	[OutbreakRelated] [nvarchar](255) NULL,
	[ID_DataSource] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY];


-- ******************************************************
-- Add Primary Keys
-- ******************************************************
ALTER TABLE [dbo].[DataSource] WITH CHECK ADD 
    CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED
	(
	[ID_DataSource]
	) ON [PRIMARY];
GO

ALTER TABLE [dbo].[AgeGroup] WITH CHECK ADD 
    CONSTRAINT [PK_AgeGroup] PRIMARY KEY CLUSTERED
	(
	[ID_AgeGroupSK]
	) ON [PRIMARY];
GO

ALTER TABLE [dbo].[Postalcode] WITH CHECK ADD 
    CONSTRAINT [PK_Postalcode] PRIMARY KEY CLUSTERED
	(
	[ID_PostalCodeSK]
	) ON [PRIMARY];
GO

ALTER TABLE [dbo].[PHU_Group] WITH CHECK ADD 
    CONSTRAINT [PK_PHU_Group] PRIMARY KEY CLUSTERED
	(
	[ID_GROUPSK]
	) ON [PRIMARY];
GO

ALTER TABLE [dbo].[PublicHealthUnit] WITH CHECK ADD 
    CONSTRAINT [PK_PublicHealthUnit] PRIMARY KEY CLUSTERED
	(
	[IDPHU_SK]
	) ON [PRIMARY];
GO

ALTER TABLE [dbo].[Outgoing_outbreaks] WITH CHECK ADD 
    CONSTRAINT [PK_Outgoing_outbreaks] PRIMARY KEY CLUSTERED
	(
	[IDOutbreakSK]
	) ON [PRIMARY];
GO

ALTER TABLE [dbo].[VaccineByAge] WITH CHECK ADD 
    CONSTRAINT [PK_VaccineByAge] PRIMARY KEY CLUSTERED
	(
	[IDVaccineByAge_SK]
	) ON [PRIMARY];
GO

ALTER TABLE [dbo].[ReportedCases] WITH CHECK ADD 
    CONSTRAINT [PK_ReportedCases] PRIMARY KEY CLUSTERED
	(
	[IDReportedCaseSK]
	) ON [PRIMARY];
GO

 --****************************************
 --Create Foreign key constraints
 --****************************************
ALTER TABLE [dbo].[PublicHealthUnit] ADD 
    CONSTRAINT [FK_PublicHealthUnit_PostalCode] FOREIGN KEY
    (
        [ID_PostalCodeSK]
    ) REFERENCES [dbo].[PostalCode] ([ID_PostalCodeSK]),

	CONSTRAINT [FK_PublicHealthUnit_PHUGroup] FOREIGN KEY
    (
        [ID_GroupSK]
    ) REFERENCES [dbo].[PHU_Group] ([ID_GroupSK]);
GO

ALTER TABLE [dbo].[Outgoing_outbreaks] ADD 
    CONSTRAINT [FK_Outgoing_outbreaks_PublicHealthUnit] FOREIGN KEY
    (
        [IDPHU_SK]
    ) REFERENCES [dbo].[PublicHealthUnit] ([IDPHU_SK]);
GO

ALTER TABLE [dbo].[VaccineByAge] ADD 
    CONSTRAINT [FK_VaccineByAge_PublicHealthUnit] FOREIGN KEY
    (
        [IDPHU_SK]
    ) REFERENCES [dbo].[PublicHealthUnit] ([IDPHU_SK]),

	CONSTRAINT [FK_VaccineByAge_AgeGroup] FOREIGN KEY
    (
        [ID_AgeGroupSK]
    ) REFERENCES [dbo].[AgeGroup] ([ID_AgeGroupSK]);
GO

ALTER TABLE [dbo].[AgeGroup] ADD 
    CONSTRAINT [FK_AgeGroup_DataSource] FOREIGN KEY
    (
        [ID_DataSource]
    ) REFERENCES [dbo].[DataSource] ([ID_DataSource]);
GO

ALTER TABLE [dbo].[ReportedCases] ADD 
    CONSTRAINT [FK_ReportedCases_PublicHealthUnit] FOREIGN KEY 
    (
        [IDPHU_SK]
    )REFERENCES [dbo].[PublicHealthUnit] ([IDPHU_SK]),

	CONSTRAINT [FK_ReportedCases_AgeGroup] FOREIGN KEY
	(
		[ID_AgeGroupSK]
	) REFERENCES [dbo].[AgeGroup] ([ID_AgeGroupSK]),

	CONSTRAINT [FK_ReportedCases_DataSource] FOREIGN KEY
	(
		[ID_DataSource]
	) REFERENCES [dbo].[DataSource] ([ID_DataSource]);
GO

INSERT INTO [dbo].[DataSource] ([DataSourceName], [CreatDate], [UpdateDate])
VALUES 
  (N'CasesReport', '20010822 00:00:00.000', '20010822 00:00:00.000')
GO

INSERT INTO [dbo].[DataSource] ([DataSourceName], [CreatDate], [UpdateDate])
VALUES 
  (N'CompiledCOVID19CaseDetails', '20010822 00:00:00.000', '20010822 00:00:00.000')
GO