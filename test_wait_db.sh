#!/bin/bash

CONTAINER_NAME="wait-db-test" && \
ROOT_PASSWORD="root" && \
DATABASE="base_example" && \
echo "-- Creating base SQL file" && \
  TMP_SQL=$(mktemp --suffix=.sql) && chmod 755 $TMP_SQL && \
  echo "CREATE TABLE example (id INT NOT NULL, PRIMARY KEY (id)); INSERT INTO example VALUES (1);" > $TMP_SQL && \
  \
echo "-- Testing waiting for an empty volume" && \
  ISO_NOW=$(date -uIs) && \
  docker run --name $CONTAINER_NAME \
    -e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
    -e MYSQL_DATABASE=$DATABASE \
    -v $TMP_SQL:/docker-entrypoint-initdb.d/base.sql \
    -v $CONTAINER_NAME:/var/lib/mysql \
    -d mysql:5.7 > /dev/null && \
  ./wait_db.sh docker --since "$ISO_NOW" $CONTAINER_NAME && \
  echo -n "Expected: 1, Found: " && \
  docker exec -i $CONTAINER_NAME mysql -N -u root -p$ROOT_PASSWORD $DATABASE <<< "select id from example" 2> /dev/null && \
  docker container stop $CONTAINER_NAME > /dev/null && \
  \
echo "-- Testing waiting for an already created volume" && \
  ISO_NOW=$(date -uIs) && \
  docker container start $CONTAINER_NAME > /dev/null && \
  ./wait_db.sh docker --since "$ISO_NOW" $CONTAINER_NAME && \
  echo -n "Expected: 1, Found: " && \
  docker exec -i $CONTAINER_NAME mysql -N -u root -p$ROOT_PASSWORD $DATABASE <<< "select id from example" 2> /dev/null && \
  \
echo "-- Cleaning tests" && \
  docker container stop $CONTAINER_NAME > /dev/null && \
  docker container rm -v $CONTAINER_NAME > /dev/null && \
  docker volume rm $CONTAINER_NAME > /dev/null && \
  rm $TMP_SQL
