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

1. 📌 **Content Analysis** – Understand distribution by type, genre, and country  
2. ⭐ **Popularity Analysis** – Find common ratings, top actors, and directors  
3. 📊 **Trend Analysis** – Explore content added over the years and release patterns  
4. 🔍 **Content Classification** – Categorize movies and TV shows based on description keywords  

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

✅ Insight: Find the most popular ratings (PG, TV-MA, etc.) in movies vs TV shows.
