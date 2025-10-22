#run in root like this: ./terminalCommands/1_dry_run_release.sh

cd terminalCommands

versionRaw=$(flutter pub add atreeon_datagrid_responsive --dry-run)
versionPub=$(echo "$versionRaw" | grep -o '+ atreeon_datagrid_responsive [0-9.]*' | awk '{print $3}')
versionLocal=$(grep 'version:' "../pubspec.yaml" | awk '{print $2}')

cd ../

echo "Ready to upload atreeon_datagrid_responsive version $versionLocal updating $versionPub"

read -p "Is this correct? (y/n): " choice

if [ "$choice" = "y" ]; then
  clear
  echo "Continuing..."
else
  exit 0
fi

flutter pub get
flutter pub run test

read -p "Did the tests pass? (y/n): " choice
if [ "$choice" = "y" ]; then
  clear
  echo "Continuing..."
else
  exit 0
fi

flutter pub publish --dry-run

read -p "Ready? (y/n): " choice
if [ "$choice" = "y" ]; then
  clear
  echo "All ready to upload..."
else
  exit 0
fi


