CREATE DATABASE otus;
USE otus;

CREATE TABLE movies (
  id             STRING,
  name           STRING,
  year           INTEGER,
  url            STRING,
  rank           INTEGER,
  critic_score   STRING,
  audience_score STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\""
)  
tblproperties("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/tmp/movies.csv' OVERWRITE INTO TABLE otus.movies;

CREATE TABLE critic_reviews (
  id               INTEGER,
  movie_id  STRING,
  creation_data STRING,
  critic_name STRING,
  critic_page_url STRING,
  review_state STRING,
  is_fresh BOOLEAN,
  is_rotten BOOLEAN,
  is_rt_url BOOLEAN,
  is_top_critic BOOLEAN,
  publication_url STRING,
  publication_name STRING,
  review_url STRING,
  quote STRING,
  score_sentiment STRING,
  original_score STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\""
)  
tblproperties("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/tmp/critic_reviews.csv' OVERWRITE INTO TABLE otus.critic_reviews;

CREATE TABLE user_reviews (
  movie_id  STRING,
  rating DECIMAL(5,2),
  quote STRING,
  review_id STRING,
  is_verified BOOLEAN,
  is_super_reviewer BOOLEAN,
  has_spoilers BOOLEAN,
  has_profanity BOOLEAN,
  score DECIMAL(5,2),
  creation_date STRING,
  user_display_name STRING,
  user_realm STRING,
  user_id STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\""
)  
tblproperties("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/tmp/user_reviews.csv' OVERWRITE INTO TABLE otus.user_reviews;

CREATE VIEW top_movies
COMMENT "Show top 10 movies"
AS SELECT * FROM movies WHERE year >= 2010 ORDER BY rank LIMIT 10;

CREATE VIEW critic_review_count
COMMENT "Show review count grouped by critic name"
AS SELECT critic_name, count(*) FROM critic_reviews GROUP BY critic_name;

CREATE VIEW movie_critic_review_count
COMMENT "Show count of critic reviews grouped by movie name"
AS SELECT m.name, count(*) FROM movies m JOIN critic_reviews cr ON cr.movie_id = m.id GROUP BY m.name;

CREATE VIEW avg_user_rating
COMMENT "Show average score from user reviews grouped by movie name"
AS SELECT m.name, avg(ur.rating) FROM user_reviews ur JOIN movies m ON ur.movie_id = m.id GROUP BY m.name;

CREATE VIEW fresh_rotten_stat
COMMENT "Count fresh and rotten critic reviews by movie name"
AS SELECT m.name, count(case when is_fresh = 'True' then 1 else NULL end) AS fresh_count, count(case when is_rotten = 'True' then 1 else NULL end) AS rotten_count FROM critic_reviews cr JOIN movies m ON cr.movie_id = m.id GROUP BY m.name;


