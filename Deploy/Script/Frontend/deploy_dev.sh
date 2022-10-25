#!/bin/bash

# Check if arguments are missing.
if [ $# -eq 0 ]
  then
  echo -e "\n\e[1;31m ERROR: No arguments supplied \033[0m"
  exit 0
fi

# Check if first argument is a number
re='^[0-9]+$'
if ! [[ $1 =~ $re ]]
  then
  echo -e "\n\e[1;31mERROR: Not a number \033[0m"
  exit 0
fi

# Check if zip command exists
if ! command -v zip &> /dev/null
  then
  echo -e "\n\e[1;31m ERROR: zip could not be found \033[0m"
  exit 0
fi

appDir=$2
versionsDir=$appDir/../versions
branch=dev

echo -e "\n\e[1;32m #1 - Pull Frontend Repository START ... \033[0m"
cd $appDir
git checkout $branch
git pull origin $branch
echo -e "\n\e[1;32m #1 - Pull Frontend Repository END ... \033[0m"



echo -e "\n\e[1;32m #2 - Install Frontend Dependancies START ... \033[0m"
npm install
echo -e "\n\e[1;32m #2 - Install Frontend Dependancies END ... \033[0m"



echo -e "\n\e[1;32m #3 - Build Frontend START ... \033[0m"

# Check if dist folder exists
[ -d dist ] && rm -rf dist
npm run build

echo -e "\n\e[1;32m #3 - Build Frontend END ... \033[0m"



echo -e "\n\e[1;32m #4 - Versioning Frontend START ... \033[0m"
# Ref. https://www.baeldung.com/linux/count-files-remove-oldest

echo -e "\n\e[1;32m Replace Current Version with the new version \033[0m"

# Move up one level to application root
cd $appDir/..

# Create Versions Folder if not exists
mkdir -p $versionsDir

# Check if dist folder exists to move it to versions folder
if [ -d dist ]
  then
  zip -r dist.zip dist
  mv dist.zip versions/dist_$(date +%d%m%Y-%H%M%S).zip
  rm -rf dist
fi


# Check if dist foldre exists in the application directory
if [ ! -d $appDir/dist ]
  then
  echo -e "\n\e[1;31m ERROR: dist folder does not exit in app folder \033[0m"
  exit 0
fi

# move new build dist folder up to application root
mv $appDir/dist .

echo -e "\n\e[1;32m Remove Old Versions \033[0m"

# The script receives the limit as an argument.
limit=$1

number_of_files=0
if [ -n "$(ls -A $versionsDir/dist_* 2>/dev/null)" ]
  then
  number_of_files=$(ls $versionsDir/dist_* | wc -l)
fi

if [ $number_of_files -gt $limit ]
  then
  # There are more files than the limit
  # So we need to remove the older ones.
  ls -1td dist_* | tail --lines=+$(expr $limit + 1) | xargs -d '\n' rm
fi

echo -e "\n\e[1;32m #4 - Versioning Frontend Done ... \033[0m"