#run in root like this: ./terminalCommands/2_release.sh

echo blah

cd terminalCommands || exit
./1_dry_run_release.sh
cd ../

read -p "Do you want to publish atreeon_datagrid_responsive? (y/n): " choice
if [ "$choice" = "y" ]; then
  clear
  flutter pub publish
else
  exit 0
fi


versionLocal=$(grep 'version:' "pubspec.yaml" | awk '{print $2}')

read -p "Do you want to tag atreeon_datagrid_responsive as $versionLocal? (use 'i' to insert, 'esc' to finish editing, ':' for console, 'wq' to save (y/n): " choice
if [ "$choice" = "y" ]; then
  clear
  git tag "$versionLocal" -a
else
  exit 0
fi

echo "now please commit and push and remember to PUSH THE TAG!!!"
