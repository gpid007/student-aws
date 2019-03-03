# AWS EC2 Linux Docker Superset Postgres
```
18.184.254.12   fhwn-micro-0
18.194.209.133  fhwn-micro-1
```

## Resources

### AWS
https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/step-1-launch-instance.html  
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html  
https://aws.amazon.com/getting-started/tutorials/create-connect-postgresql-db/  

### Linux
https://danielmiessler.com/study/unixlinux_permissions/  
https://www.booleanworld.com/introduction-linux-file-permissions/  

#### Linux books
https://www.openvim.com/  
https://www.linode.com/docs/tools-reference/introduction-to-linux-concepts/  
https://www.ubuntupit.com/27-best-linux-tutorial-books-need-download-now/  

### Docker
https://docs.docker.com/engine/docker-overview/  
https://hub.docker.com/r/amancevice/superset/  
https://medium.com/@vantakusaikumar562/integrating-superset-with-postgres-database-using-docker-c773304ec85e  
https://docs.docker.com/engine/reference/commandline/ps/  

### Superset
https://vsupalov.com/flask-sqlalchemy-postgres/  
https://abhioncbr.github.io/docker-superset/  

### MariaDb
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ConnectToMariaDBInstance.html  
https://github.com/datacharmer/test_db  

### Postgres
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ConnectToPostgreSQLInstance.html  
```
Postgres commands:
    \l      list databases
    \c      connect with database
    \dt     describe all table
    \d+     describe table;
    \i      \i /path/to/exe.sql;
```

### Superset
https://medium.com/@vantakusaikumar562/integrating-superset-with-postgres-database-using-docker-c773304ec85e  
https://galaxydatatech.com/2017/11/08/database-connection/  
https://superset.incubator.apache.org/tutorial.html  
https://superset.incubator.apache.org/installation.html#database-dependencies  

## Install
```bash
sudo yum update -y 
sudo yum install -y git tmux mariadb #postgresql
sudo amazon-linux-extras install docker -y 
git config --global credential.helper store 
git clone https://github.com/datacharmer/test_db.git
echo -e "\nDone.\n"
```


## Docker
```bash
# sudo systemctl start docker
sudo service docker start 
sudo usermod -aG docker ec2-user 
echo -e "\nRebooting\n" 
sudo init 6 

sudo systemctl start docker 
docker pull abhioncbr/docker-superset
docker pull abhioncbr/docker-superset

echo -e " Docker commands:
    -d      daemonized 
    --name  giveName 
    -p      Port=host:container 
    -v      volume
"

docker run -d --name mysuper -p 80:8088 amancevice/superset:latest
watch docker ps
watch docker inspect --format '{{.State.Health.Status}}' $(docker ps -aq)

docker exec -it mysuper superset-init
docker exec -it mysuper superset load_examples


docker exec -u 0 -it mysuper /bin/bash

apt update -y
apt upgrade -y
apt install postgresql -y
```

## Postgres
```bash
sudo yum install -y postgresql
git clone https://github.com/morenoh149/postgresDBSamples.git

# First, connect and create database
export PGPASSWORD=postgres
psql \
    --host=postgres.cwo6qrkwq1ie.eu-central-1.rds.amazonaws.com \
    --port=5432 \
    --username=postgres \
#    --command 'create database usda'
    --dbname=usda \
    < /home/ec2-user/postgresDBSamples/usda-r18-1.0/usda.sql

# Superset connection string
postgresql+psycopg2://postgres:postgres@postgres.cwo6qrkwq1ie.eu-central-1.rds.amazonaws.com/pagila

echo -e ">> check all boxes but the one 'impersonate user'"
```

## MariaDb
```bash
USER=admin
PASSWORD=asdf5asdf5
git clone https://github.com/datacharmer/test_db 

mysql -h mariadb.cwo6qrkwq1ie.eu-central-1.rds.amazonaws.com -P 3306 -u admin -p < /home/ec2-user/test_db/employees.sql
mysql -h mariadb.cwo6qrkwq1ie.eu-central-1.rds.amazonaws.com -P 3306 -u admin -p

mysql://admin:asdf5asdf5@mariadb.cwo6qrkwq1ie.eu-central-1.rds.amazonaws.com:3306/employees
```

