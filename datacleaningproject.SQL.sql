-- Data cleaning - we're putting th data in a more usable format
select *
from  layoffs;
-- 1. remove duplucates if there are any
-- 2. standardise the data
-- 3. null and blank values
-- 4. remove any columns - but do it carefully

-- save a copy of the og raw data incase of mistakes,dont work on the raw data
create table layoffs_staging
 like layoffs;
 
 select * 
 from layoffs_staging;
 
 insert layoffs_staging
 select *
 from layoffs;
 
 -- step 1 remove duplicates
 select *,
 row_number() over(Partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
 from layoffs_staging;
 
 with duplicate_cte as
 (
	select *,
 row_number() over(Partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
 from layoffs_staging
 )
 select *
 from duplicate_cte
 where row_num > 1;
 
 with duplicate_cte as
 (
	select *,
 row_number() over(Partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
 from layoffs_staging
 )
 delete
 from duplicate_cte
 where row_num > 1; -- cant delete from a cte so we need to find another method
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select distinct * 
from layoffs_staging2;

insert into layoffs_staging2
select *,
 row_number() over(Partition by company, location, industry, total_laid_off , percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging;

DELETE
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2
where row_num > 1;
-- duplicates have now been removed

-- 2. standardisation where we find issues in the data and fix it

select company,(trim(company))
from  layoffs_staging2;
 
 update layoffs_staging2
 set company = trim(company);
 
 select *
 from layoffs_staging2
 where industry LIKE 'Crypto%';
 
 update layoffs_staging2
 set industry = 'Crypto'
 where industry like 'Crypto%';
 
 select *
 from layoffs_staging2;
 
 select distinct country,trim(trailing '.' from country)
 from layoffs_staging2
 order by 1;
 
 update layoffs_staging2
 set country = trim(trailing '.' from country)
 where country like 'United States%';
 
 select  *
 from layoffs_staging2;
 
 update layoffs_staging2
 set `date` = str_to_date(`date`,'%m/%d/%Y'); 
 
 alter table layoffs_staging2
 modify column `date` date; -- should only be done on the replica not the original
 
  select  *
 from layoffs_staging2
 where total_laid_off is NULL
 and percentage_laid_off is NULL;
 
 select *
 from layoffs_staging2
 where industry is null or industry = '';
 
 select *
 from layoffs_staging2
 where company like 'Bally%';
 
 
 
 select t1.industry,t2.industry
 from layoffs_staging2 t1
 join layoffs_staging2 t2
 on t1.company = t2.company and t1.location = t2.location
 where (t1.industry is null or t1.industry = '') and t2.industry is not null;
 
 update layoffs_staging2 t1
 join layoffs_staging2 t2
  on t1.company = t2.company 
  set t1.industry = t2.industry
 where (t1.industry is null or t1.industry = '') and t2.industry is not null; 
 
 update layoffs_staging2
 set industry = null
 where industry = ''; -- set all the empty spaces to null before joining them
 
 update layoffs_staging2 t1
 join layoffs_staging2 t2
  on t1.company = t2.company 
  set t1.industry = t2.industry
 where (t1.industry is null or t1.industry = '') and t2.industry is not null; 
 
 select *
 from layoffs_staging2
 where total_laid_off is null 
 and percentage_laid_off is null;
 
 delete
 from layoffs_staging2
 where total_laid_off is null 
 and percentage_laid_off is null;
 
 alter table layoffs_staging2
 drop column row_num;
 
 select *
 from layoffs_staging2;
 -- data cleaning complete well done mwanaaaaaaaaa!!!
 -- TRY AGAIN . There were still duplicated rows
 select *,
 row_number() over(Partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
 from layoffs_staging;
 
with duplicate_cte as
 (
	select *,
 row_number() over(Partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
 from layoffs_staging
 )
 select *
 from duplicate_cte
 where row_num > 1;
 
 CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging3
where row_num > 1;

insert into layoffs_staging3
select *,
 row_number() over(Partition by company,location,
 industry,total_laid_off,percentage_laid_off,`date`,stage,
 country,funds_raised_millions) as row_num
 from layoffs_staging;

delete
from layoffs_staging3
where row_num > 1;

select *
from layoffs_staging3
where row_num > 1;

-- duplicates have been removed
select *
from layoffs_staging3;

-- standardising data 

select (trim(company)), company
from layoffs_staging3;

 update layoffs_staging3
 set company = trim(company);
 
 select *
 from layoffs_staging3
 where industry LIKE 'Crypto%';
 
 update layoffs_staging3
 set industry = 'Crypto'
 where industry like 'Crypto%';
 
 select distinct country, trim(trailing '.' from country)
 from layoffs_staging3
order by 1;
 
 select *
 from layoffs_staging3;
 
 select distinct country,trim(trailing '.' from country)
 from layoffs_staging2
 order by 1;
 
 update layoffs_staging3
 set country = trim(trailing '.' from country)
 where country like 'United States%';
 
 select  *
 from layoffs_staging3
 where country like 'United States%';
 
 select `date`,
 str_to_date(`date`, '%m/%d/%Y')
 from layoffs_staging3;
 
 update layoffs_staging3
 set `date` = str_to_date(`date`,'%m/%d/%Y'); 
 
 alter table layoffs_staging3
 modify column `date` DATE; -- should only be done on the replica not the original
 -- date format has been changed
 
 -- looking at null and blank values
  select  *
 from layoffs_staging3
 where total_laid_off is NULL
 and percentage_laid_off is NULL;
 
 select *
 from layoffs_staging3
 where industry is null or industry = '';
 
 select *
 from layoffs_staging3
 where company like 'Bally%';
 
 
 
 select t1.industry,t2.industry
 from layoffs_staging3 t1
 join layoffs_staging3 t2
 on t1.company = t2.company
 and t1.location = t2.location
 where (t1.industry is null or t1.industry = '') and t2.industry is not null;
 
 update layoffs_staging3 t1
 join layoffs_staging3 t2
  on t1.company = t2.company 
  set t1.industry = t2.industry
 where (t1.industry is null or t1.industry = '') and t2.industry is not null; 
 -- did not work so we will try to set the empty values to null first
 
 update layoffs_staging3
 set industry = NULL
 where industry = ''; -- set all the empty spaces to null before joining them
 
 update layoffs_staging3 t1
 join layoffs_staging3 t2
  on t1.company = t2.company 
  set t1.industry = t2.industry
 where t1.industry is null  and t2.industry is not null; -- now all the rows have been updated
 
 select *
 from layoffs_staging3;
 
 select *
 from layoffs_staging3
 where total_laid_off is null 
 and percentage_laid_off is null;
 
 delete
 from layoffs_staging3
 where total_laid_off is null 
 and percentage_laid_off is null;
 
 alter table layoffs_staging3
 drop column row_num;
 
 select *
 from layoffs_staging3;
 
 -- Okay now you have correctly cleaned the data lmaooo