-- # 2
SELECT * FROM users LIMIT 5;
SELECT * FROM progress LIMIT 5;

-- SELECT COUNT(*) FROM users
-- WHERE email_domain LIKE "%.edu";

-- What are the Top 25 schools (.edu domains)?
SELECT email_domain, COUNT(*) 
FROM users
GROUP BY email_domain
ORDER BY COUNT(*) DESC
LIMIT 25;

-- How many .edu learners are located in New York?
SELECT COUNT(*) AS "Num of Leaners in New York" 
FROM users
WHERE city = "New York";

-- How many of these Codecademy learners are using the mobile app?
SELECT COUNT(*) AS "Num of mobile app learners" 
FROM users
WHERE mobile_app = "mobile-user";

-- #3
-- strftime(format, column) function test
SELECT sign_up_at,
   strftime('%S', sign_up_at)
FROM users
GROUP BY 1
LIMIT 20;

-- query for the sign up counts for each hour
SELECT strftime('%H', sign_up_at) AS "Each Hour", COUNT(*) AS "SignUpCount"
FROM users
GROUP BY 1
LIMIT 10;

-- #4
-- Join the two tables
-- Do different schools (.edu domains) prefer different courses? >> Most schools have high learner percetage in Sql, JavaScript, and Cpp.
WITH joined_stats AS (
  SELECT
    users.email_domain AS "Domain",
    COUNT (*) AS "NumOfLearners",
    SUM(CASE WHEN progress.learn_cpp != '' THEN 1 ELSE 0 END) AS "CppCount",
    SUM(CASE WHEN progress.learn_sql != '' THEN 1 ELSE 0 END) AS "SqlCount",
    SUM(CASE WHEN progress.learn_html != '' THEN 1 ELSE 0 END) AS "HtmlCount",
    SUM(CASE WHEN progress.learn_javascript != '' THEN 1 ELSE 0 END) AS "JSCount",
    SUM(CASE WHEN progress.learn_java != '' THEN 1 ELSE 0 END) AS "JavaCount"
    FROM users
    JOIN progress 
    ON users.user_id = progress.user_id
    GROUP BY 1
    ORDER BY 2 DESC
)
SELECT 
  Domain,
  NumOfLearners,
  ROUND(1.0 * CppCount / NumOfLearners*100 ,2) AS "Cpp%",
  ROUND(1.0 * SqlCount / NumOfLearners*100 ,2) AS "Sql%",
  ROUND(1.0 * HtmlCount / NumOfLearners*100 ,2) AS "Html%",
  ROUND(1.0 * JSCount / NumOfLearners*100 ,2) AS "JS%",
  ROUND(1.0 * JavaCount / NumOfLearners*100 ,2) AS "Java%"
FROM joined_stats
LIMIT 25;


-- What courses are the New Yorkers students taking?
-- What courses are the Chicago students taking?
SELECT 
  city,
  SUM(CASE WHEN progress.learn_cpp != '' THEN 1 ELSE 0 END) AS "CppCount",
  SUM(CASE WHEN progress.learn_sql != '' THEN 1 ELSE 0 END) AS "SqlCount",
  SUM(CASE WHEN progress.learn_html != '' THEN 1 ELSE 0 END) AS "HtmlCount",
  SUM(CASE WHEN progress.learn_javascript != '' THEN 1 ELSE 0 END) AS "JSCount",
  SUM(CASE WHEN progress.learn_java != '' THEN 1 ELSE 0 END) AS "JavaCount"
FROM users
JOIN progress 
ON users.user_id = progress.user_id
GROUP BY city
HAVING city in ("New York", "Chicago");



