-- Netflix Project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(300)

);

SELECT *FROM netflix;


SELECT COUNT(*) AS total_content FROM netflix;

SELECT DISTINCT type FROM netflix;

SELECT *FROM netflix;


-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
	
		SELECT * FROM netflix;
		SELECT type, COUNT(*) AS number_of_movies FROM netflix
		GROUP BY type;



-- 2. Find the most common rating for movies and TV shows
		
		SELECT * FROM netflix;
		select type,rating from (
		select type, rating, count(*), rank() over (partition by type order by count(*) desc) as ranking
		from netflix
		group by type, rating
		) as t1
		where t1.ranking=1;




-- 3. List all movies released in a specific year (e.g., 2020)

		SELECT * FROM netflix;
		SELECT title FROM netflix
		WHERE type = 'Movie' AND release_year = 2020;




-- 4. Find the top 5 countries with the most content on Netflix

		SELECT UNNEST(STRING_TO_ARRAY(country,','))AS new_country,count(show_id) AS total_content
		FROM netflix
		GROUP BY 1
		ORDER BY count(show_id) desc;




-- 5. Identify the longest movie

		SELECT * FROM netflix
		WHERE type= 'Movie' AND 
		duration =(SELECT MAX(duration) FROM netflix);
		



-- 6. Find content added in the last 5 years

		SELECT * FROM netflix 
		WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years';





-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

		SELECT * FROM netflix
		WHERE director LIKE '%Rajiv Chilaka%';
		
	


		
-- 8. List all TV shows with more than 5 seasons

		SELECT * FROM netflix
		WHERE type='TV Show'
		AND
		SPLIT_PART(duration,' ',1)::numeric>5;
	



		
-- 9. Count the number of content items in each genre

		SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))),COUNT(show_id) AS total_count
		FROM netflix
		GROUP BY 1;
		




-- 10.Find each year and its percentage share of Indian content per year added on netflix. 

		SELECT 
  		EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
  		COUNT(*) AS yearly_content,
  		ROUND(
    	COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix WHERE country = 'India'),
    	2
  		) AS percentage_content
		FROM netflix
		WHERE country = 'India'
		GROUP BY 1
		ORDER BY 1;






-- 11. List all movies that are documentaries

		SELECT * FROM netflix
		WHERE listed_in ILIKE '%documentaries%';
		




-- 12. Find all content without a director

		SELECT * FROM netflix
		WHERE director IS NULL;




-- 13. Find in how many movies actor 'Salman Khan' appeared in last 10 years!

		SELECT * FROM netflix
		WHERE casts ILIKE '%Salman khan%' AND type='Movie'
		AND release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;




-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

		SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) AS Actor,COUNT(show_id) AS Movies 
		FROM netflix
		WHERE country ILIKE '%India%'
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10;





-- 15.Categorize the content based on the presence of the keywords 'kill' or 'violence' in 
-- the description field. Label content containing these keywords as 'Bad_Content' and all other 
-- content as 'Good_Content'. Count how many items fall into each category.

		SELECT CASE
					WHEN description ILIKE '% kill%' OR description ILIKE '% violence%' THEN 'Bad_Content'
					ELSE 'Good_Content' END AS Category, COUNT(*)
					FROM netflix 
					GROUP BY category;

		
