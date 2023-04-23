SELECT A.submission_date
        ,A.UniqueHackerID
        ,C.hacker_id
        ,H.name
FROM
(SELECT A.RN
            ,A.submission_date
            ,COUNT(DISTINCT B.hacker_id) AS UniqueHackerID
        FROM ( SELECT ROW_NUMBER() OVER (ORDER BY submission_date) RN
                        ,submission_date 
                        FROM Submissions
                        GROUP BY submission_date 
                ) A
        INNER JOIN (SELECT DENSE_RANK() OVER(PARTITION BY hacker_id ORDER BY submission_date) AS RN
                        ,*
                        FROM Submissions
                ) B
        ON A.RN = B.RN AND A.submission_date = B.submission_date
        GROUP BY A.RN,A.submission_date ) A
INNER JOIN (
SELECT ROW_NUMBER() OVER(PARTITION BY submission_date ORDER BY COUNT(DISTINCT submission_id) DESC,hacker_id) RN
            ,submission_date
            ,hacker_id
            ,COUNT(DISTINCT submission_id) AS MaxSUB
        FROM Submissions
        GROUP BY submission_date,hacker_id) C
ON C.RN=1 AND A.submission_date = C.submission_date
INNER JOIN Hackers H
ON C.hacker_id = H.hacker_id