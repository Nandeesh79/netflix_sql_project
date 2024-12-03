--Netflix Project

create table netflix
(
	show_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),	
	casts VARCHAR(1000),
	country	VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(300)
);

Select distinct type 
from netflix;

select * from netflix;

--1. Count the number of movies vs TV shows

select
	type,
	count(*) as total_content
from netflix
group by type; 

--2. List all movies released in a specific year (e.g., 2020)


select * from netflix
where 
	type='Movie'
	and
	release_year = 2020


--3. Find the top 5 countries with the most content on Netflix

select
	unnest (string_to_array(country,',')) as new_country,
	count(show_id) as total_contant
from netflix
group by 1
order by 2 desc
limit 5

--4. Identify the longest movie

select * from netflix
where
	type='Movie'
	and
	duration = (select max(duration) from netflix)

--5. Find content added in the last 5 years

select *
from netflix
where 
	to_date (date_added, 'month dd,yyyy') >= CURRENT_DATE - INTERVAL '5 years'


--6. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where
	director ILIKE '%Rajiv Chilaka%'

--7. List all TV shows with more than 5 seasons

select * from netflix
where
	type = 'TV Show'
	and
	SPLIT_PART(duration,' ',1)::numeric > 5

--8. Count the number of content items in each genre

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

--9. Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

--10. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

--11. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;

--12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
 