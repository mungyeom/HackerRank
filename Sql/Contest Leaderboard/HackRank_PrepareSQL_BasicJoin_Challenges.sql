<!-- Julia asked her students to create some coding challenges. 
-- Write a query to print the hacker_id, name, and the total number of challenges created by each student. 
-- Sort your results by the total number of challenges in descending order. 
-- If more than one student created the same number of challenges, then sort the result by hacker_id. 
-- If more than one student created the same number of challenges 
-- and the count is less than the maximum number of challenges created, then exclude those students from the result.

-- The following tables contain challenge data: (Input Format)

-- Hackers: The hacker_id (Integer) is the id of the hacker, and name (String) is the name of the hacker.
-- Challenges: The challenge_id (Integer) is the id of the challenge, and hacker_id (Integer) is the id of the student who created the challenge.  -->



-- "WITH" defines a Common Table Expression. - a temporary result set that I can reference
-- within a SELECT, INSERT, UPDATE, or DELETE statement.
WITH ChallengeCounts AS (
     -- Aggregate the total number of challenges per hacker
    SELECT h.hacker_id, h.name, COUNT(c.challenge_id) AS total_challenges 
    FROM Hackers AS h
    JOIN Challenges AS c ON h.hacker_id = c.hacker_id
    -- In SQL, whenever I use an aggregation function like COUNT(), SUM(), AVG(), etc.,
    -- I need to use the GROUP BY clause to specify the columns by which the results should be grouped. 
    GROUP by h.hacker_id, h.name
),
MaxChllengeCount AS(
    -- Find the maximum number of challenges created by any hacker
    SELECT MAX(total_challenges) AS max_challenges
    FROM ChallengeCounts
)

SELECT cc.hacker_id, cc.name, cc.total_challenges
FROM ChallengeCounts AS cc
JOIN MaxChllengeCount AS mcc ON cc.total_challenges = mcc.max_challenges
    -- "OR(cc.total_challenges IN (...))" is used in my query to include rows
    --  where the hacker's total challenge count matches any of the unique challenge counts identified by the subquery. 
    --  It acts as a condition to broaden the selection criteria, ensuring that hackers with a unique number of challenges (even if not the maximum) are also included in the final result set.
    OR (cc.total_challenges IN (
        -- Select total_challenges values that are unique in the dataset
        SELECT total_challenges
        FROM ChallengeCounts
        GROUP BY total_challenges
        HAVING COUNT(*) = 1 
        -- HAVING: This is similar to the WHERE clause, 
        -- but it's used to filter groups of data after they've been aggregated with GROUP BY. 
        -- While WHERE filters rows before they're grouped, HAVING filters the groups after aggregation.
        -- COUNT(*): This function counts the number of rows in each group. COUNT(*) includes all rows, including those with null values in any columns.
        -- = 1: This specifies that we're only interested in groups where the count is exactly one.
    ))
ORDER BY cc.total_challenges DESC, cc.hacker_id;


