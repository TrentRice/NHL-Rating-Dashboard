BEGIN TRANSACTION;

ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN OffRtg_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN DefRtg_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN fiveOff_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN fiveDef_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN Gper60_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN Aper60_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN PTSper60_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN PP_Percentile DECIMAL(5,2);
ALTER TABLE dbo.[Net Rating (07-25)] ALTER COLUMN SH_Percentile DECIMAL(5,2);

WITH CalculatedStats AS (
    SELECT 
        Season, Player, Team,
        -- Check for GP >= 30
        CASE WHEN TRY_CAST(GP AS FLOAT) >= 30 AND TRY_CAST(TOI AS FLOAT) > 0 
             THEN (TRY_CAST(G AS FLOAT) / (TRY_CAST(GP AS FLOAT) * TRY_CAST(TOI AS FLOAT)) * 60) 
        END AS calc_G60,
        CASE WHEN TRY_CAST(GP AS FLOAT) >= 30 AND TRY_CAST(TOI AS FLOAT) > 0 
             THEN (TRY_CAST(A AS FLOAT) / (TRY_CAST(GP AS FLOAT) * TRY_CAST(TOI AS FLOAT)) * 60) 
        END AS calc_A60,
        CASE WHEN TRY_CAST(GP AS FLOAT) >= 30 AND TRY_CAST(TOI AS FLOAT) > 0 
             THEN (TRY_CAST(PTS AS FLOAT) / (TRY_CAST(GP AS FLOAT) * TRY_CAST(TOI AS FLOAT)) * 60) 
        END AS calc_P60
    FROM dbo.[Net Rating (07-25)]
),

RankedStats AS (
    SELECT 
        m.*,
        cs.calc_G60, cs.calc_A60, cs.calc_P60,
        -- Use TRY_CAST for the ORDER BY columns to ensure strings like '-1.4' are treated as numbers
        PERCENT_RANK() OVER (PARTITION BY m.Season ORDER BY TRY_CAST(m.OffRtg AS FLOAT)) * 100 AS pct_Off,
        PERCENT_RANK() OVER (PARTITION BY m.Season ORDER BY TRY_CAST(m.DefRtg AS FLOAT)) * 100 AS pct_Def,
        PERCENT_RANK() OVER (PARTITION BY m.Season ORDER BY TRY_CAST(m.[5on5 Off] AS FLOAT)) * 100 AS pct_5Off,
        PERCENT_RANK() OVER (PARTITION BY m.Season ORDER BY TRY_CAST(m.[5on5 Def] AS FLOAT)) * 100 AS pct_5Def,
        PERCENT_RANK() OVER (PARTITION BY m.Season ORDER BY cs.calc_G60) * 100 AS pct_G60,
        PERCENT_RANK() OVER (PARTITION BY m.Season ORDER BY cs.calc_A60) * 100 AS pct_A60,
        PERCENT_RANK() OVER (PARTITION BY m.Season ORDER BY cs.calc_P60) * 100 AS pct_P60,
        CASE WHEN TRY_CAST(m.PP AS FLOAT) <> 0 THEN PERCENT_RANK() OVER 
        (PARTITION BY m.Season ORDER BY TRY_CAST(m.PP AS FLOAT)) * 100 END AS pct_PP,
        CASE WHEN TRY_CAST(m.SH AS FLOAT) <> 0 THEN PERCENT_RANK() OVER 
        (PARTITION BY m.Season ORDER BY TRY_CAST(m.SH AS FLOAT)) * 100 END AS pct_SH
    FROM dbo.[Net Rating (07-25)] m
    JOIN CalculatedStats cs ON m.Player = cs.Player AND m.Season = cs.Season AND m.Team = cs.Team
)

UPDATE main
SET 
    main.OffRtg_Percentile = CAST(r.pct_Off AS DECIMAL(5,2)),
    main.DefRtg_Percentile = CAST(r.pct_Def AS DECIMAL(5,2)),
    main.fiveOff_Percentile = CAST(r.pct_5Off AS DECIMAL(5,2)),
    main.fiveDef_Percentile = CAST(r.pct_5Def AS DECIMAL(5,2)),
    main.Gper60_Percentile = CAST(r.pct_G60 AS DECIMAL(5,2)),
    main.Aper60_Percentile = CAST(r.pct_A60 AS DECIMAL(5,2)),
    main.PTSper60_Percentile = CAST(r.pct_P60 AS DECIMAL(5,2)),
    main.PP_Percentile = CAST(r.pct_PP AS DECIMAL(5,2)),
    main.SH_Percentile = CAST(r.pct_SH AS DECIMAL(5,2))
FROM dbo.[Net Rating (07-25)] AS main
JOIN RankedStats r ON main.Player = r.Player AND main.Season = r.Season AND main.Team = r.Team;

SELECT *
FROM dbo.[Net Rating (07-25)]
where Season like '2024-25'
ORDER BY DefRtg_Percentile DESC;

COMMIT;
ROLLBACK;