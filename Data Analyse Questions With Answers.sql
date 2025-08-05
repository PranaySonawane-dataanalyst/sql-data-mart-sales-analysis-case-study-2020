use case1;

create table clean_weekly_sales as 
select
	ws.week_date,
    FLOOR((DAYOFYEAR(week_date) - 1) / 7) + 1 as week_number,
    month(ws.week_date) as month_number,
    year(ws.week_date) as calendar_year,
    ws.region,
    ws.platform,
    case
		when
			ws.segment = 'null'
		then
			'Unknown'
		else
			ws.segment
	end as segment,
    case
		when
			right(ws.segment,1) = '1'
		then
			'Young adults'
		when
			right(ws.segment,1) = '2'
		then
			'Middle Aged'
		when
			right(ws.segment,1) in ('3','4')
		then
			'Retirees'
		else
			'Unknown'
	end as age_band ,
    case
		when
			left(ws.segment,1) in ('C')
		then
			'Couples'
		when
			left(ws.segment,1) in ('F')
		then
			'Families'
		else
			'Unknown'
	end as demographic ,
    ws.customer_type,
    ws.transactions,
    ws.sales,
	case
		when
			ws.transactions = 0
		then
			0
		else
			round((ws.sales / ws.transactions),2)
	end as avg_transaction
from
	weekly_sales as ws;

-- 1.Which week numbers are missing from the dataset ? 

with recursive numbers as (
	select
		1 as week_numbers
	
    union all
    
    select
		week_numbers + 1
	from
		numbers
	where
		week_numbers < 52
)

select
	n.week_numbers
from
	numbers as n
left join
	clean_weekly_sales as cws on n.week_numbers = cws.week_number
where
	cws.week_number is null ;

-- 2.How many total transactions were there for each year in the dataset ?

select
	cws.calendar_year,
    sum(cws.transactions) as total_transactionsper_year
from
	clean_weekly_sales as cws
group by
	cws.calendar_year
order by
	cws.calendar_year;

-- 3.What are the total sales for each region for each month ?

select
	cws.region,
    cws.month_number,
	sum(cws.sales) total_sales
from
	clean_weekly_sales as cws
group by
    cws.month_number,
    cws.region
order by
    cws.month_number,
	cws.region;
    
-- 4.What is the total count of transactions for each platform ?

select
	cws.platform,
    count(cws.platform) as transactions_happenper_platform,
    sum(cws.transactions) as total_transactions
from
	clean_weekly_sales as cws
group by
	cws.platform;
    
-- 5.What is the percentage of sales for Retail vs Shopify for each month ? 

WITH monthly_platform_sales AS (
  SELECT
    month_number,
    calendar_year,
    platform,
    SUM(sales) AS monthly_sales
  FROM clean_weekly_sales
  GROUP BY 
	month_number,
    calendar_year, 
    platform
)

SELECT
  calendar_year,
  month_number,
  round(
	max(case when mps.platform = 'Retail' then mps.monthly_sales else null end) * 100 / 
	sum(mps.monthly_sales),
	2
	) as retail_percentage,
  round(
	max(case when mps.platform = 'Shopify' then mps.monthly_sales else null end) * 100 / 
    sum(mps.monthly_sales),
    2
	) as shopify_percentage
FROM 
	monthly_platform_sales as mps
GROUP BY 
	month_number,
    calendar_year
ORDER BY 
	month_number,
    calendar_year;

-- 6.	What is the percentage of sales by demographic for each year in the dataset ? 

with total_yearly_sales as (
	select
		cws.calendar_year,
        sum(cws.sales) as yearly_sales
	from
		clean_weekly_sales as cws
	group by
		cws.calendar_year
)

select
	cws.calendar_year,
    cws.demographic,
    sum(cws.sales) as per_demo_yearly_sales,
    round(
		(sum(cws.sales) * 100.0) /
        (tys.yearly_sales),
        2
	) as percentage_of_sales
from
	clean_weekly_sales as cws
inner join
	total_yearly_sales as tys on tys.calendar_year = cws.calendar_year
group by
	cws.calendar_year,
    cws.demographic,
    tys.yearly_sales
order by
	cws.calendar_year;
    
-- 7.Which age_band and demographic values contribute the most to Retail sales ?

with age_band_contri as (
	select
        cws.age_band,
		sum(cws.sales) as contriof_ageband
	from
		clean_weekly_sales as cws
	where
		cws.age_band != 'Unknown'
		and
        cws.platform = 'Retail'
	group by
		cws.age_band
),

age_band_maxcontri as (
	select
        abc.age_band,
        contriof_ageband as highest_contri_ageband
	from
		age_band_contri as abc
	order by
		highest_contri_ageband desc
	limit 1
),

demographic_contri as (
	select
        cws.demographic,
		sum(cws.sales) as demosales
	from
		clean_weekly_sales as cws
	where
		cws.demographic != 'Unknown'
        and
        cws.platform = 'Retail'
	group by
		cws.demographic
),

demographic_maxcontri as (
	select
        dc.demographic,
        dc.demosales as highest_contri_demographic
	from
		demographic_contri as dc
	order by
		highest_contri_demographic desc
	limit 1
)

select
	abm.age_band,
    abm.highest_contri_ageband,
    dgm.demographic,
    dgm.highest_contri_demographic
from
	age_band_maxcontri as abm
cross join
    demographic_maxcontri as dgm;



	








