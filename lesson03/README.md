lesson03
========

Датасет: https://www.kaggle.com/datasets/bwandowando/rotten-tomatoes-dreamworks-animation-movies

Файлы: critic_reviews.csv, movies.csv, user_reviews.csv

Шаги запуска
------------

1) Запустить docker compose в директории docker_hive
   
   cd docker_hive
   docker compose up -d

2) Определить id контейнера hive-server и назначить его переменной $HIVE_CONTAINER

3) Скачать датасет в директорию docker_hive/data (из kaggle либо с Яндекс.Диск - https://disk.yandex.ru/d/8LAAi2XlCQ_hvw)

4) Загрузить файлы в контейнер
   
   cd docker_hive/data
   sudo docker cp critic_reviews.csv $HIVE_CONTAINER:/tmp
   sudo docker cp movies.csv $HIVE_CONTAINER:/tmp
   sudo docker cp user_reviews.csv $HIVE_CONTAINER:/tmp
   cd ..
   sudo docker cp create_db.sql $HIVE_CONTAINER:/tmp

5) Зайти в контейнер

   sudo docker compose exec hive-server bash

6) Выполнить скрипт

   /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -f /tmp/create_db.sql



   
   

