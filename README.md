# wait_db

The main purpose of this project is to be able to wait for a database (for now, MySQL) running inside a container to be ready for connections after startup. All approaches I found rely on a script that tries over and over to connect to the database, or try to establish a TCP connection with the container. My approach in this script is to rely on the retrieved log from the container.

## How it works

The script will follow the log waiting for a specific string that represents the server is ready for connections. When the script finds the string then it will finish.

## Using the script

The script can be found on [wait_db.sh](https://github.com/marcelopbarros/waitdb/blob/master/wait_db.sh "wait_db.sh") and be used as follows:

```bash
wait_db [CONTAINER TYPE] [OPTIONS]
```

It can be way easier to see the examples below.


### Example 01: Using with Docker Compose

```bash
SERVICE_NAME="mysql" && \
docker-compose up -d $SERVICE_NAME && \
./wait_db.sh docker-compose --no-color $SERVICE_NAME
```

### Example 02: Using with Docker

```bash
CONTAINER_NAME="wait-db-test" && \
ISO_NOW=$(date -uIs) && \
  docker run --rm --name $CONTAINER_NAME \
    -e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
    -d mysql:5.7 && \
./wait_db.sh docker --since "$ISO_NOW" $CONTAINER_NAME
```

## Testing

A complete test can be found on the [test_wait_db.sh](https://github.com/marcelopbarros/waitdb/blob/master/test_wait_db.sh) file. Just put the two files (`test_wait_db.sh` and `wait_db.sh`) in a empty folder and then execute:

```bash
./test_wait_db.sh
```

## Technical

About the script, I'd like to register the reason I used the **double grep**. It seems like the function *follow* of docker (and docker-compose) does not exit *normally* when there is no new output from log. This way, the script can continue normally and, the *follow* command will finish as soon as a new entry to the console appears.

## Contributions

The script was made by me (Marcelo Barros). I hope it can helps anyone. It can be shared and modified as you want. If it's useful for you, the only thing I ask is to refer to this repository, so I can improve my code. Thanks!

