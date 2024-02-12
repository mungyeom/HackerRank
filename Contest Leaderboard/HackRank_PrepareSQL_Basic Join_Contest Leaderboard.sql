-- You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!

-- The total score of a hacker is the sum of their maximum scores for all of the challenges. 
-- Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. 
-- If more than one hacker achieved the same total score, then sort the result by ascending hacker_id.
--  Exclude all hackers with a total score of 0 from your result.

-- Input Format

-- The following tables contain contest data:

-- Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.
-- Submissions: The submission_id is the id of the submission, 
--              hacker_id is the id of the hacker who made the submission, 
--              challenge_id is the id of the challenge for which the submission belongs to, 
--              and score is the score of the submission.

WITH MaxScores AS (
    SELECT 
        hacker_id,
        challenge_id,
        MAX(score) AS max_score -- Calculate maximum score for each hacker in each challenge
    FROM Submissions
    -- In SQL, whenever I use an aggregation function like COUNT(), SUM(), AVG(), etc.,
    -- I need to use the GROUP BY clause to specify the columns by which the results should be grouped. 
    GROUP BY hacker_id, challenge_id
),
TotalScore AS (
    SELECT 
        ms.hacker_id,
        SUM(ms.max_score) AS total_score -- Sum up the maximum scores to get total score for each hacker
    FROM MaxScores AS ms
    GROUP BY ms.hacker_id
)

SELECT
    h.hacker_id, 
    h.name,
    ts.total_score
FROM 
    TotalScore AS ts
JOIN 
    Hackers AS h ON ts.hacker_id = h.hacker_id
WHERE 
    ts.total_score > 0 -- Exclude hackers with a total score of 0 
ORDER BY
    ts.total_score DESC, -- Sort by total score in descending order
    h.hacker_i ; -- For equal scores, sort by hacker_id in ascending order




-- OR ------------------------------------------------------------------------------

SELECT
    h.hacker_id,
    h.name
    SUM(ms.max_score) AS total_score
FROM
    Hackers AS h
JOIN
(
    SELECT
        s.hacker_id,
        s.challenge_id,
        s.MAX(score) AS max_score
    FROM
        Submissions AS s
    GROUP BY
        s.hacker_id, s.challenge_id
) AS ms ON h.hacker_id = ms.hacker_id
GROUP BY
    h.hacker_id, h.name
HAVING
    SUM(ms.max_score) > 0
ORDER BY
    total_score DESC, h.hacker_id;
