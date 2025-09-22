-- Start a new transaction
BEGIN TRANSACTION;

-- Step 1: Preview current data before making changes
SELECT *
FROM dbo.[Net Rating (07-25)]
ORDER BY NetRtg_Percentile DESC;

-- Step 2: Add a new column to store the calculated NetRtg_Percentile values
ALTER TABLE dbo.[Net Rating (07-25)]
ADD NetRtg_Percentile DECIMAL(5,2);

-- Step 3: Create a Common Table Expression (CTE) "Ranked"
-- This calculates the NetRtg_Percentile for each row within a Season
WITH Ranked AS (
    SELECT 
        Season,
        Player,
        Team,
        NetRtg,
        -- Formula: normalize NetRtg between min and max of the season
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

-- Step 4: Update the main table with the calculated percentile values
UPDATE main
SET main.NetRtg_Percentile = r.NetRtg_Percentile
FROM dbo.[Net Rating (07-25)] AS main
JOIN Ranked AS r
  ON main.Season = r.Season
 AND main.Player = r.Player
 AND main.Team   = r.Team
 AND main.NetRtg = r.NetRtg;

-- Step 5: Save changes permanently
COMMIT;

-- Alternative: Undo all changes made since BEGIN TRANSACTION
ROLLBACK;

DBCC OPENTRAN;
