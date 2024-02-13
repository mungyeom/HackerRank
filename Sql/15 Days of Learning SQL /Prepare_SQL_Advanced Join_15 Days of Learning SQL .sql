-- Julia conducted a 15 days of learning SQL contest.
-- The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

-- Write a query to print total number of unique hackers who made at least 1 submission each day (starting on the first day of the contest), 
-- and find the hacker_id and name of the hacker who made maximum number of submissions each day.
--  If more than one such hacker has a maximum number of submissions, print the lowest hacker_id.
-- The query should print this information for each day of the contest, sorted by the date.

-- Input Format

-- The following tables hold contest data:

-- Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.

-- Submissions: The submission_date is the date of the submission,
--              submission_id is the id of the submission,
--              hacker_id is the id of the hacker who made the submission, 
--              and score is the score of the submission.

SELECT
    submission_date, --The query should print this information for each day of the contest
    (SELECT 
        COUNT(DISTINCT hacker_id ) --  print total number of unique hackers for each day
    FROM 
        Submissions AS Sub2 -- Sub2: Refers to the submissions made on a specific day (Sub1.submission_date). 
    WHERE -- Conditions affect "FROM"
        Sub2.submission_date = Sub1.submission_date AND 
        (SELECT 
            COUNT(DISTINCT Sub3.submission_date) 
        FROM 
            Submissions AS Sub3 -- Used to count how many different days a hacker (Sub2.hacker_id) has made submissions prior to the current day (Sub1.submission_date).
        WHERE -- Cindutions: looking at the same hacker's submissions but only on days before the current day being evaluated.
            Sub3.hacker_id = Sub2.hacker_id
        AND 
            Sub3.submission_date < Sub1.submission_date) = DATEDIFF(Sub1.submission_date, '2016-03-01')), -- Which is the total number of days from the start of the contest to the current day being evaluated (excluding the current day).
    (SELECT 
        HACKER_ID
    FROM
        Submissions AS Sub2
    WHERE
        Sub2.submission_date = Sub1.submission_date
    GROUP BY
        hacker_id
    ORDER BY
        COUNT(submission_id) DESC, hacker_id LIMIT 1) AS TopSubmitter,
    (SELECT
        name
    FROM
        Hackers
    WHERE
        hacker_id = TopSubmitter)
    FROM
        (SELECT
            DISTINCT submission_date
                FROM
                    Submissions) AS Sub1
GROUP BY
    submission_date;



-- While Sub1.submission_date, Sub2.submission_date, and the dates in Sub3 all relate to submission dates,
-- Sub1.submission_date is the current day being evaluated, 
-- Sub2.submission_date ensures we're looking at submissions made on that current day, and
-- Sub3 checks the hacker's activity on all previous days of the contest to ensure continuous daily participation.



