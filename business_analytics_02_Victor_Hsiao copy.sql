/*
hostname: lmu-dev-01.isba.co
username: lmu_dba
password: go_lions
database: tahoe_fuzzy_factory
port: 3306
*/


/*
2 - Website Performance Analytics
*/

/*
2.1 - Top Website Pages
From: Cheryl (Website Manager)
Subject: Top Website Pages
Date: June 09, 2012
Could you help me get my head around the site by pulling the most-viewed website pages ranked by session volume?

Expected results header:
pageview_url             |sessions|
-------------------------+--------+
*/
SELECT
	pageview_url,
	COUNT(website_session_id) AS sessions 
FROM website_pageviews wp 
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY sessions DESC;

/*
2.1 - Insight
???
*/


/*
2.2 - Top Entry Pages
From: Cheryl (Website Manager)
Subject: Top Entry Pages
Date: June 12, 2012
Would you be able to pull a list of the top entry pages? I want to confirm where our users are hitting the site. 
If you could pull all entry pages and rank them on entry volume, that would be great.

Master CTEs for multi-step queries.

Expected results header:
landing_page|sessions|
------------+--------+
*/
-- step1: first first pageview for each SESSION 
WITH first_pageviews AS (
SELECT 
	website_session_id,
	MIN(website_pageview_id) AS min_pageview_id 
FROM website_pageviews wp 
WHERE created_at < '2012-06-12'
GROUP BY website_session_id
)
-- find the url the customer saw on the first page and summarize
SELECT 
	website_pageviews.pageview_url AS landing_page,
	COUNT(first_pageviews.website_session_id) AS sessions 
FROM first_pageviews 
LEFT JOIN website_pageviews
	ON first_pageviews.min_pageview_id = website_pageviews.website_pageview_id 
GROUP BY landing_page
/*
2.2 - Insight
???
*/
-- all traffic comes in through our homepage. Seems obvious where we should be making improvements. 
/*
2.3 - Bounce Rates
From: Cheryl (Website Manager)
Subject: Bounce Rate Analysis
Date: June 14, 2012
All of our traffic is landing on the homepage. Let's check how that landing page is performing. 
Can you pull bounce rates for traffic landing on the homepage? I would like to see three #'s:
Sessions, Bounced Sessions, and Bounce Rate (%of Sessions which Bounced).

STEP 1: find the first (MIN) website_pageview_id for relevant sessions
STEP 2: identify the landing page of each session
STEP 3: count pageviews for each session to identify bounces
STEP 4: summarize total sessions and bounced sessions by landing page

Expected results header:
landing_page|sessions|bounced_sessions|bounce_rate|
------------+--------+----------------+-----------+
*/


WITH landing_page_cte AS (
SELECT 
	p.website_session_id,
	MIN(p.website_pageview_id) AS first_landing_page_id,
	p.pageview_url AS landing_page 
FROM website_pageviews p
JOIN website_sessions s
	ON p.website_session_id = s.website_session_id
 		AND s.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY p.website_session_id
),
bounced_views_cte AS (
SELECT 
	lp.website_session_id,
	lp.landing_page, 
   	COUNT(p.website_pageview_id) AS bounced_views
FROM landing_page_cte lp
JOIN website_pageviews p
	ON lp.website_session_id = p.website_session_id
GROUP BY 
	lp.website_session_id,
	lp.landing_page
HAVING COUNT(p.website_pageview_id) = 1
)
SELECT 	
	lp.landing_page,
	COUNT(DISTINCT lp.website_session_id) AS total_sessions,
	COUNT(DISTINCT b.website_session_id) AS bounced_sessions,
	ROUND(100*COUNT(DISTINCT b.website_session_id)/COUNT(DISTINCT lp.website_session_id),2) AS bounce_rate
FROM landing_page_cte lp 
LEFT JOIN bounced_views_cte b
	ON lp.website_session_id = b.website_session_id
GROUP BY lp.landing_page	
ORDER BY bounce_rate DESC;

/*
2.3 - Insight
???
*/
-- lander 3 has highest bounce rate, then lander 2 then lowest bounce rate is home. 

/*
2.4 - Landing Page Test
From: Cheryl (Website Manager)
Subject: Help Analyzing Landing Page Test
Date: July 28, 2012

Based on your bounce rate analysis, we ran a new custom landing page (/lander-1) in a 50/50 A/B test against 
the homepage (/home) for our gsearch nonbrand traffic. 
Please pull bounce rates for the two groups so we can evaluate the new page. 
Make sure to just look at the time period where /lander-1 was getting traffic so that it's a fair comparison.

STEP 1: find out when the new page, /lander-1, launched
STEP 2: find the first (MIN) website_pageview_id for relevant sessions
STEP 3: identify the landing page of each session
STEP 4: count pageviews for each session to identify bounces
STEP 5: summarize total sessions and bounced sessions by landing page

Expected results header:
landing_page|sessions|bounced_sessions|bounce_rate|
------------+--------+----------------+-----------+
*/


/*
2.4 - Insight
???
*/


/*
2.5 - Landing Page Trend
From: Cheryl (Website Manager)
Subject: Landing Page Trend Analysis
Date: August 31, 2012
Could you pull the volume of paid gsearch nonbrand traffic landing on /home and /lander-1 trended weekly since June 1, 2012? I want to confirm the traffic is correctly routed.
Could you also pull our overall paid gsearch bounce rate trended weekly? 
I want to make sure the lander change has improved the overall picture.

STEP 1: find the first (MIN) website_pageview_id and pageviews count for relevant sessions
STEP 2: identify the landing page of each session
STEP 3: count total sessions and sessions per landing page by week
STEP 4: summarize overall bounce rate per landing page by week

Expected results header:
week_start_date|total_sessions|bounced_sessions|bounce_rate|bounce_rate_percentage_change|home_sessions|lander_sessions|
---------------+--------------+----------------+-----------+-----------------------------+-------------+---------------+
*/


/*
2.5 - Insight
???
*/

