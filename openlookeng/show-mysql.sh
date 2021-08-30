echo -e "\e[32mStep 1: Show OS info \e[0m"
read -p "Press key to continue"
echo "# cat /etc/os-release"
cat /etc/os-release
echo "# uname -m"
uname -m

echo -e "\n\e[32mStep 2: Show MySQL DB schema \e[0m"
read -p "Press key to continue"
docker exec -u root -ti mysql bash -c "mysql -uroot employees -e 'desc employees;'"

echo -e "\n\e[32mStep 3: Query employees counts in MySQL\e[0m"
read -p "Press key to continue"
echo "> select count(*) from employees;"
docker exec -u root -ti mysql bash -c "mysql -uroot employees -e 'select count(*) from employees;'"

