#!/bin/bash

# Check if arguments are missing.
if [ $# -eq 0 ]
  then
  echo "No arguments supplied"
  exit 0
fi

# Check if first argument is a number
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
  echo "\nerror: Not a number" >&2;
  exit 0
fi

# Check if zip command exists
if ! command -v zip &> /dev/null
then
    echo "zip could not be found"
    exit 0
fi

appDir=$2
versionsDir=$appDir/../versions

echo "\n #1 - Pull Frontend Repository START ..."
cd $appDir
git checkout dev
git pull origin dev
echo "\n #1 - Pull Frontend Repository END ..."



echo "\n #2 - Install Frontend Dependancies START ..."
npm install
echo "\n #2 - Install Frontend Dependancies END ..."



echo "\n #3 - Build Frontend START ..."

# Check if dist folder exists
[ -d dist ] && rm -rf dist
npm run build

echo "\n #3 - Build Frontend END ..."



echo "\n #4 - Versioning Frontend START ..."
# Ref. https://www.baeldung.com/linux/count-files-remove-oldest

echo "\n Replace Current Version with the new version"

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
    echo "dist folder does not exit in app folder"
    exit 0
fi

# move new build dist folder up to application root
mv $appDir/dist .

echo "\n Remove Old Versions"

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

echo "\n #4 - Versioning Frontend Done ..."