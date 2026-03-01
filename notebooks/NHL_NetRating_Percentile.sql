BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
where Season like '2024-25'
ORDER BY NetRtg_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ALTER COLUMN NetRtg_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        NetRtg,
        CAST(PERCENT_RANK() OVER (
            PARTITION BY Season 
            ORDER BY CAST(NetRtg AS FLOAT)
        ) * 100 AS DECIMAL(5,2)) AS NetRtg_Percentile
    FROM dbo.[Net Rating (07-25)]
)

UPDATE main
SET main.NetRtg_Percentile = r.NetRtg_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.NetRtg = r.NetRtg;

COMMIT;

ROLLBACK;