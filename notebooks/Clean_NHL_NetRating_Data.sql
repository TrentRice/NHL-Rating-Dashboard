BEGIN TRANSACTION;

SELECT *
FROM dbo.[Net Rating (07-25)]

UPDATE dbo.[Net Rating (07-25)]
SET Season =
    '20' + RIGHT(Season, 2) + '-' +
    RIGHT('0' + CAST((CAST(RIGHT(Season, 2) AS INT) + 1) % 100 AS VARCHAR(2)), 2)
WHERE Season LIKE '[A-Za-z][A-Za-z][A-Za-z]-%';

COMMIT;