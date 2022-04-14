/*
hostname: lmu-dev-01.isba.co
username: lmu_dba
password: go_lions
database: tahoe_fuzzy_factory
port: 3306
*/

/*
Key Tables:
1. website_sessions
2. website_pageviews
3. orders
*/
SELECT *
FROM website_sessions
WHERE website_session_id = 1059;

SELECT *
FROM website_pageviews
WHERE website_session_id = 1059;

SELECT *
FROM orders
WHERE website_session_id = 1059;


/*
UTM Tracking Parameters
*/
SELECT DISTINCT utm_source, utm_campaign
FROM website_sessions
ORDER BY utm_source;


/*
1 - Traffic Source Analytics & Optimization
*/

/*
1.1 - Top Traffic Sources
From: Kara (CEO)
Subject: Site Traffic Breakdown
Date: April 12, 2012

We've been live for almost a month and starting to generate sales. Can you help me understand where the bulk of our website 
sessions are coming from through yesterday (April 12, 2012). 
I'd like to see a breakdown by UTM source, campaign, and referring domain.

Expected results header:
utm_source|utm_campaign|http_referer           |sessions|
----------+------------+-----------------------+--------+
*/
SELECT 
	utm_source ,
	utm_campaign ,
	http_referer ,
	COUNT(website_session_id) AS traffic_count 
FROM website_sessions ws 
WHERE ws.created_at <= '2012-04-12 23:59:59'
GROUP BY 
	utm_source, utm_campaign, http_referer ;


/*
1.1 - Insight
???
*/
-- bulk of traffic is from google search and non branded searches
-- Is it worth spending on this traffic source?
-- is it converting to sales?

/*
1.2 - Traffic Source Conversion Rates
From: Robert (Marketing Director)
Subject: gsearch conversion rate
Date: April 14, 2012

Looks like gsearch nonbrand is our major traffic source, but we need to understand if those sessions are driving sales.
Please calculate the conversion rate (CVR) from session to order. 
Based on what we're paying for clicks, we'll need a 4% minimum CVR to make the numbers work. 
If we're much lower, we'll reduce bids. If we're higher, we can increase bids to drive more volume.

Expected results header:
sessions|orders|session_to_order_cvr|
--------+------+--------------------+
*/
-- join orders and website sessions TABLE 
SELECT 
	COUNT(ws.website_session_id) AS sessions ,
	COUNT(o.order_id) AS orders ,
	(COUNT(o.order_id) / COUNT(ws.website_session_id)) AS session_to_order_cvr
FROM website_sessions ws 
LEFT JOIN orders o -- left join because some website sessinos did not convert into an order id !!
	ON ws.website_session_id = o.website_session_id 
WHERE ws.created_at <= '2012-04-14 23:59:59'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand';

/*
1.2 - Insight
???
*/
-- gsearch nonbrand is less than 4% conversion threshold. Reduce our bids on gsearch and nonbrand campaigns.  

/*
1.3 - Traffic Source Trends
From: Robert (Marketing Director)
Subject: gsearch volume trends
Date: May 10, 2012
Based on your conversion rate analysis, we bid down gsearch nonbrand on April 15, 2012. 
Can you pull gsearch nonbranded trended session volume by week? We want to see if the bid changes caused volume to drop.

Expected results header:
week_start_date|sessions|
---------------+--------+
*/
SELECT 
	WEEK(created_at) AS weekly_start_date,
	COUNT(website_session_id) AS sessions
FROM website_sessions ws 
WHERE ws.created_at <= '2012-04-15'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);

/*
1.3 - Insight
???
*/


/*
1.4 - Traffic Source Bid Optimization
From: Robert (Marketing Director)
Subject: gsearch device-level performance
Date: May 11, 2012
I was trying our site on my mobile device, and the UX wasn't great. 
Can you please pull conversion rates from session to order by device type? 
If desktop performance is better than mobile, we can bid up for desktop to get more volume.

Expected results header:
device_type|sessions|orders|cvr   |
-----------+--------+------+------+
*/


/*
1.4 - Insight
???
*/
SELECT 
	device_type,
	COUNT(ws.website_session_id) AS sessions,
	COUNT(o.website_session_id) AS orders,
	( COUNT(o.website_session_id) / COUNT(ws.website_session_id) )*100 AS cvr
FROM website_sessions ws 
LEFT JOIN orders o 
	ON ws.website_session_id = o.website_session_id 
GROUP BY device_type;
-- desktop version has a more succesful conversion rate compared to mobile!

/*
1.5 - Granular Segment Trends
From: Robert (Marketing Director)
Subject: gsearch device-level trends
Date: June 09, 2012
After your device-level conversion rate analysis, we realized desktop was doing well so we bid up our 
gsearch nonbrand desktop campaigns up on May 19, 2012. 
Please generate a weekly trend report for desktop and mobile so we can see the impact on volume. 
Use April 14, 2012 until the bid change as a baseline.

Expected results header:
week_start_date|desktop_sessions|mobile_sessions|
---------------+----------------+---------------+
*/
SELECT 
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(*) AS desktop_sessions 
FROM website_sessions ws 
WHERE created_at BETWEEN '2012-04-14' AND '2012-05-19 23:59:59'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
	AND device_type  = 'desktop'
GROUP BY YEARWEEK(created_at);

/*
1.5 - Insight
???
*/
-- appears that there is a weekly increasing trend in desktop sessions after bidding up gsearch nonbrand desktop campaigns!

