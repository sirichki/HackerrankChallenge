SELECT A.contest_id
        ,A.hacker_id
        ,A.name
        ,SUM(B.TS)
        ,SUM(B.TAS)
        ,SUM(C.TV)
        ,SUM(C.TUV)
FROM (
SELECT  C.challenge_id
        ,A.contest_id
        ,A.hacker_id
        ,A.name
FROM Contests A
INNER JOIN Colleges B
ON A.contest_id = B.contest_id
INNER JOIN Challenges C
ON B.college_id = C.college_id
) A
LEFT JOIN (SELECT  challenge_id
        ,SUM(total_submissions) TS
        ,SUM(total_accepted_submissions) TAS
FROM Submission_Stats
GROUP BY challenge_id ) B
ON A.challenge_id = B.challenge_id
LEFT JOIN (SELECT  challenge_id
        ,SUM(total_views) TV
        ,SUM(total_unique_views) TUV
FROM View_Stats
GROUP BY challenge_id) C
ON A.challenge_id = C.challenge_id
GROUP BY A.contest_id,A.hacker_id,A.name
HAVING (SUM(B.TS)+SUM(B.TAS)+SUM(C.TV)+SUM(C.TUV)) > 0
ORDER BY 1
