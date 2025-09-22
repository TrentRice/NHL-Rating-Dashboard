---------------------------------Offensive Rating Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY OffRtg_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD OffRtg_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        OffRtg,
        CAST(100.0 * 
            (CAST(OffRtg AS FLOAT) 
             - MIN(CAST(OffRtg AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST(OffRtg AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST(OffRtg AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS OffRtg_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.OffRtg_Percentile = r.OffRtg_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.OffRtg = r.OffRtg;

COMMIT;

ROLLBACK;


---------------------------------Defensive Rating Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY DefRtg_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD DefRtg_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        DefRtg,
        CAST(100.0 * 
            (CAST(DefRtg AS FLOAT) 
             - MIN(CAST(DefRtg AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST(DefRtg AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST(DefRtg AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS DefRtg_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.DefRtg_Percentile = r.DefRtg_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.DefRtg = r.DefRtg;

COMMIT;

ROLLBACK;

---------------------------------5on5 Offense Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY fiveOff_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD fiveOff_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        [5on5 Off],
        CAST(100.0 * 
            (CAST([5on5 Off] AS FLOAT) 
             - MIN(CAST([5on5 Off] AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST([5on5 Off] AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST([5on5 Off] AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS fiveOff_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.fiveOff_Percentile = r.fiveOff_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.[5on5 Off] = r.[5on5 Off];

COMMIT;

ROLLBACK;


---------------------------------5on5 Defence Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY fiveDef_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD fiveDef_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        [5on5 Def],
        CAST(100.0 * 
            (CAST([5on5 Def] AS FLOAT) 
             - MIN(CAST([5on5 Def] AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST([5on5 Def] AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST([5on5 Def] AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS fiveDef_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.fiveDef_Percentile = r.fiveDef_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.[5on5 Def] = r.[5on5 Def];

COMMIT;

ROLLBACK;

---------------------------------Goals per 60----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY Gper60 DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD Gper60 DECIMAL(6,3);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
		G,
		GP,
		TOI,
		CASE
		WHEN CAST(GP AS INT) >= 30 AND CAST(TOI AS FLOAT) > 0
        THEN (((CAST([G] AS FLOAT)) / (CAST([GP] AS FLOAT)*CAST([TOI] AS FLOAT)))*60)
		ELSE NULL
		END AS Gper60
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.Gper60 = r.Gper60
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team

COMMIT;

ROLLBACK;


---------------------------------Assists per 60----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY Aper60 DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD Aper60 DECIMAL(6,3);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
		A,
		GP,
		TOI,
		CASE
		WHEN CAST(GP AS INT) >= 30 AND CAST(TOI AS FLOAT) > 0
        THEN (((CAST([A] AS FLOAT)) / (CAST([GP] AS FLOAT)*CAST([TOI] AS FLOAT)))*60)
		ELSE NULL
		END AS Aper60
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.Aper60 = r.Aper60
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team

COMMIT;

ROLLBACK;

---------------------------------Points per 60----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY PTSper60 DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD PTSper60 DECIMAL(6,3);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
		PTS,
		GP,
		TOI,
		CASE
		WHEN CAST(GP AS INT) >= 30 AND CAST(TOI AS FLOAT) > 0
        THEN (((CAST([PTS] AS FLOAT)) / (CAST([GP] AS FLOAT)*CAST([TOI] AS FLOAT)))*60)
		ELSE NULL
		END AS PTSper60
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.PTSper60 = r.PTSper60
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team

COMMIT;

ROLLBACK;

---------------------------------Gper60 Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY Gper60_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD Gper60_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        [Gper60],
        CAST(100.0 * 
            (CAST([Gper60] AS FLOAT) 
             - MIN(CAST([Gper60] AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST([Gper60] AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST([Gper60] AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS Gper60_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.Gper60_Percentile = r.Gper60_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.[Gper60] = r.[Gper60];

COMMIT;

ROLLBACK;

---------------------------------Aper60 Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY Aper60_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD Aper60_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        [Aper60],
        CAST(100.0 * 
            (CAST([Aper60] AS FLOAT) 
             - MIN(CAST([Aper60] AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST([Aper60] AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST([Aper60] AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS Aper60_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.Aper60_Percentile = r.Aper60_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.[Aper60] = r.[Aper60];

COMMIT;

ROLLBACK;

---------------------------------PTSper60 Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY PTSper60_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD PTSper60_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        [PTSper60],
        CAST(100.0 * 
            (CAST([PTSper60] AS FLOAT) 
             - MIN(CAST([PTSper60] AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST([PTSper60] AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST([PTSper60] AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS PTSper60_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.PTSper60_Percentile = r.PTSper60_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.[PTSper60] = r.[PTSper60];

COMMIT;

ROLLBACK;

---------------------------------PP Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY PP_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD PP_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        [PP],
        CASE 
            WHEN TRY_CAST([PP] AS FLOAT) = 0 THEN NULL
            ELSE CAST(
                100.0 * 
                (CAST([PP] AS FLOAT) 
                 - MIN(CAST([PP] AS FLOAT)) OVER (PARTITION BY Season)) 
                / NULLIF(
                    MAX(CAST([PP] AS FLOAT)) OVER (PARTITION BY Season) 
                    - MIN(CAST([PP] AS FLOAT)) OVER (PARTITION BY Season), 
                    0
                )
            AS DECIMAL(5,2))
        END AS PP_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.PP_Percentile = r.PP_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.[PP] = r.[PP];

COMMIT;

ROLLBACK;

---------------------------------SH Percentile----------------------------------------------
BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY Season DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD SH_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        [SH],
        CASE 
            WHEN TRY_CAST([SH] AS FLOAT) = 0 THEN NULL
            ELSE CAST(
                100.0 * 
                (CAST([SH] AS FLOAT) 
                 - MIN(CAST([SH] AS FLOAT)) OVER (PARTITION BY Season)) 
                / NULLIF(
                    MAX(CAST([SH] AS FLOAT)) OVER (PARTITION BY Season) 
                    - MIN(CAST([SH] AS FLOAT)) OVER (PARTITION BY Season), 
                    0
                )
            AS DECIMAL(5,2))
        END AS SH_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.SH_Percentile = r.SH_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.[SH] = r.[SH];

COMMIT;

ROLLBACK;