SELECT A.submission_date
        ,B.SUMID
        ,A.hacker_id
        ,C.name
FROM (   SELECT submission_date
        ,hacker_id
        FROM (  SELECT submission_date
                ,hacker_id
                ,ROW_NUMBER() OVER(PARTITION BY submission_date ORDER BY COUNT(DISTINCT submission_id) DESC,hacker_id) RN
                FROM Submissions
                GROUP BY submission_date,hacker_id
              ) MAXSUB
        WHERE RN = 1
        ) A
INNER JOIN ( SELECT submission_date
             ,COUNT(DISTINCT hacker_id) SUMID
             FROM ( SELECT submission_date
                           ,DENSE_RANK() OVER(PARTITION BY hacker_id ORDER BY submission_date) SDN
                           ,CAST(RIGHT(CONVERT(VARCHAR(10),submission_date,121),2) AS INT) CMP
                           ,hacker_id
                    FROM Submissions
                 ) cnmini
              WHERE SDN = CMP
              GROUP BY submission_date
        ) B
ON A.submission_date = B.submission_date
INNER JOIN Hackers C
ON A.hacker_id = C.hacker_id
