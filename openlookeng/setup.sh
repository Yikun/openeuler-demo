docker rm -f mysql
docker run --name mysql -d --privileged=true -e MYSQL_ROOT_PASSWORD=Pass@123 -p 8001:3306 centos/mysql-80-centos7

docker exec -u root -ti mysql bash -c "yum install git -y;git clone https://github.com/datacharmer/test_db.git;cd test_db;mysql -uroot -t < employees.sql"


docker rm -f opengauss
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=Pass@123 -p 15432:5432 enmotech/opengauss:2.0.1

docker exec -u root -ti opengauss bash -c "apt-get update;apt install git -y;git clone https://github.com/vrajmohan/pgsql-sample-data.git ~/pgsql-sample-data;cd ~/pgsql-sample-data/employee;/entrypoint.sh gsql -d postgres -U gaussdb -W'Pass@123' -f employees.sql"
