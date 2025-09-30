BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY NetRtg_Percentile DESC;

ALTER TABLE dbo.[Net Rating (07-25)]
ADD NetRtg_Percentile DECIMAL(5,2);

WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        NetRtg,
        CAST(100.0 * 
            (CAST(NetRtg AS FLOAT) 
             - MIN(CAST(NetRtg AS FLOAT)) OVER (PARTITION BY Season)) 
            / NULLIF(
                MAX(CAST(NetRtg AS FLOAT)) OVER (PARTITION BY Season) 
                - MIN(CAST(NetRtg AS FLOAT)) OVER (PARTITION BY Season), 
                0
              )
            AS DECIMAL(5,2)) AS NetRtg_Percentile
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