docker rm -f opengauss
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=Pass@123 -p 8003:5432 enmotech/opengauss:2.0.1

docker exec -u root -ti opengauss bash -c "apt-get update;apt install git -y;git clone https://github.com/vrajmohan/pgsql-sample-data.git ~/pgsql-sample-data;cd ~/pgsql-sample-data/employee;/entrypoint.sh gsql -d postgres -U gaussdb -W'Pass@123' -f employees.sql"
