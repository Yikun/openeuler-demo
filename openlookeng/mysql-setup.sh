docker rm -f mysql
docker run --name mysql -d --privileged=true -e MYSQL_ROOT_PASSWORD=Pass@123 -p 8002:3306 centos/mysql-80-centos7

docker exec -u root -ti mysql bash -c "yum install git -y;git clone https://github.com/Yikun/openeuler-demo.git;cd ~/openeuler-demo/openlookeng/mysql;mysql -uroot -t < employees.sql"
