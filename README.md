# 📺 Netflix SQL Project – Movies & TV Shows Data Analysis

![Netflix Logo](https://raw.githubusercontent.com/himanshujoshitech/Netflix_SQL_Project/main/logo.png)

---

## 🌟 Overview

The **Netflix SQL Project** is a comprehensive **data analysis project** on Netflix’s movies and TV shows dataset. The project uses **PostgreSQL** to explore patterns, trends, and insights across various aspects of Netflix content.

Key highlights:

- Analyze **content distribution**: Movies vs TV Shows  
- Explore **popular genres, ratings, actors, and directors**  
- Identify **top producing countries** and content trends  
- Investigate **content release trends over the last 5–10 years**  
- Categorize content as **family-friendly or violent** using keyword analysis  

This project demonstrates practical **SQL skills** including aggregate functions, string and date manipulation, conditional logic, and analytical queries.

---

## 🎯 Objectives

1. **Content Analysis** – Understand distribution by type, genre, and country  
2. **Popularity Analysis** – Find common ratings, top actors, and directors  
3. **Trend Analysis** – Explore content added over the years and release patterns  
4. **Content Classification** – Categorize movies and TV shows based on description keywords  

---

## 🛠️ Tools & Technologies

- **Database:** PostgreSQL  
- **SQL Concepts Used:**  
  - Aggregate functions (`COUNT`, `MAX`, `AVG`)  
  - Conditional queries (`CASE WHEN`)  
  - String manipulation (`STRING_TO_ARRAY`, `UNNEST`, `TRIM`, `SPLIT_PART`)  
  - Date handling (`TO_DATE`, `EXTRACT`)  
  - Ranking & window functions (`RANK() OVER(PARTITION BY ...)`)  
  - Filtering with `WHERE`, `ILIKE`, `AND`, `OR`  

---

## 📊 Dataset Description

The dataset contains information about **movies and TV shows on Netflix**.

| Column Name    | Description |
|----------------|-------------|
| `show_id`      | Unique ID of the content |
| `type`         | Movie or TV Show |
| `title`        | Name of the content |
| `director`     | Director name |
| `cast`         | Actors in the content |
| `country`      | Country of production |
| `date_added`   | Date added to Netflix |
| `release_year` | Year of release |
| `rating`       | Content rating (PG, R, etc.) |
| `duration`     | Movie duration or number of seasons |
| `listed_in`    | Genres |
| `description`  | Brief summary of content |

---

**Dataset Download Link:** [Netflix Shows Dataset on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)


## 💡 Business Problems & Solutions

Here’s an **interactive summary** of the queries and insights generated:

### 1️⃣ Movies vs TV Shows Count
```sql
SELECT type, COUNT(*) AS number_of_movies
FROM netflix
GROUP BY type;
```

✅ **Insight**: Understand the distribution of movies and TV shows on Netflix.

### 2️⃣ Most Common Rating per Type
```sql
SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*),
    RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) AS t1
WHERE ranking = 1;
```

✅ **Insight**: Find the most popular ratings (PG, TV-MA, etc.) in movies vs TV shows.

### 3️⃣ Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT title
FROM netflix
WHERE type = 'Movie' 
  AND release_year = 2020;
```

✅ **Insight**: Filter movies released in a specific year.

### 4️⃣ Top 5 Countries by Content Count
```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country,
       COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;
```

✅ **Insight**: Identify which countries produce the most Netflix content (handles multiple countries per row).

### 5️⃣ Identify the Longest Movie
```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND duration = (
    SELECT MAX(duration) FROM netflix WHERE type = 'Movie'
);
```

✅ **Insight**: Find the movie with the longest runtime.

### 6️⃣ Find Content Added in Last 5 Years
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

✅ **Insight**: Retrieve content that was added to Netflix in the last 5 years.

### 7️⃣ Movies / TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

✅ **Insight**: List all content (movies & TV shows) directed by Rajiv Chilaka.

### 8️⃣ TV Shows with More than 5 Seasons
```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(TRIM(duration), ' ', 1)::numeric > 5;
```

✅ **Insight**: List TV shows having more than 5 seasons (uses TRIM to avoid spacing issues).

### 9️⃣ Count the Number of Content Items in Each Genre
```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
       COUNT(show_id) AS total_count
FROM netflix
GROUP BY 1
ORDER BY total_count DESC;
```

✅ **Insight**: Get how many items belong to each genre (splits multi-genre rows).

### 🔟 Yearly Content Percentage in India
```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
       COUNT(*) AS yearly_content,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%'), 2) AS percentage_content
FROM netflix
WHERE country ILIKE '%India%'
  AND date_added IS NOT NULL
GROUP BY 1
ORDER BY 1;
```

✅ **Insight**: For each year, show total Indian content and that year’s percentage share of all Indian content.

### 1️⃣1️⃣ List All Movies That Are Documentaries
```sql
SELECT *
FROM netflix
WHERE listed_in ILIKE '%documentaries%';
```

✅ **Insight**: Find movies that belong to documentary genre(s).

### 1️⃣2️⃣ Find All Content Without a Director
```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```

✅ **Insight**: Detect rows with missing director information (NULL or empty string).

### 1️⃣3️⃣ Movies with 'Salman Khan' in Last 10 Years
```sql
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND type = 'Movie'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

✅ **Insight**: Count/list movies that include Salman Khan released in the last 10 years (inclusive).

### 1️⃣4️⃣ Top 10 Actors in Indian Movies
```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
       COUNT(show_id) AS movies
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY movies DESC
LIMIT 10;
```

✅ **Insight**: Identify actors who appear most frequently in Indian movies on Netflix.

### 1️⃣5️⃣ Categorize Content as Bad or Good Based on Keywords
```sql
SELECT CASE
         WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
         ELSE 'Good_Content'
       END AS category,
       COUNT(*) AS total_count
FROM netflix
GROUP BY category;
```

✅ **Insight**: Classify content by presence of violent keywords in descriptions and count per category.

## 🧠 Key Skills Demonstrated

Writing complex SQL queries with subqueries, aggregates, and window functions

Performing data cleaning and transformation using string and date functions

Categorizing data dynamically using CASE expressions

Handling multi-valued fields via ```sql STRING_TO_ARRAY``` + UNNEST (and TRIM)

Using PostgreSQL features like RANK(), TO_DATE(), and window functions


## ✅ Conclusion

This project demonstrates practical SQL-based data analysis on a real-world dataset (Netflix). It is suitable for:

Data analysts learning SQL

Candidates who want project examples for portfolios/GitHub

Anyone interested in exploring streaming-platform data via SQL

You can copy these queries into your PostgreSQL environment to reproduce results and refine them for presentation or visualization.
