# AWS EC2 Linux Docker Superset Postgres

## Resources

### AWS
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html

### Linux
https://danielmiessler.com/study/unixlinux_permissions/
https://www.booleanworld.com/introduction-linux-file-permissions/

### Docker
https://docs.docker.com/engine/docker-overview/
https://hub.docker.com/r/amancevice/superset/
https://medium.com/@vantakusaikumar562/integrating-superset-with-postgres-database-using-docker-c773304ec85e

### Postgres
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ConnectToPostgreSQLInstance.html

https://github.com/snowplow/snowplow/wiki/Setting-up-PostgreSQL
https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546
http://www.postgresqltutorial.com/postgresql-sample-database/
http://www.postgresql.org/docs/7.3/static/app-pgrestore.html
https://github.com/morenoh149/postgresDBSamples
https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e
```
    \l      list databases
    \c      connect with database
    \dt     describe all table
    \d+     describe table;
```

### Superset
https://medium.com/@vantakusaikumar562/integrating-superset-with-postgres-database-using-docker-c773304ec85e
https://galaxydatatech.com/2017/11/08/database-connection/
https://superset.incubator.apache.org/tutorial.html


## EC2 Instance
1. Service > EC2
1. Launch Instance
1. Amazon Linux 2 AMI (HVM), SSD Volume Type
1. t2.micro
1. Next: Configure Instance Details
1. Next: Add Storage << 30
1. Next: Add Tags << Name = your-name
1. Next: Configure Security Group
1. Open: 22, 80, 443, 5432
1. Review and Launch
1. Launch
1. Create and download secret-key.pem
1. Convert pem to ppk and follow next point
1. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html
1. ssh into your instance


## Install
```bash
sudo yum update -y
sudo yum install -y git tmux

git config --global credential.helper store
sudo amazon-linux-extras install docker -y
```

## Git
```bash
git config --global credential.helper store
git rm $(git status -s | awk '{print$2}')
```

## Docker
```bash
sudo systemctl start docker
#sudo service docker start

sudo usermod -aG docker ec2-user

sudo reboot
#sudo init 6

sudo systemctl start docker
#sudo service docker start

cat <<EOF> my.csv
a,b,c
1,2,3
EOF

docker pull amancevice/superset
docker run -d --name mysuper -p 80:8088 -v $HOME:/mnt/ec2-user amancevice/superset:latest
# -d daemonized; --name giveName; -p Port=host:container; -v volume; image
watch docker ps

docker exec -it mysuper superset-init
docker exec -it mysuper superset load_examples
# check ip in aws console

docker exec -u 0 -it mysuper /bin/bash
```

## Postgres
```bash
sudo yum install -y postgresql

psql \
   --host=postgres.cwo6qrkwq1ie.eu-central-1.rds.amazonaws.com \
   --port=5432 \
   --username=postgres \
   --dbname=postgres \
   --password


# sudo yum install -y postgresql-server postgresql-devel postgresql-contrib postgresql-docs
git clone https://github.com/morenoh149/postgresDBSamples.git

sudo -i
vim /var/lib/pgsql/data/postgresql.conf # line 59 listen_addresses='*', 63 uncomment
vim /var/lib/pgsql/data/pg_hba.conf # peer < trust
exit

sudo service postgresql start

sudo -u postgres psql
create database pagila;
create user superset with encrypted password 'superset';
grant all privileges on database pagila to superset;

psql -U postgres pagila < pagila-schema.sql
psql -U postgres pagila < pagila-data.sql

```


## Superset
```bash
DCID=$(docker ps -a | grep superset | awk '{print$1}')
DCID=$(docker ps -aq)

sudo -i
DCIP=$(grep $DCID /var/lib/docker/containers/$DCID*/hosts | awk '{print$1}')
echo -e "Add this to -- pg_hba.conf
    host    all             all             18.217.211.164/32            trust
Enter this in SQLAlchemy URI
    postgresql+psycopg2://DB_USER:DB_PASS@HOST_IP:5432/DB_NAME
    postgresql+psycopg2://superset:superset:18.217.211.163@5432/pagila
"
vim /var/lib/pgsql/data/pg_hba.conf
service postgresql restart
exit
```
1. Sources > Databases > Save
1. Sources > Tables >
    Table Name  = actor
    Database    = pagila
    Schema      = public

