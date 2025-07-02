

-- SQL project: EDA
-- The data is available on the Layoffs Tracher https://layoffs.fyi/, and also in the platform Kaggle 
-- (https://www.kaggle.com/datasets/swaptr/layoffs-2022)
-- The data availability is from when COVID-19 was declared as a pandemic i.e. 11 March 2020 to present (21 Apr 2025).

-- Here we are going to explore the data and find trends or patterns or anything interesting like outliers
-- we are just going to look around and see what we find!

select * 
from layoffs_copy2;


-- let's see the maximum of total layoffs in a single day.
select MAX(total_laid_off)
from layoffs_copy2;

select *
from layoffs_copy2
where total_laid_off = (
select MAX(total_laid_off)
from layoffs_copy2);

-- The Intel company in Sacramento has the maximum total number of employees laid off in april 2025.

-- Looking at Percentage to see how big these layoffs were:
select MAX(percentage_laid_off),  MIN(percentage_laid_off)
from layoffs_copy2
where  percentage_laid_off is not null;
-- Some companies have 100 % of their workers laid off, so we can say totally broke.

-- Which companies had 100 percent of they company laid off? let's see:
select *
from layoffs_copy2
where  percentage_laid_off = 100 ;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funds_raised, we can see how big some of these companies were:
select *
from layoffs_copy2
where  percentage_laid_off = 100
order by funds_raised desc;
-- BritishVolt looks like an EV company, raised like 2 billion dollars and went under.

-- Now, let's try to find the Companies with the biggest single Layoff.

-- Companies with the most Total Layoffs
select company, SUM(total_laid_off)
from layoffs_copy2
group by company
order by 2 desc
limit 10;
-- Intel is mostly associated with the maximum layoffs.

-- locations with the most total layoffs (by location)
select location, SUM(total_laid_off)
from layoffs_copy2
group by location
order by 2 desc
limit 10;
-- SF Bay Area (california) is the location mostly related to layoffs.

-- Countries mostly associated with the maximum layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_copy2
GROUP BY country
ORDER BY 2 DESC;

-- United States is associated with the maximum layoffs.

-- Now, let's look at the total layoffs in the past 3 years.

select year(date), SUM(total_laid_off)
from layoffs_copy2
group by year(date)
order by 1 asc;
-- The maximum layoffs is in 2023. Then, the situation has been changed to better. There is a decrease in layoffs in 2024 and 2025. 
-- Intel is associated with max layoffs let's seen what year is mostly have more layoffs.
select company,  year(date), SUM(total_laid_off)
from layoffs_copy2
where company = 'Intel'
group by year(date)
order by 2 asc;
-- Intel experienced significant workforce reductions in 2024 and 2025. 
-- However, the company remained stable and did not report any layoffs during the COVID-19 period. So, this workforce reduction may be related to the broader economic slowdown.

select industry, SUM(total_laid_off)
from layoffs_copy2
group by industry
order by 2 desc;
-- Hardware, Consumer and Retail are associated with more layoffs.

select stage, SUM(total_laid_off)
from layoffs_copy2
group by stage
order by 2 desc;
-- Post_IPO is the stage associated with more layoffs.

-- Earlier we looked at Companies with the most Layoffs. Now let's look rank them.

with company_year as 
(
select company, year(date) as years, sum(total_laid_off) as total_laid_off
from layoffs_copy2
group by company, year(date)
)
, company_year_rank as (
select company, years, total_laid_off, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
)
select company, years, total_laid_off, ranking
from company_year_rank
where ranking <=3
order by years asc, total_laid_off desc;

-- In 2025, Intel, Microsoft and Meta are ranked the best in relation to layoffs. Besides they have the more significant number of layoffs. So, it would be more accurate if we evaluate this using percentages. 
-- This company is very large  and the layoffs number can be small compared to the total number of workers. 
select * from layoffs_copy2
where company = 'Intel';
-- We have not either the total number of employees, nor the percentage of layoffs. 


-- Now, let's do a Rolling of Total Layoffs Per Month
select substring(date, 1, 7) as dates, sum(total_laid_off) as total_laid_off
from layoffs_copy2
group by dates
order by dates asc;

-- now use it in a CTE so we can query off of it
with date_cte as
( 
select substring(date, 1, 7) as dates, sum(total_laid_off) as total_laid_off
from layoffs_copy2
group by dates
order by dates asc
)
select dates, sum(total_laid_off) over (order by dates asc) as rollings_laid_off
from date_cte
order by dates asc;
