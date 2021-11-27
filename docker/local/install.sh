#!/bin/bash

if [[ $# -eq 0 ]] ; then
    read -r -p "What is the project name? (e.g. calibr8) " PROJECT_NAME
else
    PROJECT_NAME=$1
fi

PROJECT_ROOT=$LOKALHOST_PATH/projects/$PROJECT_NAME
PROJECT_DOCKER_FOLDER=$PROJECT_ROOT/repo/docker/local

SETTINGS_LOCAL_PATH=$PROJECT_ROOT/repo/web/sites/default/settings.local.php
if ! [[ -f "$SETTINGS_LOCAL_PATH" ]]; then
  echo "--- Creating settings.local.php ---"
  cp "$PROJECT_DOCKER_FOLDER"/setup/settings.local.php "$SETTINGS_LOCAL_PATH" || exit $?;
fi

# start containers
echo "--- Starting containers ---"
cd "$PROJECT_DOCKER_FOLDER" || exit $?;
mutagen compose up -d || exit $?;

# run composer install
echo "--- Running composer install ---"
docker-compose run --rm composer composer install --no-interaction --optimize-autoloader || exit $?;

# check if the database container is running
echo -n "Waiting until mysql is up"
until docker-compose exec mysql bash -c "mysql -uroot -proot -e 'show databases'" > /dev/null; do echo -n "."; done
echo -e "\nmysql is up & running!"

# Drupal sets de files/php/* folder to 777, so manual chmodding is required
# https://www.drupal.org/node/2486569
echo "--- Creating and setting folder rights and owner of private and files folder";
PUBLIC_FILES_FOLDER_PATH=$PROJECT_ROOT/repo/web/sites/default/files
if ! [[ -d $PUBLIC_FILES_FOLDER_PATH ]]; then
  mkdir -p "$PUBLIC_FILES_FOLDER_PATH"
fi
chmod -R 775 "$PUBLIC_FILES_FOLDER_PATH"

PRIVATE_FILES_FOLDER_PATH=$PROJECT_ROOT/repo/web/sites/default/private
if ! [[ -d $PRIVATE_FILES_FOLDER_PATH ]]; then
  mkdir -p "$PRIVATE_FILES_FOLDER_PATH"
fi
chmod -R 775 "$PRIVATE_FILES_FOLDER_PATH"

# In case you don't want a site install but import a DB from staging/production, uncomment the next lines and remove the
# commands that perform the site install.

## create database name by replacing dashes with underscores
#DB_NAME=$(echo "$PROJECT_NAME" | sed -e 's/-/_/g')
#echo "Next steps:"
#echo "1. Copy your DB dump to ${LOKALHOST_PATH}/storage-shared/mysql/imports"
#echo "2. Import your database in the ${DB_NAME} through the mysql container"
#echo "2. Import your database in the ${DB_NAME} through the mysql container"
#echo "3. Copy the settings.local.php to the default sites folder"
#echo "e.g. docker-compose exec mysql bash -c 'mysql -u root -proot ${DB_NAME} < /data/imports/[FILENAME]'"
#echo "--- Your site is now available at https://${PROJECT_NAME}.lokal.host ---"

# set drush path
DRUSH=/var/www/html/vendor/bin/drush

echo "--- Installing Drupal ---"
docker-compose exec --user www-data drupal bash -c "${DRUSH} -r /var/www/html/web si minimal --existing-config --account-name=calibrate --account-pass=drupal_admin --locale=nl --yes" || exit $?;

echo "--- Assign administrator role to superadmin ---"
docker-compose exec --user www-data drupal bash -c "${DRUSH} -r /var/www/html/web urol administrator calibrate" || exit $?;

echo "--- Import config that wasn't installed ---"
docker-compose exec --user www-data drupal bash -c "${DRUSH} -r /var/www/html/web cim --yes" || exit $?;

docker-compose exec --user www-data drupal bash -c "${DRUSH} -r /var/www/html/web cr -y";

echo "--- Your site is now available at https://htf-2021-student.lokal.host ---"
