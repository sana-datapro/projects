-- SQL Project - Data Cleaning
-- The data is available on the Layoffs Tracher https://layoffs.fyi/, and also in the platform Kaggle 
-- (https://www.kaggle.com/datasets/swaptr/layoffs-2022)
-- The data availability is from when COVID-19 was declared as a pandemic i.e. 11 March 2020 to present (21 Apr 2025).

-- Let's see our data first:
select * 
from world_layoffs.layoffs;

-- first thing we want to do is create a copy of the data to work with, without altering the raw data.

-- so create the table layoffs_copy
drop table if exists layoffs_copy;
create table layoffs_copy
like layoffs;
-- let's insert it with data, same as layoffs table
insert layoffs_copy
select * from layoffs;
select * from layoffs_copy;

-- In data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. check for missing data and handle them
-- 4. remove any columns and rows that are not necessary 
-- -----------------------------------------------------------------------

-- 1. Remove Duplicates

# First let's check for duplicates

select *
from layoffs_copy;

select * 
from(select company, location, total_laid_off,`date`, industry, stage, funds_raised, row_number() over(
	   partition by company, location, total_laid_off,`date`, industry, stage, funds_raised) AS row_num 
       from layoffs_copy) as duplicates
where row_num >1;
-- there are two rows duplicated
           
-- let's just look at Beyond Meat and Cazoo to confirm
select *
from layoffs_copy
where company = 'Beyond Meat'; 

select * 
from layoffs_copy
where company = 'Cazoo';
-- -- there is two real duplicates related to each company(Beyond Meat and Cazoo), we must delete them. 
-- these are the ones we want to delete where the row number is > 1 .
-- Now we can write it like this:
with deleteDuplicates as
(
select * 
from
(
select*,  row_number() over(partition by company, location, total_laid_off,`date`, industry, stage, funds_raised) AS row_num 
from layoffs_copy) as duplicates where row_num >1
)
delete from deleteDuplicates; 

-- I must create a new table layoffs_copy2 and delete from it the rows where the number of rows is more or equal 2. 

drop table if exists layoffs_copy2;
create table `layoffs_copy2` (
  `company` text,
  `location` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` text,
  `country` text,
  `date_added` text,
  row_num int
);
insert into layoffs_copy2(`company`, `location`, `total_laid_off`, `percentage_laid_off`, `date`, `industry`, `source`, `stage`, `funds_raised`, `country`, `date_added`, `row_num`)
select 
`company`,
  `location`,
  `total_laid_off`,
  `percentage_laid_off`,
  `date`,
  `industry`,
  `source`,
  `stage`,
  `funds_raised`,
  `country`,
  `date_added`,
  row_number() over(partition by company, location, total_laid_off,`date`, industry, stage, funds_raised) AS row_num 
from layoffs_copy;

-- now we can delete the duplicates from layoffs_copy2 table:
delete from layoffs_copy2
where row_num>1;


-- 2. Standardize Data

select * 
from layoffs_copy2;

-- if we look at industry it looks like we have some empty rows, let's take a look:

select distinct industry
from layoffs_copy2
order by industry;

-- there are some empty rows in the column 'industry'
select *
from layoffs_copy2
where industry= ''
order by industry;
-- there is only one row with empty industry name, I will add the entry 'Software Development' to this empty cell, because this industry is well known and the input is obvious.
 update layoffs_copy2 
 set industry = 'Software Development'
 where industry = '';

-- Let's look at 'company' column 
select distinct(company)
from layoffs_copy2
order by company;

-- -- Let's look at 'country' column 
select distinct(country)
from layoffs_copy2
order by country;

-- there are no issues with these columns 

-- let's see the 'stage' column:

select distinct(stage)
from layoffs_copy2
order by stage; 
-- some rows are empty in this column. let's see:
select count(*) 
from layoffs_copy2
where stage = '';
-- there are three rows including empty rows in the column 'stage'

-- let's look at total_laid_off, percentage_laid_off, and funds_raised columns, it looks like there are empty rows too. 

select count(*)
from layoffs_copy2
where total_laid_off='';
-- there is no empty rows in the column 'total_laid_off'

select count(*)
from layoffs_copy2
where percentage_laid_off='';
-- there is 817 empty rows in the column 'percentage_laid_off'

select count(*)
from layoffs_copy2
where funds_raised='';
-- there is 259 empty rows in the column 'funds_raised'

-- Let's handle these empty rows, I will fill the missing values with a placeholder(null or 'Unknown') for easier analysis and visualizations.

-- we can't determine the missing data in the column percentage_laid_off, only if we have the total number of employees.
-- let's set empty rows equal to null in the column 'percentage_laid_off' and 'funds_raised', and equal to 'Unknown' in the column 'stage'.

update layoffs_copy2
set percentage_laid_off = null
where percentage_laid_off = '';

update layoffs_copy2
set funds_raised = null
where funds_raised = '';

update layoffs_copy2
set stage = 'Unknown'
where stage = '';

-- Now, let's fix the date column:

select *
FROM layoffs_copy2;

-- we can use 'str to date' to update this field
update layoffs_copy2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- now we can convert the data type properly
alter table layoffs_copy2
modify column `date` DATE;

-- for the columns total_laid_off, percentage_laid_off and funds_raised, I am going to convert them to numeric. 
-- But, I have to remove the dollar sign $ and the percent sign %
update layoffs_copy2
set funds_raised = replace(funds_raised, '$', '');

update layoffs_copy2
set percentage_laid_off = replace(percentage_laid_off, '%', '');
-- convert to number :
alter table layoffs_copy2
modify column funds_raised decimal(10, 2);

alter table layoffs_copy2
modify column percentage_laid_off int;

ALTER TABLE layoffs_copy2
MODIFY COLUMN total_laid_off INT;

-- 3. Look at Null Values
select * 
from layoffs_copy2;

-- only the columns percentage_laid_off and funds_raised include null values. I will see if there are any rows where these two columns are nulls together.
select *
from layoffs_copy2
where total_laid_off is null
and funds_raised is null;

-- No rows where the two columns are null, then, I will keep these columns intact and try to filter when we will use them later.


-- 4. remove any columns and rows we do not need to:

-- I think the columns 'source', 'date_added' and 'row_num' are useless, I am going to drop these three columns.

select * 
from layoffs_copy2;

alter table layoffs_copy2
drop column source,
drop column date_added,
drop column row_num;

-- let's verify:
select * 
from layoffs_copy2;