
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
        