echo -e "\e[32mStep 1: Show OS info \e[0m"
read -p "Press key to continue"
echo "# cat /etc/os-release"
cat /etc/os-release
echo "# uname -m"
uname -m

echo -e "\n\e[32mStep 2: Show openGauss DB schema \e[0m"
read -p "Press key to continue"
echo "> \d"
docker exec -u root -ti opengauss bash -c "echo '\d employees' | /entrypoint.sh gsql -d postgres -U gaussdb -W'Pass@123'"

echo -e "\n\e[32mStep 3: Query employees counts in openGauss\e[0m"
read -p "Press key to continue"
echo "> select count(*) from employees;"
docker exec -u root -ti opengauss bash -c "echo 'select count(*) from employees;' | /entrypoint.sh gsql -d postgres -U gaussdb -W'Pass@123'"